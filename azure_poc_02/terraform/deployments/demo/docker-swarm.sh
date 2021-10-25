#! /bin/bash

vm_number=%vm_number%
storage_account_name=%storage_account_name%
primary_access_key=%primary_access_key%
share_url=%share_url%

# renames the host to have a suffix of moduscreate
export original=$(cat /etc/hostname)
sudo hostname $original-master-moduscreate
echo $original-master-moduscreate | sudo tee /etc/hostname

# Mount share
sudo apt-get update
sudo apt-get install -y cifs-utils
sudo mkdir -p /mnt/$storage_account_name/azure_share

mount -v -t cifs "${share_url}" \
"/mnt/${storage_account_name}/azure_share" \
-o \
vers="3.0",\
username="${storage_account_name}",\
password="${primary_access_key}",\
dir_mode="0777",\
file_mode="0777",\
serverino

# ------------------
# Install docker 
# ------------------
# Set up the repository - https://docs.docker.com/engine/install/
sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo usermod ubuntu -aG docker

# Docker Swarm Main Manager Node + Worker
if [[ ${vm_number} == 0 ]]; then

  echo "Docker Swarm Main Manager Node + Worker" >> /home/ubuntu/server.txt

  sudo rm -f "/mnt/${storage_account_name}/azure_share/swarm-manager.key"
  sudo rm -f "/mnt/${storage_account_name}/azure_share/swarm-worker.key"

  sudo docker swarm init --listen-addr=eth0 --advertise-addr=eth0
  sudo docker swarm join-token manager -q > "/home/ubuntu/swarm-manager.key"
  sudo docker swarm join-token worker -q > "/home/ubuntu/swarm-worker.key"

  sudo cp "/home/ubuntu/swarm-manager.key" "/mnt/${storage_account_name}/azure_share/swarm-manager.key"
  sudo cp "/home/ubuntu/swarm-worker.key" "/mnt/${storage_account_name}/azure_share/swarm-worker.key"
fi

# Docker Swarm Manager Node replica + Worker
if [[ ${vm_number} -ge 1 && ${vm_number} -le 2 ]]; then

  echo "Docker Swarm Manager Node replica + Worker" >> /home/ubuntu/server.txt

  RET=1
  until [ ${RET} -eq 0 ]; do
      manager_token=$(</mnt/${storage_account_name}/azure_share/swarm-manager.key) && \
      sudo docker swarm join --listen-addr=eth0 --advertise-addr=eth0 --token ${manager_token} 10.0.0.10:2377
      RET=$?

      if [[ ${RET} == 0 ]]; then
        manager_token=$(</mnt/${storage_account_name}/azure_share/swarm-manager.key) && \
        sudo docker swarm join --listen-addr=eth0 --advertise-addr=eth0 --token ${manager_token} 10.0.0.11:2377
        RET=$?
      fi

      if [[ ${RET} == 0 ]]; then
        manager_token=$(</mnt/${storage_account_name}/azure_share/swarm-manager.key) && \
        sudo docker swarm join --listen-addr=eth0 --advertise-addr=eth0 --token ${manager_token} 10.0.0.12:2377
        RET=$?
      fi

      sleep 10
  done
fi

# Docker Swarm worker
if [[ ${vm_number} -ge 3 ]]; then

  echo "Docker Swarm worker" >> /home/ubuntu/server.txt

  RET=1
  until [ ${RET} -eq 0 ]; do
      worker_token=$(</mnt/${storage_account_name}/azure_share/swarm-worker.key) && \
      sudo docker swarm join --listen-addr=eth0 --advertise-addr=eth0 --token ${worker_token} 10.0.0.10:2377
      RET=$?

      if [[ ${RET} == 0 ]]; then
        worker_token=$(</mnt/${storage_account_name}/azure_share/swarm-worker.key) && \
        sudo docker swarm join --listen-addr=eth0 --advertise-addr=eth0 --token ${worker_token} 10.0.0.11:2377
        RET=$?
      fi

      if [[ ${RET} == 0 ]]; then
        worker_token=$(</mnt/${storage_account_name}/azure_share/swarm-worker.key) && \
        sudo docker swarm join --listen-addr=eth0 --advertise-addr=eth0 --token ${worker_token} 10.0.0.12:2377
        RET=$?
      fi

      sleep 10
  done
fi