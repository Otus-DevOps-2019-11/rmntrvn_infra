terraform {
  # версия terraform
  required_version = ">=0.12.0"
}

provider "google" {
  version = "~> 2.15"
  project = var.project
  region  = var.region
}

module "storage-bucket" {
  source        = "SweetOps/storage-bucket/google"
  version       = "0.3.0"
  name          = "storage-bucket-rmntrvn1337"
  location      = "europe-west1"
  force_destroy = true
}

output storage-bucket_url {
  value = module.storage-bucket.url
}
