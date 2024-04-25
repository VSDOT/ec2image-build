!/bin/bash

# Update package lists
apt-get update

# Install Nginx
apt-get install -y nginx

# Start Nginx
service nginx start
