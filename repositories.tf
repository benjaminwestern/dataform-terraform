data "http" "github" {
  url = "https://api.github.com/meta"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

data "http" "bitbucket" {
  url = "https://bitbucket.org/site/ssh"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

locals {
  vcs = {
    github    = [for key in jsondecode(data.http.github.response_body).ssh_keys : key if strcontains(key, "ssh-rsa")][0]
    bitbucket = "ssh-rsa ${regex("bitbucket\\.org ssh-rsa ([^\r\n]+)", data.http.bitbucket.response_body)[0]}"
  }
}

resource "google_dataform_repository" "dataform_respository" {
  provider        = google-beta
  project         = var.project_id
  region          = var.region
  name            = var.name
  service_account = module.dataform-sa.email

  git_remote_settings {
    url            = var.repository_url
    default_branch = var.default_branch_name
    ssh_authentication_config {
      user_private_key_secret_version = "${module.dataform-ssh-key.ids["dataform-ssh-key"]}/versions/latest"
      host_public_key                 = local.vcs[var.vcs]
    }
  }
}

