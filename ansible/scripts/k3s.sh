#!/bin/bash

if ! command -v k3s &> /dev/null
then
    echo "k3s could not be found"
    curl -sfL https://get.k3s.io | sh -
    echo "k3s successfuly installed"
    exit
fi

echo "k3s -- creating cluster"
sudo k3s server &
echo "k3s -- cluster created successfuly"
echo "k3s -- getting node"
sudo k3s kubectl get node