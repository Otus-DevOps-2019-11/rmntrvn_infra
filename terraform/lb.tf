resource "google_compute_instance_group" "all" {
  project   = var.project
  name      = "${var.app_name}-instance-group"
  zone      = var.zone_instance
  instances = google_compute_instance.app[*].self_link
  named_port {
    name = "tcp-9292"
    port = 9292
  }
}

module "gce-lb-http" {
  project     = var.project
  source      = "GoogleCloudPlatform/lb-http/google"
  name        = "${var.app_name}-lb"
  target_tags = [var.app_name]

  backends = {
    default = {
      protocol                        = "HTTP"
      port                            = 9292
      port_name                       = "tcp-9292"
      timeout_sec                     = 12
      connection_draining_timeout_sec = null
      description                     = null
      enable_cdn                      = false

      health_check = {
        check_interval_sec  = 5
        timeout_sec         = 5
        healthy_threshold   = 2
        unhealthy_threshold = 5
        request_path        = "/"
        port                = 9292
        host                = null
      }

      groups = [
        {
          group                        = "${google_compute_instance_group.all.self_link}"
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
      ]
    }
  }
}
