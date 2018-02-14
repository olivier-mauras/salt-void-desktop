docker.iptables.iptables.rules:
  file.managed:
    - name: /etc/iptables/iptables.rules
    - source: salt://docker/files/iptables.rules
    - user: root
    - group: root
    - mode: 640
    - template: jinja

# This will fail in the post-install chroot
docker.iptables.service:
  service.running:
    - name: iptables
    - restart: True
    - watch:
        - file: docker.iptables.iptables.rules
