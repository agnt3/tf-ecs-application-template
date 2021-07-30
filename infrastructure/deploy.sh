#!/usr/bin/env bash

deploy() {
  echo "Starting Deployment..."
  echo "Commit Hash: $GITHUB_SHA"

  __export_commit_hash_to_terraform
  terraform apply -var-file="production.tfvars" -auto-approve
}

dockerize() {
  IMAGE_NAME=leonardocordeiro/ecs-example-app:$GITHUB_SHA

  docker build -t $IMAGE_NAME $(dirname $PWD)
  docker push $IMAGE_NAME
}

__export_commit_hash_to_terraform() {
  export TF_VAR_commit_hash=$GITHUB_SHA
}

case $1 in
  "run")
      deploy;;
  "dockerize")
      dockerize;;
esac