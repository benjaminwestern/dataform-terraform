module "dataform-terraform" {
  source = "../../"

  project_id          = "dummy-project"
  region              = "australia-southeast1"
  repository_url      = "git@github.com:<github-user>/dataform.git"
  vcs                 = "github"
  base_dir            = "configs"
  default_branch_name = "main"
}
