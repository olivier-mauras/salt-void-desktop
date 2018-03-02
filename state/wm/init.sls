# Load macros
{% from 'libs/file.sls' import file_managed with context %}
{% from 'libs/file.sls' import file_symlink with context %}

# Install all X/WM packages and tools required
wm.pkg:
  pkg.installed:
    - pkgs:
      - ConsoleKit2
      - CopyQ
      - ImageMagick
      - alsa-utils
      - dejavu-fonts-ttf
      - dmenu
      - font-cursor-misc
      - font-misc-misc
      - htop
      - i3
      - i3lock
      - i3status
      - kbd
      - pavucontrol
      - perl-AnyEvent-I3
      - pulseaudio 
      - python3-psutil
      - rxvt-unicode
      - rxvt-unicode-terminfo
      - scrot
      - setxkbmap
      - sxhkd
      - vim
      - xauth
      - xclip
      - xf86-input-evdev
      - xf86-input-synaptics
      - xf86-video-dummy
      - xf86-video-intel
      - xinit
      - xorg-minimal
      - xorg-server-xephyr
      - xpra
      - xprop
      - xrandr
      - xset
      - xterm
      - zsh
      - zsh-completions
{% if salt['file.is_link']('/sys/class/power_supply/BAT0') %}
      - pm-utils
      - upower
{% endif %}

# Install x11docker
{{ file_managed('salt://wm/files/usr/bin/x11docker', '/usr/bin/x11docker', mode='755') }}

# Add default alsa state only if file doesn't exists
wm.file.var.lib.alsa.asound.state:
  file.managed:
    - name: /var/lib/alsa/asound.state
    - source: salt://wm/files/var/lib/alsa/asound.state
    - makedirs: True
    - unless:
      - ls /var/lib/alsa/asound.state

# Pulseaudio required services
# Dbus is already enabled by libvirt but that's for reusability sake. 
{% for i in ['alsa', 'dbus', 'cgmanager' 'consolekit'] %}
{{ file_symlink('/etc/runit/runsvdir/default/' + i, '/etc/sv/' + i) }}
{% endfor %}

