terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
  required_version = ">= 1.5"
}

provider "google" {
  credentials = file("../../../credentials/youtil6-terraform-sa.json")
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_name          = var.vpc_name
  region            = var.region
  bastion_subnet_cidr = var.bastion_subnet_cidr
  node_subnet_cidr   = var.node_subnet_cidr
  db_subnet_cidr    = var.db_subnet_cidr
  internal_cidr     = var.internal_cidr
  pods_cidr         = var.pods_cidr
}

# External IP Reservation for Bastion
resource "google_compute_address" "bastion_external" {
  name         = "bastion-external-ip"
  address_type = "EXTERNAL"
  region       = var.region
}

module "bastion" {
  source         = "../../modules/compute"
  instance_name  = "bastion-host"
  zone           = "asia-northeast2-b"
  project        = var.project_id
  network        = module.vpc.vpc_network_name
  subnetwork     = module.vpc.bastion_subnet_self_link
  machine_type   = "e2-small"
  disk_size_gb   = 30
  disk_type      = "pd-ssd"
  tags           = ["bastion"]
  create_public_ip = true
  ssh_public_key = file("/Users/minty/.ssh/youtil-bastion.pub")
  external_ip    = google_compute_address.bastion_external.address
}

resource "google_compute_address" "db_internal" {
  name         = "db-internal-ip"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = module.vpc.db_subnet_self_link
  region       = var.region
}

module "db" {
  source         = "../../modules/compute"
  instance_name  = "db-server"
  zone           = "asia-northeast2-b"
  project        = var.project_id
  network        = module.vpc.vpc_network_name
  subnetwork     = module.vpc.db_subnet_self_link
  machine_type   = "e2-medium"
  disk_size_gb   = 50
  disk_type      = "pd-ssd"
  tags           = ["db"]
  ssh_public_key = file("/Users/minty/.ssh/youtil-prod.pub")
  startup_script = file("../../scripts/install-docker.sh")
  internal_ip    = google_compute_address.db_internal.address
}

# Bastion 호스트 SSH 접속 허용 (외부에서)
resource "google_compute_firewall" "allow_bastion_ssh" {
  name    = "${var.vpc_name}-allow-bastion-ssh"
  network = module.vpc.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.ssh_source_ranges
  target_tags   = ["bastion"]
}

# Bastion 호스트 OpenVPN(UDP 1194) 접속 허용 (외부에서)
resource "google_compute_firewall" "allow_bastion_openvpn" {
  name    = "${var.vpc_name}-allow-bastion-openvpn"
  network = module.vpc.vpc_network_name

  allow {
    protocol = "udp"
    ports    = ["1194"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]
}