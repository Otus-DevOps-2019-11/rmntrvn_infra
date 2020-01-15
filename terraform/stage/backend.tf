terraform {
  backend "gcs" {
    bucket = "storage-bucket-rmntrvn1337"
    prefix = "terraform-state-stage"
  }
}
