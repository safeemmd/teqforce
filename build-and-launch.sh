#!/bin/bash
ARTIFACT=`/usr/local/bin/packer build -machine-readable packer-file.json |awk -F, '$0 ~/artifact,0,id/ {print $6}'`
AMI_ID=`echo $ARTIFACT | cut -d ':' -f2`
echo 'variable "AMI_ID" { default = "'${AMI_ID}'" }' > amivar.tf
terraform init
terraform apply
