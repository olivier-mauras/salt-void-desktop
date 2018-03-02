# Load macros
{% from 'libs/file.sls' import file_managed with context %}
{% from 'libs/file.sls' import file_recurse with context %}

# Retrieve the default username from pillars
{% set username = pillar['username'] %}

# Set default salt path
{% set home_files = 'salt://userenv/files/home/' %}

# Set homedir
{% set homedir = '/home/' + username + '/' %}

# Deploy ~/bin
{{ file_recurse(home_files + 'bin', homedir + 'bin', mode='750', user=username, group=username) }}

# ZSH
{{ file_recurse(home_files + 'zsh', homedir + '.zsh', user=username, group=username) }}
{{ file_managed(home_files + 'zshrc', homedir + '.zshrc', user=username, group=username) }}

# Vim
{{ file_managed(home_files + 'vim/vimrc', homedir + '.vimrc', user=username, group=username) }}
{{ file_managed(home_files + 'vim/BusyBee.vim', homedir + '.vim/colors/BusyBee.vim', user=username, group=username) }}

# X
{{ file_managed(home_files + 'Xdefaults', homedir + '.Xdefaults', user=username, group=username) }}
{{ file_managed(home_files + 'xinitrc', homedir + '.xinitrc', user=username, group=username) }}

# i3
{{ file_recurse(home_files + 'i3', homedir + '.i3', mode='keep', user=username, group=username) }}

# Sxhkd
{{ file_managed(home_files + 'sxhkdrc', homedir + '.config/sxhkd/sxhkdrc', user=username, group=username) }}
