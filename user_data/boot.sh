#!/bin/bash

sudo yum install -y httpd

sudo rm -rf /var/www/html/index.html

INSTANCE_ID=$(cat /var/lib/cloud/data/instance-id)

echo "Hello world" | sudo tee /var/www/html/index.html
echo "Instance ID: ${INSTANCE_ID}" | sudo tee -a /var/www/html/index.html

sudo service httpd start
