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
  credentials = file("../../../credentials/youtil3-terraform-sa.json")
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_name          = var.vpc_name
  region            = var.region
  bastion_subnet_cidr = var.bastion_subnet_cidr
  web_subnet_cidr   = var.web_subnet_cidr
  app_subnet_cidr   = var.app_subnet_cidr
  db_subnet_cidr    = var.db_subnet_cidr
  internal_cidr     = var.internal_cidr
  ssh_source_ranges = var.ssh_source_ranges
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
  zone           = "asia-northeast3-a"
  project        = var.project_id
  network        = module.vpc.vpc_network_name
  subnetwork     = module.vpc.bastion_subnet_self_link
  machine_type   = "e2-micro"
  disk_size_gb   = 30
  disk_type      = "pd-ssd"
  tags           = ["bastion"]
  create_public_ip = true
  ssh_public_key = file("/Users/minty/.ssh/youtil-bastion.pub")
  external_ip    = google_compute_address.bastion_external.address
}

# Internal IP Reservations
resource "google_compute_address" "web_internal" {
  name         = "web-internal-ip"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = module.vpc.web_subnet_self_link
  region       = var.region
}

resource "google_compute_address" "app_internal" {
  name         = "app-internal-ip"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = module.vpc.app_subnet_self_link
  region       = var.region
}

resource "google_compute_address" "db_internal" {
  name         = "db-internal-ip"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = module.vpc.db_subnet_self_link
  region       = var.region
}

module "web" {
  source         = "../../modules/compute"
  instance_name  = "web-server"
  zone           = "asia-northeast3-a"
  project        = var.project_id
  network        = module.vpc.vpc_network_name
  subnetwork     = module.vpc.web_subnet_self_link
  machine_type   = "e2-medium"
  disk_size_gb   = 30
  disk_type      = "pd-ssd"
  tags           = ["web"]
  ssh_public_key = file("/Users/minty/.ssh/youtil-prod.pub")
  startup_script = file("../../scripts/install-docker.sh")
  internal_ip    = google_compute_address.web_internal.address
}

module "app" {
  source         = "../../modules/compute"
  instance_name  = "app-server"
  zone           = "asia-northeast3-a"
  project        = var.project_id
  network        = module.vpc.vpc_network_name
  subnetwork     = module.vpc.app_subnet_self_link
  machine_type   = "e2-medium"
  disk_size_gb   = 30
  disk_type      = "pd-ssd"
  tags           = ["app"]
  ssh_public_key = file("/Users/minty/.ssh/youtil-prod.pub")
  startup_script = file("../../scripts/install-docker.sh")
  internal_ip    = google_compute_address.app_internal.address
}

module "db" {
  source         = "../../modules/compute"
  instance_name  = "db-server"
  zone           = "asia-northeast3-a"
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

# Firewall
resource "google_compute_firewall" "allow_bastion_ssh" {
  name    = "${var.vpc_name}-allow-bastion"
  network = module.vpc.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]
}

resource "google_compute_firewall" "allow_bastion_openvpn" {
  name    = "${var.vpc_name}-allow-openvpn"
  network = module.vpc.vpc_network_name

  allow {
    protocol = "udp"
    ports    = ["1194"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]
}

resource "google_compute_firewall" "allow_web_http" {
  name    = "${var.vpc_name}-allow-http"
  network = module.vpc.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

resource "google_compute_firewall" "allow_web_https" {
  name    = "${var.vpc_name}-allow-https"
  network = module.vpc.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

resource "google_compute_firewall" "allow_web_nextjs" {
  name    = "${var.vpc_name}-allow-nextjs"
  network = module.vpc.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

resource "google_compute_firewall" "allow_app_springboot" {
  name    = "${var.vpc_name}-allow-springboot"
  network = module.vpc.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["app"]
}

resource "google_compute_firewall" "allow_db_mysql" {
  name    = "${var.vpc_name}-allow-db"
  network = module.vpc.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["3306", "6379"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["db"]
}

# Frontend Backend Service
module "frontend_backend" {
  source = "../../modules/backend_service"
  name   = "frontend"
  project = var.project_id
  region  = var.region
  zone    = var.zone
  network = module.vpc.vpc_network_name
  subnetwork = module.vpc.web_subnet_self_link

  instances = [
    {
      self_link = module.web.instance_self_link
      private_ip = module.web.internal_ip
    }
  ]

  port = 3000
  health_check_path = "/login"
}

# Backend Service
module "backend_service" {
  source = "../../modules/backend_service"
  name   = "backend"
  project = var.project_id
  region  = var.region
  zone    = var.zone
  network = module.vpc.vpc_network_name
  subnetwork = module.vpc.app_subnet_self_link

  instances = [
    {
      self_link = module.app.instance_self_link
      private_ip = module.app.internal_ip
    }
  ]

  port = 8080
  health_check_path = "/health"
}

# Certificate Manager
module "certificate_manager" {
  source = "../../modules/certificate_manager"
  name   = "web"
  project = var.project_id
  domain_names = [
    "youtil.co.kr",
    "api.youtil.co.kr"
  ]
  ssl_certificate_ids = {
    "youtil.co.kr" = "projects/youtil-459908/locations/global/certificates/youtil-crt"
    "api.youtil.co.kr" = "projects/youtil-459908/locations/global/certificates/youtil-crt"
  }
}

# External Load Balancer
module "external_lb" {
  source = "../../modules/external_lb"
  name   = "web"
  default_backend_service_id = module.frontend_backend.backend_service_id
  certificate_map_id = module.certificate_manager.certificate_map_id

  host_rules = [
    {
      host = "youtil.co.kr"
      path_matcher = "main"
      default_service_id = module.frontend_backend.backend_service_id
      path_rules = []
    },
    {
      host = "api.youtil.co.kr"
      path_matcher = "api"
      default_service_id = module.backend_service.backend_service_id
      path_rules = []
    }
  ]
}