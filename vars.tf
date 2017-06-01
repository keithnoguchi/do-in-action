variable "DO_TOKEN" {}
variable "DO_FINGERPRINT" {}
variable "DO_PRIVATE_KEY" {}

variable "server_count" {
  description = "The number of server droplets"
  default     = 2
}

variable "region" {
  description = "The slug of the DO region, e.g. nyc3"
  default     = "nyc3"
}
