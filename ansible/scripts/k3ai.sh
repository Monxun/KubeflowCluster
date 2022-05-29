#!/bin/bash

if ! command -v k3ai &> /dev/null
then
    echo "k3ai could not be found"
    curl -sfL https://get.k3ai.in | bash -s -- --cpu --plugin_kfpipelines
    # curl -sfL https://get.k3ai.in | bash -s -- --gpu --plugin_kfpipelines
    echo "k3ai succesfully installed"
    exit
fi

k3ai up
echo "k3ai -- creating cluster"
k3ai cluster deploy --type k3s -n kubecluster
k3ai plugin deploy -n mlflow -t kubecluster
echo "k3ai -- cluster created successfuly"
echo "k3ai -- list clusters"
k3ai cluster list --all