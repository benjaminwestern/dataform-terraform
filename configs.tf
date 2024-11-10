# workspace config 
locals {
  configs = {
    for f in try(fileset("./${var.base_dir}", "**/*.yaml"), []) :
    basename(trimsuffix(f, ".yaml")) => yamldecode(file("./${var.base_dir}/${f}"))
  }

  workflows = flatten([for config_keys, config_values in local.configs : [for workflow_keys, workflow_values in config_values.workflows : merge(workflow_values, { "branch" = config_keys, "name" = workflow_keys })]])
}

data "google_client_config" "default" {
}

data "http" "workspace" {
  for_each = local.configs
  url      = "https://dataform.googleapis.com/v1beta1/projects/${var.project_id}/locations/${var.region}/repositories/${google_dataform_repository.dataform_respository.name}/workspaces?workspaceId=${each.key}"

  method = "POST"

  request_headers = {
    "Authorization" = "Bearer ${data.google_client_config.default.access_token}"
    "Content-Type"  = "application/json"
  }

  request_body = jsonencode({
    name = each.key
  })
}

resource "google_dataform_repository_release_config" "release_config" {
  for_each = local.configs
  provider = google-beta

  project    = var.project_id
  region     = var.region
  repository = google_dataform_repository.dataform_respository.name

  name          = each.key
  git_commitish = each.key
  cron_schedule = each.value.release.cron_schedule
  time_zone     = lookup(each.value.release, "time_zone", null)

  code_compilation_config {
    assertion_schema = lookup(each.value.release.code_compilation_config, "assertion_schema", null)
    database_suffix  = lookup(each.value.release.code_compilation_config, "database_suffix", null)
    default_database = lookup(each.value.release.code_compilation_config, "default_database", null)
    default_location = lookup(each.value.release.code_compilation_config, "default_location", null)
    default_schema   = lookup(each.value.release.code_compilation_config, "default_schema", null)
    schema_suffix    = lookup(each.value.release.code_compilation_config, "schema_suffix", null)
    table_prefix     = lookup(each.value.release.code_compilation_config, "table_prefix", null)
    vars             = lookup(each.value.release.code_compilation_config, "vars", null)
  }
}

resource "google_dataform_repository_workflow_config" "workflow_config" {
  for_each = { for values in local.workflows : "${values.name}-${values.branch}" => values }
  provider = google-beta

  project = var.project_id
  region  = var.region
  name    = each.value.name

  repository     = google_dataform_repository.dataform_respository.name
  release_config = google_dataform_repository_release_config.release_config[each.value.branch].id

  cron_schedule = each.value.cron_schedule
  time_zone     = each.value.time_zone

  invocation_config {
    dynamic "included_targets" {
      for_each = lookup(each.value.invocation_config, "included_targets", [])
      content {
        database = included_targets.value.database
        schema   = included_targets.value.schema
        name     = included_targets.key
      }
    }
    included_tags                            = lookup(each.value.invocation_config, "included_tags", [])
    transitive_dependencies_included         = lookup(each.value.invocation_config, "transitive_dependencies_included", null)
    transitive_dependents_included           = lookup(each.value.invocation_config, "transitive_dependents_included", null)
    fully_refresh_incremental_tables_enabled = lookup(each.value.invocation_config, "fully_refresh_incremental_tables_enabled", null)
    service_account                          = lookup(each.value.invocation_config, "service_account", null)
  }
}

resource "random_uuid" "check" {
  for_each = local.configs
  lifecycle {
    precondition {
      condition     = contains([201, 200, 204, 409], data.http.workspace[each.key].status_code)
      error_message = "Error: ${data.http.workspace[each.key].response_body}. Please update the GitHub SSH Token Secret in Secrets Manager - ${module.dataform-ssh-key.ids["dataform-ssh-key"]}/versions/latest"
    }
  }

  depends_on = [
    data.http.workspace,
    google_dataform_repository.dataform_respository,
    google_dataform_repository_release_config.release_config,
    google_dataform_repository_workflow_config.workflow_config
  ]
}
