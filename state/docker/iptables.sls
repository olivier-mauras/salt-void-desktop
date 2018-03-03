# Load macro
{% from 'libs/file.sls' import file_managed with context %}

{{ file_managed('salt://docker/files/iptables.rules',
                '/etc/iptables/iptables.rules',
                template='jinja',
                watch_in={'service': 'docker.iptables.service'})
}}

# This will fail in the post-install chroot
docker.iptables.service:
  service.running:
    - name: iptables
    - restart: True
