#!/bin/bash
yum update
yum install -y docker
systemctl start docker
systemctl enable docker
docker run -d -p ${port}:5678 hashicorp/http-echo -text="hello world"
