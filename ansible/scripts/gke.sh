#!/bin/bash

export NAME=kubeflow
export CHANNEL=regular
export PROJECT=kubeflow-gke
export NODE_POOL=kubeflow-np
export SERVICE_ACCOUNT_NAME=kubeflow-sa
export NAMESPACE=sidecar

gcloud container clusters create $NAME \
    --release-channel $CHANNEL \
    --addons ConfigConnector \
    --workload-pool=$PROJECT_ID .svc.id.goog \
    --logging=SYSTEM \
    --monitoring=SYSTEM

gcloud container node-pools update $NODE_POOL
    --workload-metadata=GKE_METADATA \
    --cluster $NAME

gcloud container clusters update $NAME
    --update-addons ConfigConnector=ENABLED

gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME

gcloud projects add-iam-policy-binding $PROJECT
    --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com" \
    --role="roles/editor"

gcloud iam service-accounts add-iam-policy-binding \
$SERVICE_ACCOUNT_NAME@$PROJECT.iam.gserviceaccount.com \
    --member="serviceAccount:${PROJECT}.svc.id.goog[cnrm-system/cnrm-controller-manager]" \
    --role="roles/iam.workloadIdentityUser"

# CREATE NAMESPACE FOR CONNECTOR
kubectl create namespace $NAMESPACE

# INSTALL CONFIGCONNECTOR INTO CLUSTER
cat <<EOF | kubectl apply -f -
apiVersion: core.cnrm.cloud.google.com/v1beta1
kind: ConfigConnector
metadata:
  # the name is restricted to ensure that there is only one
  # ConfigConnector resource installed in your cluster
  name: configconnector.core.cnrm.cloud.google.com
spec:
 mode: cluster
 googleServiceAccount: ${SERVICE_ACCOUNT_NAME}@${PROJECT}
EOF

# kubectl apply -f configconnector.yaml

# ANNOTATE NS
kubectl annotate namespace \
    $NAMESPACE cnrm.cloud.google.com/project-id=$PROJECT

kubectl wait -n cnrm-system \
      --for=condition=Ready pod --all