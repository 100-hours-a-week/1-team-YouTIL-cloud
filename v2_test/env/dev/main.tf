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
  credentials = file("../../../credentials/youtil4-terraform-sa.json")
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_name          = var.vpc_name
  region            = var.region
  bastion_subnet_cidr = var.bastion_subnet_cidr
  master_subnet_cidr   = var.master_subnet_cidr
  worker_subnet_cidr   = var.worker_subnet_cidr
  monitoring_subnet_cidr = var.monitoring_subnet_cidr
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

# Internal IP Reservations
resource "google_compute_address" "master_internal" {
  name         = "master-internal-ip"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = module.vpc.master_subnet_self_link
  region       = var.region
}

resource "google_compute_address" "worker_internal" {
  name         = "worker-internal-ip"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = module.vpc.worker_subnet_self_link
  region       = var.region
}

resource "google_compute_address" "monitoring_internal" {
  name         = "monitoring-internal-ip"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = module.vpc.monitoring_subnet_self_link
  region       = var.region
}

resource "google_compute_address" "db_internal" {
  name         = "db-internal-ip"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = module.vpc.db_subnet_self_link
  region       = var.region
}

module "master" {
  source         = "../../modules/compute"
  instance_name  = "master-server"
  zone           = "asia-northeast2-b"
  project        = var.project_id
  network        = module.vpc.vpc_network_name
  subnetwork     = module.vpc.master_subnet_self_link
  machine_type   = "e2-medium"
  disk_size_gb   = 30
  disk_type      = "pd-ssd"
  tags           = ["master"]
  ssh_public_key = file("/Users/minty/.ssh/youtil-prod.pub")
  startup_script = file("../../scripts/install-docker.sh")
  internal_ip    = google_compute_address.master_internal.address
}

module "worker" {
  source         = "../../modules/compute"
  instance_name  = "worker-server"
  zone           = "asia-northeast2-b"
  project        = var.project_id
  network        = module.vpc.vpc_network_name
  subnetwork     = module.vpc.worker_subnet_self_link
  machine_type   = "e2-medium"
  disk_size_gb   = 30
  disk_type      = "pd-ssd"
  tags           = ["worker"]
  ssh_public_key = file("/Users/minty/.ssh/youtil-prod.pub")
  startup_script = file("../../scripts/install-docker.sh")
  internal_ip    = google_compute_address.worker_internal.address
}

module "monitoring" {
  source         = "../../modules/compute"
  instance_name  = "monitoring-server"
  zone           = "asia-northeast2-b"
  project        = var.project_id
  network        = module.vpc.vpc_network_name
  subnetwork     = module.vpc.monitoring_subnet_self_link
  machine_type   = "e2-medium"
  disk_size_gb   = 50
  disk_type      = "pd-ssd"
  tags           = ["monitoring"]
  ssh_public_key = file("/Users/minty/.ssh/youtil-prod.pub")
  startup_script = file("../../scripts/install-docker.sh")
  internal_ip    = google_compute_address.monitoring_internal.address
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

# Kubernetes, Bastion, OpenVPN 관련 방화벽 규칙

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

# Master 노드 API 서버(6443) 외부에서 접근 허용 (관리용)
resource "google_compute_firewall" "allow_k8s_master_api" {
  name    = "${var.vpc_name}-allow-k8s-master-api"
  network = module.vpc.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  # 필요에 따라 제한 (예: ["YOUR_IP/32"])
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["master"]
}

# 노드 간 통신 (Kubernetes 내부 통신)
resource "google_compute_firewall" "allow_k8s_internal" {
  name    = "${var.vpc_name}-allow-k8s-internal"
  network = module.vpc.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = [var.internal_cidr]
  target_tags   = ["master", "worker"]
}

# NodePort 서비스용 외부 포트 허용 (30000-32767)
resource "google_compute_firewall" "allow_k8s_nodeport" {
  name    = "${var.vpc_name}-allow-k8s-nodeport"
  network = module.vpc.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }
  allow {
    protocol = "udp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["worker"]
}

# Master/Worker SSH 접속 (관리용, Bastion에서만 허용)
resource "google_compute_firewall" "allow_k8s_ssh" {
  name    = "${var.vpc_name}-allow-k8s-ssh"
  network = module.vpc.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Bastion subnet에서만 SSH 허용
  source_ranges = [var.bastion_subnet_cidr]
  target_tags   = ["master", "worker"]
}

# # Frontend Backend Service
# module "frontend_backend" {
#   source = "../../modules/backend_service"
#   name   = "frontend"
#   project = var.project_id
#   region  = var.region
#   zone    = var.zone
#   network = module.vpc.vpc_network_name
#   subnetwork = module.vpc.worker_subnet_self_link

#   instances = [
#     {
#       name = module.worker.instance_name
#       private_ip = module.worker.internal_ip
#     }
#   ]

#   port = 32030
#   health_check_path = "/login"
# }

# # Backend Service
# module "backend_service" {
#   source = "../../modules/backend_service"
#   name   = "backend"
#   project = var.project_id
#   region  = var.region
#   zone    = var.zone
#   network = module.vpc.vpc_network_name
#   subnetwork = module.vpc.worker_subnet_self_link

#   instances = [
#     {
#       name = module.worker.instance_name
#       private_ip = module.worker.internal_ip
#     }
#   ]

#   port = 32080
#   health_check_path = "/health"
# }

# # Certificate Manager
# module "certificate_manager" {
#   source = "../../modules/certificate_manager"
#   name   = "web"
#   project = var.project_id
#   domain_names = [
#     "youtil.co.kr",
#     "api.youtil.co.kr",
#   ]
#   ssl_certificate_ids = {
#     "youtil.co.kr" = "projects/enhanced-pen-462505-m4/locations/global/certificates/youtil-crt"
#     "api.youtil.co.kr" = "projects/enhanced-pen-462505-m4/locations/global/certificates/youtil-crt"
#   }
# }

# # External Load Balancer
# module "external_lb" {
#   source = "../../modules/external_lb"
#   name   = "web"
#   default_backend_service_id = module.frontend_backend.backend_service_id
#   certificate_map_id = module.certificate_manager.certificate_map_id

#   host_rules = [
#     {
#       host = "youtil.co.kr"
#       path_matcher = "main"
#       default_service_id = module.frontend_backend.backend_service_id
#       path_rules = []
#     },
#     {
#       host = "api.youtil.co.kr"
#       path_matcher = "api"
#       default_service_id = module.backend_service.backend_service_id
#       path_rules = []
#     }
#   ]
# }