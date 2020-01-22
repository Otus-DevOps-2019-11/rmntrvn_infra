resource "google_compute_instance" "db" {
  name         = "reddit-db"
  machine_type = "g1-small"
  zone         = var.zone_instance
  tags         = ["reddit-db"]
  boot_disk {
    initialize_params {
      image = var.db_disk_image
    }
  }
  network_interface {
    network = "default"
    access_config {}
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

#  provisioner "remote-exec" {
#    inline = ["sudo sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf && sudo service mongod restart"]
#  }
}
