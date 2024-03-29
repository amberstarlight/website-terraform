terraform {
  required_version = "1.5.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.9"
    }
  }

  backend "s3" {
    bucket  = "website-terraform-state-881772576692"
    key     = "terraform.tfstate"
    encrypt = true
    region  = "eu-west-2"
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
