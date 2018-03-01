# Deploy /etc/rc.local
base.local.etc.rc.local:
  file.managed:
    - name: /etc/rc.local
    - source: salt://base/files/rc.local
    - user: root
    - group: root
    - mode: 755
