variable "vpc_name" {
  description = "VPC network name"
  type        = string
  default     = "my-vpc"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "bastion_subnet_cidr" {
  description = "CIDR range for bastion subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "master_subnet_cidr" {
  description = "CIDR range for web subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "worker_subnet_cidr" {
  description = "CIDR range for app subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "monitoring_subnet_cidr" {
  description = "CIDR range for app subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR range for db subnet"
  type        = string
  default     = "10.0.4.0/24"
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