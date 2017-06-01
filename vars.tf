variable "DO_TOKEN" {}
variable "DO_FINGERPRINT" {}

variable "server_count" {
  description = "The number of server droplets"
  default     = 2
}

variable "region" {
  description = "The slug of the DO region, e.g. nyc3"
  default     = "nyc3"
}

variable "server_port" {
  description = "The server's listening port"
  default     = 80
}
