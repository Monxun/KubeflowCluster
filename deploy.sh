#!/bin/sh

cd ansible
ansible-playbook DEPLOY_kubeflow_cluster_playbook.yaml --extra-vars \
    "destroy=false cloud_provider='aws'"