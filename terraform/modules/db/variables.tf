variable rmntrvn_public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable rmntrvn_private_key_path {
  description = "Path to the private key used to connect to instance"
  default     = "~/.ssh/id_rsa"
}

variable zone_instance {
  description = "Zone for instance. Default is europe-west1-b"
  default     = "europe-west1-b"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}
