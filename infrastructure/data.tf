data "template_file" "container_definition" {
  template = file("container_definition.tpl")

  vars = {
    application = var.application
    commit_hash = var.commit_hash
  }
}

data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"
  workspace = terraform.workspace

  config = {
    bucket = "tf-tcc-infra-state"
    key    = "ecs-cluster.state"
    region = "us-east-1"
  }
}