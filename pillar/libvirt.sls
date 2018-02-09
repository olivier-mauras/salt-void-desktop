libvirt:
  services:
    - dbus
    - libvirtd
    - virtlogd
    - virtlockd
  networks:
    - trust
    - untrust
    - tor
  storage:
    vm:
      size: 10G
      mnt: /srv/libvirt/vm
