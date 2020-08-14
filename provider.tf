provider "aws" {
  region = var.AWS_REGION
}

terraform {
  backend "s3" {
   bucket =  "teqforce-tfstate"
    key    = "teqforce/terraform.tfstate"
    region = "us-east-1"
  }
}

