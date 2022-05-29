#!/bin/bash

if ! command -v kind &> /dev/null
then
    echo "kind could not be found"
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.8.1/kind-linux-amd64 && \
    chmod +x ./kind && \
    mv ./kind /usr/bin/kind
    echo "kind succesfully installed"
    exit
fi

echo "kind -- creating cluster"
kind create cluster --name kubeflow
echo "kind -- cluster created successfuly"
echo "kind -- getting cluster"