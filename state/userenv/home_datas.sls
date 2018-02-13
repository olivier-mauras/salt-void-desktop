# Populate user config files
# Let's use a macro for that
{% macro deploy_file(source, dest, user='coredumb', group='coredumb', mode='640', makedirs='True', recurse='False') %}
userenv.home_datas.{{ dest }}:
{% if recurse == 'True' %}
  file.recurse:
    - file_mode: {{ mode }}
    - dir_mode: 750
{% else %}
  file.managed:
    - mode: {{ mode }}
{% endif %}
    - name: {{ dest }}
    - source: {{ source }}
    - user: {{ user }}
    - group: {{ group }}
    - makedirs: {{ makedirs }}
{% endmacro %}

# Set default salt path
{% set home_files = 'salt://userenv/files/home/' %}

# Deploy ~/bin
{{ deploy_file(home_files + 'bin', '/home/coredumb/bin', mode='750', recurse='True') }}

# ZSH
{{ deploy_file(home_files + 'zsh', '/home/coredumb/.zsh', recurse='True') }}
{{ deploy_file(home_files + 'zshrc', '/home/coredumb/.zshrc') }}

# Vim
{{ deploy_file(home_files + 'vim/vimrc', '/home/coredumb/.vimrc') }}
{{ deploy_file(home_files + 'vim/BusyBee.vim', '/home/coredumb/.vim/colors/BusyBee.vim') }}

# X
{{ deploy_file(home_files + 'Xdefaults', '/home/coredumb/.Xdefaults') }}
{{ deploy_file(home_files + 'xinitrc', '/home/coredumb/.xinitrc') }}

# i3
{{ deploy_file(home_files + 'i3', '/home/coredumb/.i3', recurse='True') }}

# Sxhkd
{{ deploy_file(home_files + 'sxhkdrc', '/home/coredumb/.config/sxhkd/sxhkdrc') }}
