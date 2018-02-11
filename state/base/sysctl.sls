{% for sysopt, args in salt['pillar.get']('base:sysctl', {}).iteritems() %}
base.sysctl.{{ sysopt }}:
  sysctl.present:
    - name: {{ sysopt }}
    - value: {{ pillar['sysctl'][sysopt] }}
    - config: /etc/sysctl.conf
{% endfor %}
