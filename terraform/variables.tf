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

variable rmntrvn_public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}
