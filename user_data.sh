#!/bin/bash
apt install -y python
echo "<h1>Hello world, templated!</h1>" > index.html
nohup busybox httpd -f -p "${server_port}" 0<&- &> /tmp/script.log &
