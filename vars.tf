variable "DO_API_TOKEN" {}
variable "DO_FINGERPRINT" {}

variable "DO_CLIENT_COUNT" {
  description = "The number of clients"
  default     = 10
}

variable "DO_SERVER_COUNT" {
  description = "The number of servers"
  default     = 10
}

variable "DO_MONITOR_COUNT" {
  description = "The number of monitoring servers"
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

variable "DO_CLIENT_USER_DATA" {
  description = "cloud-init user data for the client"
  default     = <<EOF
#!/bin/bash
apt update && apt install -y python python-pip docker.io nmap iperf3
EOF
}

variable "DO_SERVER_USER_DATA" {
  description = "cloud-init user data for the server"
  default     = <<EOF
#!/bin/bash
apt update && apt install -y python python-pip docker.io nmap iperf3 vsftpd
EOF
}

variable "DO_MONITOR_USER_DATA" {
  description = "cloud-init user data for the monitor server"
  default     = <<EOF
#!/bin/bash
apt update && apt install -y python python-pip docker.io
EOF
}
