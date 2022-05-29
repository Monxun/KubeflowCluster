#!/usr/bin/env bash

terraform init

# DELETE EIN'S FIRST 
terraform destroy \
    -target=aws_eip.nat_a \
    -lock=false 

terraform destroy \
    -target=aws_eip.nat_b \
    -lock=false 

terraform destroy \
    -auto-approve=true \
    -lock=false 