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

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable "database_url" {
  description = "URL database mongodb"
}
