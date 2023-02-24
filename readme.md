## Prepare proxmox container:

Create a container in proxmox with internal ip 192.168.0.21/24 using ubuntu server.

### Giving ssh access to the container

Enter in proxmox terminal access to the container and make a new user:

```bash
adduser <USERNAME>
usermod -aG wheel <USERNAME>
```

now you can access the container via ssh.

### Installing Docker

You can install docker in your container using this guide https://docs.docker.com/engine/install/ubuntu/

check docker installation

```bash
sudo docker run hello-world
sudo docker compose -h
```

### Clone and run the base environment

Clone this repository and change the existing .env file inside the /data directory

First run the base stack with the potainer environment and the reverse proxy containers.

#### Runing Base stack

```bash
cd base
sudo docker compose up -dß
```

#### Runing Data stack

```bash
cd data
sudo docker compose -f 'nextcloud.yml' up -d
sudo docker compose -f 'nextcloud.yml' exec nextcloud chown -R www-data:www-data /opt/nextcloud/data
sudo docker compose -f 'apps.yml' up -d
```
