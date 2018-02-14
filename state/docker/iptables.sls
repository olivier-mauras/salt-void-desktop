docker.iptables:
  file.managed:
    - name: /etc/iptables/iptables.rules
    - source: salt://docker/files/iptables.rules
    - user: root
    - group: root
    - mode: 640
    - template: jinja
