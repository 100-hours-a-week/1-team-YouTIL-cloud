variable "instance_name" {
  type        = string
  description = "Name of the compute instance"
}

variable "machine_type" {
  type        = string
  description = "GCP machine type (e.g. e2-medium)"
  default     = "e2-medium"
}

variable "zone" {
  type        = string
  description = "GCP zone"
}

variable "project" {
  type        = string
  description = "GCP project ID"
}

variable "disk_image" {
  type        = string
  description = "Boot disk image"
  default     = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
}

variable "disk_size_gb" {
  type        = number
  description = "Boot disk size in GB"
  default     = 10
}

variable "disk_type" {
  type        = string
  description = "Boot disk type"
  default     = "pd-standard"
}

variable "network" {
  type        = string
  description = "VPC network name"
}

variable "subnetwork" {
  type        = string
  description = "Subnet name"
}

variable "assign_public_ip" {
  type        = bool
  description = "Assign public IP to instance"
  default     = false
}

variable "metadata" {
  type        = map(string)
  description = "Metadata key-value pairs"
  default     = {}
}

variable "tags" {
  type        = list(string)
  description = "Network tags"
  default     = []
}

variable "service_account_email" {
  type        = string
  description = "Service account email"
  default     = ""
}

variable "service_account_scopes" {
  type        = list(string)
  description = "Service account scopes"
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "startup_script" {
  type        = string
  description = "Startup script content"
  default     = ""
}

variable "create_public_ip" {
  description = "Whether to assign a public IP address"
  type        = bool
  default     = false
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for instance access"
  default     = ""
}

variable "internal_ip" {
  description = "The internal IP address to assign to the instance"
  type        = string
  default     = null
}

variable "external_ip" {
  description = "The external IP address to assign to the instance"
  type        = string
  default     = null
}