resource "google_compute_instance" "default" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project

  tags = var.tags

  boot_disk {
    initialize_params {
      image  = var.disk_image
      size   = var.disk_size_gb
      type   = var.disk_type
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    dynamic "access_config" {
      for_each = var.create_public_ip ? [1] : []
      content {
        nat_ip = var.external_ip
      }
    }
  }

  metadata = merge(
    var.metadata,
    {
      enable-osconfig = "TRUE"
    },
    var.ssh_public_key != "" ? {
      ssh-keys = "ubuntu:${var.ssh_public_key}"
    } : {}
  )

  metadata_startup_script = var.startup_script

  service_account {
    scopes = ["cloud-platform"]
  }
}
