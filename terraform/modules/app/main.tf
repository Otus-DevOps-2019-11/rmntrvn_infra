resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = var.zone_instance
  tags         = ["reddit-app"]
  boot_disk {
    initialize_params { image = var.app_disk_image }
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }
  metadata = {
    ssh-keys = "rmntrvn:${file(var.rmntrvn_public_key_path)}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface[0].access_config[0].nat_ip
    user        = "rmntrvn"
    agent       = false
    private_key = file(var.rmntrvn_private_key_path)
  }
  provisioner "file" {
    source      = "../modules/app/files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "../modules/app/files/deploy.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "echo export DATABASE_URL=\"${var.database_url}\" >> ~/.profile"
    ]
  }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}
