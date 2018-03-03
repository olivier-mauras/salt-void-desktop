# file.managed macro
{% macro file_managed(source,
                      dest,
                      user='root',
                      group='root',
                      mode='640',
                      makedirs='True',
                      template='none',
                      context={},
                      unless=[],
                      onlyif=[],
                      listen_in={}) %}
macro.file_managed.{{ dest }}:
  file.managed:
    - name: {{ dest }}
    - source: {{ source }}
    - user: {{ user }}
    - group: {{ group }}
    - mode: {{ mode }}
    - makedirs: {{ makedirs }}
{% if unless %}
    - unless:
{% for cmd in unless %}
      - {{ cmd }}
{% endfor %}
{% endif %}
{% if onlyif %}
    - onlyif:
{% for cmd in onlyif %}
      - {{ cmd }}
{% endfor %}
{% endif %}
{% if template != 'none' %}
    - template: {{ template }}
{% endif %}
{% if context %}
    - context:
{% for var, val in context.iteritems() %}
        {{ var }}: {{ val }}
{% endfor %}
{% endif %}
{% if listen_in %}
    - listen_in:
{% for type, state in listen_in.iteritems() %}
      - {{ type }}: {{ state }}
{% endfor %}
{% endif %}
{% endmacro %}

# file.recurse macro
{% macro file_recurse(source,
                      dest,
                      user='root',
                      group='root',
                      mode='640',
                      dirmode='750',
                      makedirs='True') %}
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

# file.symlink
{% macro file_symlink(name, target, listen_in={}) %}
macro.file_symlink.{{ name }}:
  file.symlink:
    - name: {{ name }}
    - target: {{ target }}
{% if listen_in %}
    - listen_in:
{% for type, state in listen_in.iteritems() %}
      - {{ type }}: {{ state }}
{% endfor %}
{% endif %}
{% endmacro %}
