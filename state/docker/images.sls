# This state deploys latest versions of docker image buidling scripts from here:
# https://git.mauras.ch/docker/alpinelinux
# https://git.mauras.ch/docker/voidlinux
docker.images.directory:
  file.directory:
    - name: /srv/docker/images
    - user: coredumb
    - group: coredumb
    - require: 
      - user: userenv.user.create

{% for repo, conf in salt['pillar.get']('docker:images').iteritems() %}
docker.images.git.latest.{{ repo }}:
  git.latest:
    - name: {{ conf['url'] }}
    - target: /srv/docker/images/{{ repo }}
    - force_checkout: True
    - force_reset: True
    - user: coredumb
    - require:
      - user: userenv.user.create
{% endfor %}
