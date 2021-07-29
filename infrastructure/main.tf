provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 0.12.9"
  backend "s3" {
    bucket = "tf-tcc-infra-state"
    key    = "ecs-application.state"
    region = "us-east-1"
  }
}
