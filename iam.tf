module "project" {
  source         = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/project?ref=v36.0.1"
  name           = var.project_id
  project_create = false

  services = [
    "storage.googleapis.com",
    "stackdriver.googleapis.com",
    "compute.googleapis.com",
    "dataform.googleapis.com",
    "bigquery.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "billingbudgets.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}

module "dataform-sa" {
  source       = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/iam-service-account?ref=v36.0.1"
  project_id   = var.project_id
  name         = "dataform-runner"
  display_name = "Dataform Runner"
  description  = "Dataform Runner Service Account with the necessary roles to run dataform workflows, access Buckets and BigQuery"
  iam = {
    for role in toset([
      "roles/iam.serviceAccountTokenCreator",
      "roles/iam.serviceAccountUser"
    ]) :
    "${role}" => ["serviceAccount:service-${module.project.number}@gcp-sa-dataform.iam.gserviceaccount.com"]
  }
  iam_project_roles = {
    (var.project_id) = [
      "roles/bigquery.dataEditor",
      "roles/bigquery.jobUser",
      "roles/bigquery.user",
      "roles/bigquery.dataOwner"
    ]
  }
}
