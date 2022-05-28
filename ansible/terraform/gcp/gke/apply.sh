#!/bin/sh

terraform init
terraform apply
gcloud container clusters get-credentials kubeflow-cluster-gke --zone=us-west1
gcloud container clusters get-credentials kubeflow-cluster-gke --zone=us-west1