{% for i in ['3', '4', '5', '6'] %}
base.services.removed.tty{{ i }}:
  file.absent:
    - name: /etc/runit/runsvdir/default/agetty-tty{{ i }}
{% endfor %}

{% for i in ['cronie', 'rsyslogd'] %}
base.services.enabled.{{ i }}:
  file.symlink:
    - name: /etc/runit/runsvdir/default/{{ i }}
    - target: /etc/sv/{{ i }}
{% endfor %}
