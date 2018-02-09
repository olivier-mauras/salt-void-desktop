include:
  - .packages
  - .services
  - .logrotate
  - .sudo
{% if 'Intel' in grains['cpu_model'] %}
  - .intel-microcode
{% endif %}
