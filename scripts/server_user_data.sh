#!/bin/bash
apt update && apt install -y python nmap
echo "<h1>Hello world from server"${count.index}"</h1>" > index.html
nohup busybox httpd -f -p "${var.server_port}" 0<&- &> /tmp/script.log &
