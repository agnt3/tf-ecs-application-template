#!/usr/bin/env bash

dockerize() {
  IMAGE_NAME=$(__get_image_name)

  docker build -t $IMAGE_NAME $(dirname $PWD)
  docker push $IMAGE_NAME
}

deploy() {
  echo "Starting Deployment..."
  echo "Commit Hash: $GITHUB_SHA"

  __export_commit_hash_to_terraform
  terraform apply -var-file="production.tfvars" -auto-approve
}

destroy() {
  echo "Starting Destroy..."

  __export_commit_hash_to_terraform
  terraform destroy -var-file="production.tfvars" -auto-approve
}

__get_image_name() {
  echo "leonardocordeiro/ecs-example-app:$GITHUB_SHA"
}

__export_commit_hash_to_terraform() {
  export TF_VAR_commit_hash=$GITHUB_SHA
}

case $1 in
  "run")
      deploy;;
  "dockerize")
      dockerize;;
  "destroy")
      destroy;;
esac