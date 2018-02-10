# Install all X/WM packages and tools required
wm.pkg:
  pkg.installed:
    - pkgs:
      - i3
      - i3lock
      - i3status
      - perl-AnyEvent-I3
      - xinit
      - xorg-minimal
      - xorg-server-xephyr
      - xf86-video-intel
      - xf86-input-synaptics
      - xf86-input-evdev
      - xrandr
      - xterm
      - rxvt-unicode
      - rxvt-unicode-terminfo
      - alsa-utils 
      - pulseaudio 
      - ConsoleKit2
      - sxhkd
      - font-misc-misc
      - font-cursor-misc
      - dejavu-fonts-ttf
      - dmenu
      - htop
      - vim
      - zsh
      - zsh-completions

# Pulseaudio required services
# Dbus is already enabled by libvirt but that's for reusability sake. 
{% for i in ['alsa', 'dbus', 'cgmanager' 'consolekit'] %}
wm.services.enabled.{{ i }}:
  file.symlink:
    - name: /etc/runit/runsvdir/default/{{ i }}
    - target: /etc/sv/{{ i }}
{% endfor %}

