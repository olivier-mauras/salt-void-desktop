# Populate user config files
# Let's use a macro for that
{% macro deploy_file(source, dest, user='coredumb', group='coredumb', mode='640', makedirs='True') %}
userenv.home_datas.{{ dest }}:
  file.managed:
    - name: {{ dest }}
    - source: {{ source }}
    - user: {{ user }}
    - group: {{ group }}
    - mode: {{ mode }}
    - makedirs: {{ makedirs }}
{% endmacro %}

# Set default salt path
{% set home_files = 'salt://userenv/files/home/' %}

# Sxhkd
{{ deploy_file(home_files + 'sxhkdrc', '/home/coredumb/.config/sxhkd/sxhkdrc') }}

# Vim
{{ deploy_file(home_files + '/vim/vimrc', '/home/coredumb/.vimrc') }}
