variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "asia-northeast3"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "asia-northeast3-a"
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

variable "region_public_subnet_name" {
  description = "퍼블릭 서브넷 이름"
  type        = string
  default     = "public-subnet"
}

variable "region_private_subnet_name" {
  description = "프라이빗 서브넷 이름"
  type        = string
  default     = "private-subnet"
}

variable "bastion_subnet_cidr" {
  description = "CIDR range for bastion subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "web_subnet_cidr" {
  description = "CIDR range for web subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "app_subnet_cidr" {
  description = "CIDR range for app subnet"
  type        = string
  default     = "10.0.2.0/24"
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

variable "ssh_source_ranges" {
  description = "Source IP ranges allowed to SSH to bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "domain_name" {
  description = "The domain name for the application"
  type        = string
  default     = "dev.youtil.co.kr."
}