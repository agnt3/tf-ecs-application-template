#!/usr/bin/env bash

deploy() {
  export TF_VAR_commit_hash=$1
  echo "Commit Hash: $TF_VAR_commit_hash"
  terraform apply -var-file="production.tfvars" -auto-approve
}