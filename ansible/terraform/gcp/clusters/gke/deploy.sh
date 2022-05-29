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

# GRAB KUBECONFIG FOR NEW CLUSTER
gcloud container clusters get-credentials kubeflow-cluster-gke --zone=$GCP_REGION
