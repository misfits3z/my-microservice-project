terraform {
  backend "s3" {
    bucket       = "didenko-terraform-states"
    key          = "lesson-5/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
    profile      = "terraform"
  }
}
