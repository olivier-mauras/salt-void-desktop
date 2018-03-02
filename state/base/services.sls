# Load macros
{% from 'libs/file.sls' import file_symlink with context %}

{% for i in ['3', '4', '5', '6'] %}
base.services.removed.tty{{ i }}:
  file.absent:
    - name: /etc/runit/runsvdir/default/agetty-tty{{ i }}
{% endfor %}

{% for i in ['cronie', 'rsyslogd', 'iptables', 'netdata'] %}
{{ file_symlink('/etc/runit/runsvdir/default/' + i, '/etc/sv/' + i) }}
{% endfor %}
