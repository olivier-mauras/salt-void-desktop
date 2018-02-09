base.intel-microde.pkg:
  pkg.installed:
    - name: intel-ucode

base.intel-microde.reconfigure.linux:
  cmd.script:
    - source: salt://base/scripts/kernel_reconfigure.sh
    - onchanges:
      - pkg: base.intel-microde.pkg
