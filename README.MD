# Why
Samba designed to run non-interactively e.g. not from docker run, with config bind mounted, this is for my specific use case and is probably useless for you. No NETBIOS, No Avahi, No Masters.

# Example Usage
## Docker

	docker create \
  	-v $PWD/smb.conf:/etc/samba/smb.conf \
  	-v /mnt/storage/tv:/share \
  	-p 445:445 \
  	--name samba \
  	--restart=always \
  	znedw/samba

## Docker Compose
	version: '2'
  	services:
    
    samba:
        image: znedw/samba:latest
        container_name: samba
        restart: always
        environment:
            - PUID=1000
            - PGID=1000
            - TZ=Australia/Brisbane
        ports:
            - '445:445'
        volumes:
            - '/docker/samba/smb.conf:/etc/samba/smb.conf'
            - '/mnt/storage:/share'

## Adding Users

	docker exec -it samba adduser -s /sbin/nologin -h /home/samba -H -D <username>
	docker exec -it samba smbpasswd -a <username>

## Example smb.conf

	[global]
      workgroup = WORKGROUP
      server string = %h server (Samba, Alpine)
      security = user
      map to guest = Bad User
      encrypt passwords = yes
      load printers = no
      printing = bsd
      printcap name = /dev/null
      disable spoolss = yes
      disable netbios = yes
      server role = standalone
      server services = -dns, -nbt
      smb ports = 445
      ;name resolve order = hosts
      ;log level = 3

	[storage]
      path = /share
      comment = Shared Folder
      browseable = yes
      writable = yes
      write list = <username>
      valid users = <username>

## Credits
Borrowed from [Stanback/alpine-samba](https://github.com/Stanback/alpine-samba) and [dperson/samba](https://github.com/dperson/samba)
