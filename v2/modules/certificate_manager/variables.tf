variable "name" {
  description = "리소스 이름 접두어"
  type        = string
}

variable "project" {
  description = "GCP 프로젝트 ID"
  type        = string
}

variable "domain_names" {
  description = "도메인 이름 리스트"
  type        = list(string)
}

variable "ssl_certificate_ids" {
  description = "도메인별 SSL 인증서 ID 맵"
  type        = map(string)
} 