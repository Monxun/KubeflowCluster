#!/bin/sh

cd ansible
ansible-playbook kubeflow_cluster_playbook.yaml --extra-vars \
    "destroy=true" "cloud_provider='aws'"