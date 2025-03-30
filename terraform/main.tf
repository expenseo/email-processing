terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.8"
    }
  }
}

provider "google" {
  project = "expenseo-454900"
  region  = "us-central1"
  zone    = "us-central1-c"
}
