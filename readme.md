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

Clone this repository and change the existing .env file inside the /data directory, change it with the username and password that you want to be the root user of all applications.

### Create a ssh certificate with certbot

install letsencrypt

```bash
sudo apt-get install letsencrypt
```

generate the certificate

```bash
sudo certbot certonly --manual --preferred-challenges=dns --email <your@email.com> --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d <your_damain.com> -d *.<your_damain.com>
```

in my case:

```bash
sudo certbot certonly --manual --preferred-challenges=dns --email 'leualemax@gmail.com' --server 'https://acme-v02.api.letsencrypt.org/directory' --agree-tos -d 'alemax.site' -d '*.alemax.site'
```

you will be prompted with a key to be setted on your dns server in a txt record, pls, test the propagation before hit continue. (testing using this site https://mxtoolbox.com/txtlookup.aspx)

this processe will generate 2 files within the directory /etc/letsencrypt/live/<your-domain>/ thoose files are used to sign the https call to your sites.

| remember to change the domain names in the proxy configuration files and in the docker-compose files, i've did it with my domain.

First run the base stack with the potainer environment and the reverse proxy containers.

#### Runing Base stack

```bash
cd base
sudo docker compose up -d
```

After that you will be able to acess the web interface of potainer with the address, give a try:

```
https://docker.<your.domain>/
```

in my case:

```
https://docker.alemax.site/
```

the user admin will be the same you set on the .env file.

### Runing git stack

just run the command inside the git repository

initial user will be 'root', with the password generate in instalation:

sudo docker compose up -d

```bash
sudo docker exec -it gitlab-ce grep 'Password:' /etc/gitlab/initial_root_password
```

#### Runing Data stack

```bash
cd data
sudo docker compose -f 'nextcloud.yml' up -d
sudo docker compose -f 'nextcloud.yml' exec nextcloud chown -R www-data:www-data /opt/nextcloud/data
```

Open now the web interface (https://cloud.alemax.site/) of nextcloud and execute their installation process, when you finished, create a folder in root callend photoprism.

After that you can run the apps stack:

```bash
sudo docker compose -f 'apps.yml' up -d
sudo docker compose -f 'apps.yml' exec qbittorrent chown -R 911:911 /incomplete

```

scan new files

```bash
sudo docker compose -f 'nextcloud.yml' exec --user www-data nextcloud php occ files:scan --all
```

add a cron tabb to file sync`

```txt
1 * * * * sudo docker compose -f '/home/alemax/home-lab-bahamut/data/nextcloud.yml' exec --user www-data nextcloud php occ files:scan --all
1 * * * * chmod -R 777 /home/alemax/home-lab-bahamut/data/nextcloud/alemax
```
