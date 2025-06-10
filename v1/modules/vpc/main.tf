resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "bastion_subnet" {
  name          = "${var.vpc_name}-bastion-subnet"
  ip_cidr_range = var.bastion_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "web_subnet" {
  name          = "${var.vpc_name}-web-subnet"
  ip_cidr_range = var.web_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "app_subnet" {
  name          = "${var.vpc_name}-app-subnet"
  ip_cidr_range = var.app_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "db_subnet" {
  name          = "${var.vpc_name}-db-subnet"
  ip_cidr_range = var.db_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_router" "nat_router" {
  name    = "${var.vpc_name}-nat-router"
  network = google_compute_network.vpc_network.name
  region  = var.region
}

resource "google_compute_router_nat" "nat_config" {
  name                               = "${var.vpc_name}-nat-config"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_firewall" "allow_internal" {
  name    = "${var.vpc_name}-allow-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = [var.internal_cidr]
}