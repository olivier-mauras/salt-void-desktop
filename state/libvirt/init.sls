# Load macros
{% from 'libs/file.sls' import file_managed with context %}
{% from 'libs/file.sls' import file_symlink with context %}


# Install packages and enable services
libvirt.pkg:
  pkg.installed:
    - pkgs:
      - libvirt
      - qemu
      - virt-manager

{% for service in salt['pillar.get']('libvirt:services') %}
{{ file_symlink('/etc/runit/runsvdir/default/' + service, '/etc/sv/' + service) }}
{% endfor %}

# Deploy libvirt configuration files
# Global config
{{ file_managed('salt://libvirt/files/libvirtd.conf',
                '/etc/libvirt/libvirtd.conf',
                mode='644',
                listen_in={'service': 'libvirt.service.restart'}) }}

# Network
libvirt.config.networks.default:
  file.absent:
    - name: /etc/libvirt/qemu/networks/default.xml

libvirt.config.networks.default.autostart:
  file.absent:
    - name: /etc/libvirt/qemu/networks/autostart/default.xml

{% for network in salt['pillar.get']('libvirt:networks') %}
{{ file_managed('salt://libvirt/files/qemu/networks/' + network,
                '/etc/libvirt/qemu/networks/' + network,
                mode='600') }}

{{ file_symlink('/etc/libvirt/qemu/networks/autostart/' + network,
                '/etc/libvirt/qemu/networks/' + network + '.xml',
                listen_in={'service': 'libvirt.service.restart'}) }}
{% endfor %}

# Storage
include:
  - .lvm

libvirt.config.storage.default:
  file.absent:
    - name: /etc/libvirt/storage/default.xml

libvirt.config.storage.default.autostart:
  file.absent:
    - name: /etc/libvirt/storage/autostart/default.xml

{% for storage, config in salt['pillar.get']('libvirt:storage').iteritems() %}
libvirt.config.storage.{{ storage }}:
  file.managed:
    - name: /etc/libvirt/storage/{{ storage }}.xml
    - source: salt://libvirt/files/storage/storage.jinja
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
    - template: jinja
    - context:
        name: {{ storage }}
        path: {{ config['mnt'] }}

libvirt.config.storage.{{ storage }}.autostart:
  file.symlink:
    - name: /etc/libvirt/storage/autostart/{{ storage }}.xml
    - target: /etc/libvirt/storage/{{ storage }}.xml
    - makedirs: True
    - listen_in:
      - service: libvirt.service.restart
{% endfor %}

# Service restart
libvirt.service.restart:
  service.running:
    - name: libvirtd
    - restart: True
