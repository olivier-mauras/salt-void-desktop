libvirt.pkg:
  pkg.installed:
    - pkgs:
      - libvirt
      - qemu
      - virt-manager

{% for i in ['dbus', 'libvirtd', 'virtlogd', 'virtlockd'] %}
libvirt.services.enabled.{{ i }}:
  file.symlink:
    - name: /etc/runit/runsvdir/default/{{ i }}
    - target: /etc/sv/{{ i }}
{% endfor %}

# Deploy libvirt configuration files
# Global config

# Network
libvirt.config.networks.default:
  file.absent:
    - name: /etc/libvirt/qemu/networks/default.xml

libvirt.config.networks.default.autostart:
  file.absent:
    - name: /etc/libvirt/qemu/networks/autostart/default.xml

{% for network in ['trust', 'untrust', 'tor'] %}
libvirt.config.networks.{{ network }}:
  file.managed:
    - name: /etc/libvirt/qemu/networks/{{ network }}.xml
    - source: salt://libvirt/files/libvirt/qemu/networks/{{ network }}.xml
    - user: root
    - group: root
    - mode: 600

libvirt.config.networks.{{ network }}.autostart:
  file.symlink:
    - name: /etc/libvirt/qemu/networks/autostart/{{ network }}.xml
    - target: /etc/libvirt/qemu/networks/{{ network }}.xml
{% endfor %}
