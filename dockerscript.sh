#!/bin/bash
curl -fsSL https://test.docker.com -o test-docker.sh && \
sudo sh test-docker.sh  && \
sudo usermod -aG docker $USER && \
newgrp docker 
docker run --name hostname-docker -p 80:3000 --rm -d adongy/hostname-docker