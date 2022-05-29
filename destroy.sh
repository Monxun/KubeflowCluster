#!/bin/sh

cd ansible
ansible-playbook DESTROY_kubeflow_cluster_playbook.yaml --extra-vars \
    "destroy=true cloud_provider='aws'"