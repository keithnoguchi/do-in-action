variable "DO_TOKEN" {}
variable "DO_FINGERPRINT" {}
variable "DO_PUBLIC_KEY" {}
variable "DO_PRIVATE_KEY" {}

variable "server_count" {
  description = "The number of server droplets"
  default     = 2
}
