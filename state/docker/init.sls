# Prepare docker volume
include:
  - .lvm
  - .images

# Install packages
docker.pkg:
  pkg.installed:
    - name: docker

# Deploy docker global configuration
docker.config.daemon.json:
  file.managed:
    - name: /etc/docker/daemon.json
    - source: salt://docker/files/daemon.json
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
#    - listen_in:
#      - service: docker.service.restart

# Enable service
docker.services.enable:
  file.symlink:
    - name: /etc/runit/runsvdir/default/docker
    - target: /etc/sv/docker

# Network
{% for network, config in salt['pillar.get']('docker:networks').iteritems() %}
{% set driver = config['driver'] %}
{% set subnet = config['subnet'] %}
{% set gateway = config['gateway'] %}
{% set range = config['range'] %}
{% set interface = config['interface'] %}
docker.config.networks.{{ network }}:
  cmd.run:
    - name: docker network create -d {{ driver }} --subnet={{ subnet }} --ip-range={{ range }} --gateway={{ gateway }} -o parent={{ interface }} {{ network }}
    - unless:
      - docker network ls | grep {{ network }}

docker.config.networks.{{ network }}.edit:
  cmd.run:
    - name: docker network rm {{ network }} && docker network create -d {{ driver }} --subnet={{ subnet }} --ip-range={{ range }} --gateway={{ gateway }} -o parent={{ interface }} {{ network }}
    - unless:
      - docker network inspect {{ network }} | grep Subnet | grep {{ subnet }}
      - docker network inspect {{ network }} | grep IPRange |grep {{ range }}
      - docker network inspect {{ network }} | grep Gateway | grep {{ gateway }}
      - docker network inspect {{ network }} | grep parent | grep {{ interface }}
{% endfor %}

# Service restart
docker.service.restart:
  service.running:
    - name: docker
    - restart: True
