{% for storage, config in salt['pillar.get']('libvirt:storage').iteritems() %}
libvirt.lvm.storage.create.{{ storage }}:
  lvm.lv_present:
    - name: {{ storage }}
    - vgname: vgpool
    - size: {{ config['size'] }}

  blockdev.formatted:
    - name: /dev/mapper/vgpool-{{ storage }}
    - fs_type: ext4

  mount.mounted:
    - name: {{ config['mnt'] }}
    - device: /dev/mapper/vgpool-{{ storage }}
    - fstype: ext4
    - opts: rw,relatime,data=ordered,discard
    - dump: 0
    - pass_num: 0
{% endfor %}
