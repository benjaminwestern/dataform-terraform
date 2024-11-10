locals {
  _base_dir = "./"
}

data "google_project" "project" {
  project_id = var.project_id
}

data "google_secret_manager_secret_version" "ssh_key" {
  secret     = "ssh_key"
  depends_on = [google_secret_manager_secret.ssh_key]
}

# Builds a bucket to store the dataform input data
resource "google_storage_bucket" "dataform_input_data" {
  name          = "dataform-ingest-${var.project_id}"
  location      = var.region
  force_destroy = true
  project       = var.project_id

  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true
}

# Assigns the dataform service account as Storage Admin to the bucket
resource "google_storage_bucket_iam_member" "dataform_input_data" {
  bucket = google_storage_bucket.dataform_input_data.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_project_service_identity.default_da_sa.email}"
}

# Enable the apis
resource "google_project_service" "enable_apis" {
  for_each = toset(var.apis_to_enable)
  project  = var.project_id
  service  = each.key

  timeouts {
    create = "30m"
    update = "40m"
  }
  disable_dependent_services = true
}

# Gets a reference to the default dataform service account
resource "google_project_service_identity" "default_da_sa" {
  provider = google-beta
  project  = data.google_project.project.project_id
  service  = "dataform.googleapis.com"
}

# Assigns roles to dataform service account
resource "google_project_iam_member" "dataform_default_sa_roles" {
  for_each = toset(var.dataform_sa_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_project_service_identity.default_da_sa.email}"
}

# Manually add the private access key to the secret manager key after creating the secret
resource "google_secret_manager_secret" "ssh_key" {
  project   = var.project_id
  secret_id = "ssh_key"

  replication {
    auto {}
  }
  depends_on = [google_project_service.enable_apis]
}

# Create the secret iam member binding
resource "google_secret_manager_secret_iam_member" "dataform_member" {
  for_each   = toset(var.secret_roles)
  project    = var.project_id
  secret_id  = google_secret_manager_secret.ssh_key.secret_id
  role       = each.value
  member     = "serviceAccount:${google_project_service_identity.default_da_sa.email}"
  depends_on = [google_secret_manager_secret.ssh_key]
}

# Create the dataform repository
resource "google_dataform_repository" "dataform_respository" {
  provider = google-beta
  name     = "dataform"
  region   = var.region
  project  = var.project_id

  git_remote_settings {
    url            = var.repository_url
    default_branch = var.branch_name
    ssh_authentication_config {
      user_private_key_secret_version = data.google_secret_manager_secret_version.ssh_key.id
      host_public_key                 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=" #Github Public SSH Reference
      # host_public_key                 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQeJzhupRu0u0cdegZIa8e86EG2qOCsIsD1Xw0xSeiPDlCr7kq97NLmMbpKTX6Esc30NuoqEEHCuc7yWtwp8dI76EEEB1VqY9QJq6vk+aySyboD5QF61I/1WeTwu+deCbgKMGbUijeXhtfbxSxm6JwGrXrhBdofTsbKRUsrN1WoNgUa8uqN1Vx6WAJw1JHPhglEGGHea6QICwJOAr/6mrui/oB7pkaWKHj3z7d1IC4KWLtY47elvjbaTlkN04Kc/5LFEirorGYVbt15kAUlqGM65pk6ZBxtaO3+30LVlORZkxOh+LKL/BvbZ/iRNhItLqNyieoQj/uh/7Iv4uyH/cV/0b4WDSd3DptigWq84lJubb9t/DnZlrJazxyDCulTmKdOR7vs9gMTo+uoIrPSb8ScTtvw65+odKAlBj59dhnVp9zd7QUojOpXlL62Aw56U4oO+FALuevvMjiWeavKhJqlR7i5n9srYcrNV7ttmDw7kf/97P5zauIhxcjX+xHv4M=" #BitBucket Public SSH Reference
    }
  }

  # workspace_compilation_overrides can be used here if needed
}

resource "google_dataform_repository_release_config" "production" {
  provider = google-beta

  project    = google_dataform_repository.dataform_respository.project
  region     = google_dataform_repository.dataform_respository.region
  repository = google_dataform_repository.dataform_respository.name

  name          = "production"
  git_commitish = "main"
  cron_schedule = "0 2 * * *" # 2am daily
  time_zone     = "Australia/Sydney"
}

resource "google_dataform_repository_workflow_config" "reporting_workflow" {
  provider = google-beta

  project        = google_dataform_repository.dataform_respository.project
  region         = google_dataform_repository.dataform_respository.region
  repository     = google_dataform_repository.dataform_respository.name
  name           = "reporting-workflow"
  release_config = google_dataform_repository_release_config.production.id

  invocation_config {
    # included_targets can also be used here:
    # these are defined by database (project), schema (dataset) and name (table), all are optional, name is 'action' in the UI
    included_tags                            = ["daily"]
    transitive_dependencies_included         = true
    transitive_dependents_included           = true
    fully_refresh_incremental_tables_enabled = false
    service_account                          = google_project_service_identity.default_da_sa.email
  }

  cron_schedule = "0 8 * * *" # 8am daily
  time_zone     = "Australia/Sydney"
}

resource "google_dataform_repository_workflow_config" "reporting_workflow_2" {
  provider = google-beta

  project        = google_dataform_repository.dataform_respository.project
  region         = google_dataform_repository.dataform_respository.region
  repository     = google_dataform_repository.dataform_respository.name
  name           = "reporting-workflow-2"
  release_config = google_dataform_repository_release_config.production.id

  invocation_config {
    included_targets {
      schema = "intermediate"
      name   = "parsed_sample"
    }
    transitive_dependencies_included         = true
    transitive_dependents_included           = true
    fully_refresh_incremental_tables_enabled = false
    service_account                          = google_project_service_identity.default_da_sa.email
  }

  cron_schedule = "0 8 * * *" # 8am daily
  time_zone     = "Australia/Sydney"
}
