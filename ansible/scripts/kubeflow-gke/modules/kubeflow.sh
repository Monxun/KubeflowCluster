#!/bin/bash

# KUBEFLOW GKE INSTALL SCRIPT
# SCRIPT TO BE RAN AFTER: mgmt-cluster.sh

# ////////////////////////////////////////////////////////////////////
# ENV VARIABLES
# ///////////////////////////////////////////////////////////////////
export PROJECT=kubeflow-gke
export REGION=us-west1
export ZONE=us-west1-c
export NAME=kubeflow-gke
export NODE_POOL=kubeflow-np
export SERVICE_ACCOUNT_NAME=kubeflow-sa
export NAMESPACE=sidecar

export ACCOUNT_EMAIL=$MY_EMAIL

export CLIENT_ID=id
export CLIENT_SECRET=secrets

export MGMT_PROJECT=$PROJECT
export MGMT_NAME=flow-mgmt

# ////////////////////////////////////////////////////////////////////
# CLUSTER CONFIG
# ///////////////////////////////////////////////////////////////////
gcloud config set project $PROJECT
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

gcloud components update

# ENABLE WORKLOAD IDENTITY FOR NODE POOL
gcloud container node-pools update $NODE_POOL
    --workload-metadata=GKE_METADATA \
    --cluster $NAME

gcloud container clusters update $NAME
    --update-addons ConfigConnector=ENABLED

gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME

gcloud projects add-iam-policy-binding $PROJECT
    --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
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


# ////////////////////////////////////////////////////////////////////
# KUBEFLOW INSTALL
# ///////////////////////////////////////////////////////////////////
git clone https://github.com/kubeflow/gcp-blueprints.git 
cd gcp-blueprints
git checkout tags/v1.5.0 -b v1.5.0

# Visit Kubeflow cluster related manifests
cd kubeflow

bash ./pull-upstream.sh

gcloud auth login
gcloud config set project $PROJECT

make apply


# ////////////////////////////////////////////////////////////////////
# HEALTHCHECK
# ///////////////////////////////////////////////////////////////////
gcloud container clusters get-credentials "${NAME}" --zone "${ZONE}" --project "${PROJECT}"
kubectl -n kubeflow get all


# ////////////////////////////////////////////////////////////////////
# DASHBOARD
# ///////////////////////////////////////////////////////////////////
gcloud projects add-iam-policy-binding "${PROJECT}" --member=user:$ACCOUNT_EMAIL --role=roles/iap.httpsResourceAccessor
curl https://${NAME}.endpoints.${PROJECT}.cloud.goog/
kubectl -n istio-system get ingress

# The following command sets an environment variable named HOST to the URI:
export HOST=$(kubectl -n istio-system get ingress envoy-ingress -o=jsonpath={.spec.rules[0].host})

