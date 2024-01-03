terraform {
  cloud {
    organization = "024_2023-summer-cloud-t"

    workspaces {
      name = "Actual-Project"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}