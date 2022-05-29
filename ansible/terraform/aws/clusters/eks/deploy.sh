#!/usr/bin/env bash

# set -e

# source vars.sh

# Start from a clean slate

export DEPLOYMENT_NAME=${PWD##*/}  

rm -rf .terraform

terraform init

terraform plan \
    -lock=false \
    -input=false \
    -out=tf-$DEPLOYMENT_NAME.plan

terraform apply \
    -input=false \
    -auto-approve=true \
    -lock=false \
    tf-$DEPLOYMENT_NAME.plan

# kubectl konfig import -s kubeconfig_mg-aline-eks
aws eks --region us-west-2 update-kubeconfig --name mg-aline-eks
