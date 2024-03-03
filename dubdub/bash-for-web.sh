#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo "<h1>Hello World from $(hostname -f)</h1>" > /usr/share/nginx/html/index.html