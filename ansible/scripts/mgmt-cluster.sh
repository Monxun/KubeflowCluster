#!/bin/bash

gcloud auth login
gcloud auth configure-docker \
    us-west1-docker.pkg.dev

gcloud components install kubectl kustomize kpt anthoscli beta
gcloud components update

git clone https://github.com/kubeflow/gcp-blueprints.git 
cd gcp-blueprints
git checkout tags/v1.5.0 -b v1.5.0
cd management

export MGMT_PROJECT=kubeflow-gke  # <the project where you deploy your management cluster>
export MGMT_NAME=flow-mgmt                 # <name of your management cluster>
export LOCATION=us-west1                  # <location of your management cluster, use either us-central1 or us-east1>

source env.sh