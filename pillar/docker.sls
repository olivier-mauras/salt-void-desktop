docker:
  networks:
    trust:
      driver: macvlan
      subnet: 10.50.50.0/24
      gateway: 10.50.50.1
      range: 10.50.50.1/25
      interface: br_trust
    untrust:
      driver: macvlan
      subnet: 172.17.0.0/24
      gateway: 172.17.0.1
      range: 172.17.0.1/26
      interface: br_untrust
    tor:
      driver: macvlan
      subnet: 10.100.0.0/24
      gateway: 10.100.0.1
      range: 10.100.0.1/26
      interface: br_tor
  storage:
    docker:
      size: 10G
      mnt: /var/lib/docker
    docker_images:
      siize: 2G
      mnt: /srv/docker
  images:
    alpinelinux:
      url: https://git.mauras.ch/docker/alpinelinux
    voidlinux:
      url: https://git.mauras.ch/docker/voidlinux
