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
  default     = ["0.0.0.0/0"]  # 꼭 실제 접속하는 IP 범위로 제한 권장
}