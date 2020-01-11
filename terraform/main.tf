terraform {
  # Версия terraform
  required_version = ">=0.12.0"
}

provider "google" {
  # Версия провайдера
  version = "2.15"
  # ID проекта
  project = var.project
  # регион = europe-west-1
  region = var.region
}

resource "google_compute_instance" "app" {
  count        = var.count_instances
  name         = "${var.app_name}${count.index}"
  machine_type = "g1-small"
  zone         = var.zone_instance
  tags         = [var.app_name]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      # image = reddit-base
      image = var.disk_image
    }
  }

  metadata = {
    # путь до публичного ключа ~/.ssh/id_rsa.pub
    ssh-keys = "rmntrvn:${file(var.rmntrvn_public_key_path)}\nrmntrvn1${file(var.rmntrvn_public_key_path)}:"
  }

  network_interface {
    network = "default"
    access_config {}
  }

  connection {
    type  = "ssh"
    host  = self.network_interface[0].access_config[0].nat_ip
    user  = "rmntrvn"
    agent = false
    # путь до приватного ключа
    private_key = file(var.rmntrvn_private_key_path)
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }

}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = [var.app_name]
}
