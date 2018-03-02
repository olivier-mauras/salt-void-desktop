# file.managed macro
{% macro file_managed(source, dest, user='root', group='root', mode='640', makedirs='True') %}
macro.file_managed.{{ dest }}:
  file.managed:
    - name: {{ dest }}
    - source: {{ source }}
    - user: {{ user }}
    - group: {{ group }}
    - mode: {{ mode }}
    - makedirs: {{ makedirs }}
{% endmacro %}

# file.recurse macro
{% macro file_recurse(source, dest, user=username, group=username, mode='640', dirmode='750', makedirs='True') %}
macro.file_recurse.{{ dest }}:
  file.recurse:
    - name: {{ dest }}
    - source: {{ source }}
    - user: {{ user }}
    - group: {{ group }}
    - makedirs: {{ makedirs }}
    - dir_mode: {{ dirmode }}
{% if mode != 'keep' %}
    - file_mode: {{ mode }}
{% endif %}
    - keep_symlinks: True
{% endmacro %}
