userenv.user.create:
  user.present:
    - name: coredumb
    - shell: /usr/bin/zsh
    - uid: 1000
    - gid: 1000
    - groups:
      - kvm
      - docker
      - libvirt
      - video
{% if pillar['user_passwd'] is defined %}
    - password: {{ pillar['user_passwd'] }}
    - hash_password: True
    - enforce_password: True
{% endif %}
