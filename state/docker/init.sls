# Load macros
{% from 'libs/file.sls' import file_managed with context %}
{% from 'libs/file.sls' import file_symlink with context %}

# Prepare docker volume
include:
  - .lvm
  - .images
  - .iptables

# Install packages
docker.pkg:
  pkg.installed:
    - name: docker

# Deploy docker global configuration
{{ file_managed('salt://docker/files/daemon.json',
                '/etc/docker/daemon.json',
                mode='600')
}}

# Enable service
{{ file_symlink('/etc/runit/runsvdir/default/docker',
                '/etc/sv/docker')
}}

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
