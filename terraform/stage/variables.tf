variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}

variable zone_instance {
  description = "Zone for instance. Default is europe-west1-b"
  default     = "europe-west1-b"
}

variable rmntrvn_private_key_path {
  #
  description = "Path to the private key used for ssh access"
}

variable rmntrvn_public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable app_name {
  description = "Name of each application"
  default     = "reddit-base-app"
}

variable count_instances {
  type        = number
  description = "Count of instances"
  default     = 1
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}
