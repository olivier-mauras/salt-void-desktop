# Load macros
{% from 'libs/file.sls' import file_managed with context %}
{% from 'libs/file.sls' import file_recurse with context %}

# Set default salt path
{% set home_files = 'salt://userenv/files/home/' %}

# Set homedir
{% set homedir = '/home/' + username + '/' %}

# Deploy ~/bin
{{ file_recurse(home_files + 'bin', homedir + 'bin', mode='750') }}

# ZSH
{{ file_recurse(home_files + 'zsh', homedir + '.zsh') }}
{{ file_managed(home_files + 'zshrc', homedir + '.zshrc') }}

# Vim
{{ file_managed(home_files + 'vim/vimrc', homedir + '.vimrc') }}
{{ file_managed(home_files + 'vim/BusyBee.vim', homedir + '.vim/colors/BusyBee.vim') }}

# X
{{ file_managed(home_files + 'Xdefaults', homedir + '.Xdefaults') }}
{{ file_managed(home_files + 'xinitrc', homedir + '.xinitrc') }}

# i3
{{ file_recurse(home_files + 'i3', homedir + '.i3', mode='keep') }}

# Sxhkd
{{ file_managed(home_files + 'sxhkdrc', homedir + '.config/sxhkd/sxhkdrc') }}
