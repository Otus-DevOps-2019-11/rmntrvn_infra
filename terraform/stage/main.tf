provider "google" {
  version = "~> 2.15"
  project = var.project
  region  = var.region
}

module "app" {
  source                  = "../modules/app"
  rmntrvn_public_key_path = var.rmntrvn_public_key_path
  zone_instance           = var.zone_instance
  app_disk_image          = var.app_disk_image
  database_url            = "${module.db.db_external_ip}"
}

module "db" {
  source                  = "../modules/db"
  rmntrvn_public_key_path = var.rmntrvn_public_key_path
  zone_instance           = var.zone_instance
  db_disk_image           = var.db_disk_image
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["0.0.0.0/0"]
}
