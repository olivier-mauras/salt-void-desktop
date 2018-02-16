userenv.group.create:
  group.present:
    - name: coredumb
    - gid: 1000

userenv.user.create:
  user.present:
    - name: coredumb
    - shell: /bin/zsh
    - uid: 1000
    - gid_from_name: True
    - groups:
      - kvm
      - docker
      - libvirt
      - audio
      - video
{% if pillar['user_passwd'] is defined %}
    - password: {{ pillar['user_passwd'] }}
    - hash_password: True
    - enforce_password: True
{% endif %}
    - require:
      - group: userenv.group.create
