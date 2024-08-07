terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.61.0"
    }
  }
}

resource "null_resource" "example" {
  triggers = {
    value = "A example resource that does nothing!"
  }
}
