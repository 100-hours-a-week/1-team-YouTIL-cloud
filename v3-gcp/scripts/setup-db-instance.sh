curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo usermod -aG docker ubuntu
newgrp docker

sudo systemctl enable docker
sudo systemctl start docker

mkdir -p mysql/backup
mkdir -p redis/data

gsutil cp gs://youtil-backup-bucket/docker-compose.yml /home/ubuntu/
gsutil cp gs://youtil-backup-bucket/redis.conf /home/ubuntu/redis/

docker compose up -d
sleep 5