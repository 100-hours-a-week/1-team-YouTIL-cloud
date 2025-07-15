variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "asia-northeast2"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "asia-northeast2-b"
}

variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "youtil-vpc"
}

variable "public_subnet_cidr" {
  description = "퍼블릭 서브넷 CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "프라이빗 서브넷 CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "bastion_subnet_cidr" {
  description = "CIDR range for bastion subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "node_subnet_cidr" {
  description = "CIDR range for node subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR range for db subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "internal_cidr" {
  description = "CIDR range for internal communication"
  type        = string
  default     = "10.0.0.0/16"
}

variable "pods_cidr" {
  description = "CIDR range for pods"
  type        = string
  default     = "192.168.0.0/17"
}

variable "ssh_source_ranges" {
  description = "Source IP ranges allowed to SSH to bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}