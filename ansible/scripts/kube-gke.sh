#!/bin/bash

# GRAB ACTION ARG
while getopts "a:" arg; do
  case $arg in
    a) ACTION=$OPTARG;;
  esac
done

# GRAB NAME ARG
while getopts "n:" arg; do
  case $arg in
    n) NAME=$OPTARG;;
  esac
done

# GRAB TYPE ARG
while getopts "t:" arg; do
  case $arg in
    t) TYPE=$OPTARG;;
  esac
done

source kubeflow-gke/deploy.sh