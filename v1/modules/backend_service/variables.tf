variable "name" {
  description = "리소스 이름 접두어"
  type        = string
}

variable "project" {
  description = "GCP 프로젝트 ID"
  type        = string
}

variable "region" {
  description = "GCP 리전"
  type        = string
}

variable "zone" {
  description = "GCP 존"
  type        = string
}

variable "network" {
  description = "VPC 네트워크 이름"
  type        = string
}

variable "subnetwork" {
  description = "서브네트워크 이름"
  type        = string
}

variable "instances" {
  description = "백엔드 VM 인스턴스 정보 리스트"
  type = list(object({
    self_link = string
    private_ip = string
  }))
}

variable "port" {
  description = "서비스 포트"
  type        = number
}

variable "health_check_path" {
  description = "헬스 체크 경로"
  type        = string
  default     = "/"
}

variable "timeout_sec" {
  description = "백엔드 서비스 타임아웃 (초)"
  type        = number
  default     = 60
}

variable "balancing_mode" {
  description = "로드밸런싱 모드"
  type        = string
  default     = "RATE"
}

variable "max_rate_per_endpoint" {
  description = "엔드포인트당 최대 요청 수"
  type        = number
  default     = 100
} 