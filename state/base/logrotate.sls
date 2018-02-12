base.logrotate.logrotate.conf:
  file.managed:
    - name: /etc/logrotate.conf
    - source: salt://base/files/logrotate.conf
    - user: root
    - group: root
    - mode: 640

base.logrotate.logrotate.d:
  file.recurse:
    - name: /etc/logrotate.d
    - source: salt://base/files/logrotate.d
    - user: root
    - group: root
    - dir_mode: 750
    - file_mode: 640
