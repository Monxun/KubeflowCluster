#!/usr/bin/env bash

terraform init

terraform destroy \
    -auto-approve=true \
    -lock=false