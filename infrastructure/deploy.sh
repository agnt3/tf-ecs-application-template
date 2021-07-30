#!/usr/bin/env bash

COMMIT_HASH=$1

deploy() {
  echo "Starting Deployment..."
  echo "Commit Hash: $COMMIT_HASH"

  export TF_VAR_commit_hash=$COMMIT_HASH
  terraform apply -var-file="production.tfvars" -auto-approve
}

dockerize() {
  IMAGE_NAME=leonardocordeiro/ecs-example-app:$COMMIT_HASH

  docker build -t $IMAGE_NAME $(dirname $PWD)
  docker push $IMAGE_NAME
}

case $2 in
  "deploy")
      deploy;;
  "dockerize")
      dockerize;;
esac