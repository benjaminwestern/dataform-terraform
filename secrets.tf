module "dataform-ssh-key" {
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/secret-manager?ref=v36.0.1"
  project_id = var.project_id
  secrets = {
    dataform-ssh-key = {
      locations = [var.region]
    }
  }
  versions = {
    dataform-ssh-key = {
      # create an initial version - user to update with their own!
      v1 = { enabled = false, data = "init_value" }
    }
  }
  iam = {
    dataform-ssh-key = {
      "roles/secretmanager.secretAccessor" = ["serviceAccount:service-${module.project.number}@gcp-sa-dataform.iam.gserviceaccount.com"]
    }
  }
}
