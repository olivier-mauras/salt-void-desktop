# Populate user config files
# Retrieve username as a variable
{% set username = pillar['username'] %}

# Declare macro
{% macro deploy_file(source, dest, user=username, group=username, mode='640', makedirs='True', recurse='False') %}
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

# Set homedire
{% set homedir = '/home/' + username + '/' %}

# Deploy ~/bin
{{ deploy_file(home_files + 'bin', homedir + 'bin', mode='750', recurse='True') }}

# ZSH
{{ deploy_file(home_files + 'zsh', homedir + '.zsh', recurse='True') }}
{{ deploy_file(home_files + 'zshrc', homedir + '.zshrc') }}

# Vim
{{ deploy_file(home_files + 'vim/vimrc', homedir + '.vimrc') }}
{{ deploy_file(home_files + 'vim/BusyBee.vim', homedir + '.vim/colors/BusyBee.vim') }}

# X
{{ deploy_file(home_files + 'Xdefaults', homedir + '.Xdefaults') }}
{{ deploy_file(home_files + 'xinitrc', homedir + '.xinitrc') }}

# i3
{{ deploy_file(home_files + 'i3', homedir + '.i3', recurse='True') }}

# Sxhkd
{{ deploy_file(home_files + 'sxhkdrc', homedir + '.config/sxhkd/sxhkdrc') }}
