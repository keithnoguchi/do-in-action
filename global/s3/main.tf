terraform {
  backend "s3" {
    bucket  = "github-keinohguchi-doform-state"
    key     = "global/s3/terraform.tfstate"
    region  = "us-west-1"
    encrypt = true
  }
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "github-keinohguchi-doform-state"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
