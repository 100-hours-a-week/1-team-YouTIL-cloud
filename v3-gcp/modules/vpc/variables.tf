variable "vpc_name" {
  description = "VPC network name"
  type        = string
  default     = "youtil-vpc-prod"
}

variable "region" {
  description = "GCP 리전"
  type        = string
  default     = "asia-northeast2"
}

variable "bastion_subnet_cidr" {
  description = "CIDR range for bastion subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "node_subnet_cidr" {
  description = "CIDR range for node subnet"
  type        = string
  default     = "10.0.0.0/24"
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