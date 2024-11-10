
provider "google" {
  region  = var.region
  project = var.project_id
}
provider "google-beta" {
  region  = var.region
  project = var.project_id
}

terraform {
  backend "gcs" {
    bucket = ""
    prefix = "terraform/state"
  }
}
