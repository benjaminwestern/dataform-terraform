# Bind data to the default gcs service account
data "google_storage_project_service_account" "gcs_account" {
  project = var.project_id
}

# Allow the default gcs service account to publish to pubsub
resource "google_project_iam_member" "gcs_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

# Creates eventarc service account
resource "google_service_account" "event_arc_sa" {
  account_id   = "event-arc-${data.google_project.project.number}"
  display_name = "A service account utilised for eventarc to trigger workflows"
}

# Assigns roles to eventarc service account
resource "google_project_iam_member" "event_arc_default_sa_roles" {
  for_each = toset(var.eventarc_sa_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.event_arc_sa.email}"
}

# Creates workflow service account
resource "google_service_account" "workflow_sa" {
  account_id   = "workflow-${data.google_project.project.number}"
  display_name = "A service account utilised for workflow to trigger dataform"
}

# Assigns roles to workflow service account
resource "google_project_iam_member" "workflow_default_sa_roles" {
  for_each = toset(var.workflow_sa_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.workflow_sa.email}"
}

# Create the workflow
resource "google_workflows_workflow" "gcs_dataform_workflow" {
  name            = "bucket-dataform-workflow"
  description     = "Trigger Dataform when a file is uploaded to GCS"
  project         = var.project_id
  region          = var.region
  service_account = google_service_account.workflow_sa.id
  source_contents = file("${local._base_dir}workflows/dataform.yaml")
}

# Create the Event Arc trigger
resource "google_eventarc_trigger" "new_file_trigger" {
  name     = "new-file-trigger"
  location = var.region

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.storage.object.v1.finalized"
  }
  matching_criteria {
    attribute = "bucket"
    value     = google_storage_bucket.dataform_input_data.name
  }

  destination {
    workflow = google_workflows_workflow.gcs_dataform_workflow.id
  }

  service_account = google_service_account.event_arc_sa.email
}
