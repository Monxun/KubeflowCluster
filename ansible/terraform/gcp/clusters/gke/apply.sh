#!/usr/bin/env bash

export DEPLOYMENT_NAME=${PWD##*/}  

# Start from a clean slate
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

gcloud container clusters get-credentials kubeflow-cluster-gke --zone=us-west1
gcloud container clusters get-credentials kubeflow-cluster-gke --zone=us-west1