#!/bin/bash
BFILE="/sys/class/backlight/acpi_video0/brightness"

echo $(( $(sudo cat $BFILE)+1)) | sudo tee $BFILE
