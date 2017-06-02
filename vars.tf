variable "DO_API_TOKEN" {}
variable "DO_FINGERPRINT" {}

variable "client_count" {
  description = "The number of server droplets"
  default     = 4
}

variable "server_count" {
  description = "The number of server droplets"
  default     = 4
}

variable "region" {
  description = "The slug of the DO region, e.g. nyc3"
  default     = "nyc3"
}

variable "server_port" {
  description = "The server's listening port"
  default     = 80
}
