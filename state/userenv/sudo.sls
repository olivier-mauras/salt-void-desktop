base.sudo.sudoers.d:
  file.recurse:
    - name: /etc/sudoers.d
    - source: salt://userenv/files/sudoers.d
    - clean: True
    - user: root
    - group: root
    - dir_mode: 750
    - file_mode: 440
    - template: jinja
    - context:
        user: {{ pillar['username'] }}
