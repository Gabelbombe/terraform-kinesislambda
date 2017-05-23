#!/usr/bin/env bash -ue

## Will add when linked into S3 Bucket ~jd
# ## configure remote s3 state
# terraform remote config                                       \
#   -backend=s3                                                 \
#   -backend-config="bucket=app-terraform-deployments"          \
#   -backend-config="key=deployment_states/app.dev.tfstate"     \
#   -backend-config="region=us-west-2"
#
# ## up new infra
# terraform plan -var-file=./dev.tfvars
# terraform apply -var-file=./dev.tfvars

terraform plan
terraform deploy
