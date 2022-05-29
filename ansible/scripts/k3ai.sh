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


# CHECK THAT K3AI IS INSTALLED
if ! command -v k3ai &> /dev/null
then
    echo "k3ai could not be found"
    curl -sfL https://get.k3ai.in | bash -s -- --cpu --plugin_kfpipelines
    # curl -sfL https://get.k3ai.in | bash -s -- --gpu --plugin_kfpipelines
    echo "k3ai succesfully installed"
    exit
fi

# DEPLOY
if [[ $ACTION == "deploy" ]]
then
    k3ai up
    echo "k3ai -- creating cluster"
    k3ai cluster deploy --type $TYPE -n $NAME
    k3ai plugin deploy -n mlflow -t $NAME
    echo "k3ai -- cluster created successfuly"
    echo "k3ai -- list clusters"
    k3ai cluster list --all
    exit
fi

# DESTROY
if [[ $ACTION == "destroy" ]]
then
    k3ai up
    echo "k3ai -- destroying cluster"
    k3ai cluster remove -n $NAME
    echo "k3ai -- cluster destroyed successfuly"
    exit
fi

