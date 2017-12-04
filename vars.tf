variable "DO_API_TOKEN" {}
variable "DO_FINGERPRINT" {}

variable "DO_CLIENT_USER_DATA" {
  description = "cloud-init user data for the client"
  default     = <<EOF
#!/bin/bash
apt update && apt install -y python nmap iperf3
EOF
}

variable "DO_SERVER_USER_DATA" {
  description = "cloud-init user data for the server"
  default     = <<EOF
#!/bin/bash
apt update && apt install -y python nmap iperf3 jq vsftpd
EOF
}

variable "client_count" {
  description = "The number of server droplets"
  default     = 1
}

variable "server_count" {
  description = "The number of server droplets"
  default     = 1
}

variable "DO_REGION" {
  description = "The slug of the DO region, e.g. nyc3"
  default     = "nyc3"
}

variable "server_port" {
  description = "The server's listening port"
  default     = 8080
}
