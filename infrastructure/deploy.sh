#!/usr/bin/env bash
set -euo pipefail

echo "Commit Hash: $GITHUB_SHA"
export TF_VAR_commit_hash=$GITHUB_SHA

dockerize() {
  IMAGE_NAME=$(__get_image_name)

  docker build -t $IMAGE_NAME $(dirname $PWD)
  docker push $IMAGE_NAME
}

deploy() {
  echo "Starting Deployment..."

  __terraform apply
}

destroy() {
  echo "Starting Destroy..."

  __terraform destroy
}

__get_image_name() {
  echo "leonardocordeiro/ecs-example-app:$GITHUB_SHA"
}

__terraform() {
  CMD="terraform $1 -var-file='production.tfvars' -auto-approve"
  eval $CMD
}

case $1 in
  "run")
      deploy;;
  "dockerize")
      dockerize;;
  "destroy")
      destroy;;
esac