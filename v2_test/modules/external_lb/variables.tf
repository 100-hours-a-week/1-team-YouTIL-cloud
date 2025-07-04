variable "name" {
  description = "리소스 이름 접두어"
  type        = string
}

variable "default_backend_service_id" {
  description = "기본 백엔드 서비스 ID"
  type        = string
}

variable "host_rules" {
  description = "호스트 기반 라우팅 규칙"
  type = list(object({
    host = string
    path_matcher = string
    default_service_id = string
    path_rules = list(object({
      paths = list(string)
      service_id = string
    }))
  }))
}

variable "certificate_map_id" {
  description = "Certificate Map ID"
  type        = string
} 