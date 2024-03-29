#!/bin/bash
PORTAINER=`docker ps -a | grep portainer | awk '{print $1}'`
docker container rm -f $PORTAINER

docker volume rm -f portainer_data
rm -rf /usr/bin/docker-compose
rm -rf /usr/bin/docker
rm -rf /usr/local/bin/docker-compose

systemctl disable --now docker
yum remove -y docker docker-ce docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine docker*

rm -rf /etc/yum.repos.d/docker-ce.repo

yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --enable docker-ce-nightly
yum install -y docker-ce docker-ce-cli containerd.io
systemctl enable --now docker
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
