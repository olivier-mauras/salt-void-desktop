#!/bin/bash

# Wlan or Ethernet mode
CONKY_CONF=$1

# Paths
IMG="/home/coredumb/.spectrwm/icons"

# Colors
DG="#626262"
LG="#d0d0d0"
RED="#BD1B5E"
BLUE="#4c7899"
WHITE="#FFFFFF"
GREEN="#afd700"
ORANGE="#ff8700"
S="${BLUE}|"
SS="${BLUE}/"
R="^fg()"

# Variables
CPUT=70
GPUT=65
DISKP="/var"
DISKM=90
DISKH=95

cpu_temp() {
    TEMP=$CPUT
    unset T1
    T1=$(($(cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input) / 1000))

    echo "${T1}°"
}

cpu_color() {
    TEMP=$CPUT
    unset T1
    T1=$(($(cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input) / 1000))

    if [ $T1 -ge $TEMP ]; then
        CPU_COLOR="${RED}"
    else
        CPU_COLOR="${LG}"
    fi

    echo "${CPU_COLOR}"
}

snd_() {
    pactl list sinks | grep Volume | head -1 | awk '{print $5}'
}

bat_() {
    BAT_LVL=$(cat /sys/class/power_supply/BAT0/uevent| grep POWER_SUPPLY_CAPACITY=|cut -f 2 -d =)

    if [ $BAT_LVL -le 20 ]; then
        BAT_COLOR="${RED}"
    elif [ $BAT_LVL -le 30 ]; then
        BAT_COLOR="${ORANGE}"
    else
        BAT_COLOR="${LG}"
    fi

	if [ $BAT_LVL -le 8 ]; then
		if [ ! -f /tmp/i3_bat ]; then
			sed -i 's@background #262626@background #FFFFFF@' .i3/config 
			i3-msg reload &> /dev/null
			touch /tmp/i3_bat
		fi
	else
		if [ -f /tmp/i3_bat ]; then
			sed -i 's@background #FFFFFF@background #262626@' .i3/config 
            i3-msg reload &> /dev/null
            rm -f /tmp/i3_bat
		fi
	fi

    echo "${BAT_LVL}%"
}

bat_color() {
    BAT_LVL=$(cat /sys/class/power_supply/BAT0/uevent| grep POWER_SUPPLY_CAPACITY=|cut -f 2 -d =)

    if [ $BAT_LVL -le 20 ]; then
        BAT_COLOR="${RED}"
    elif [ $BAT_LVL -le 30 ]; then
        BAT_COLOR="${ORANGE}"
    else
        BAT_COLOR="${LG}"
    fi

    echo "${BAT_COLOR}"
}

gpu_temp() {
    TEMP=$GPUT

    C0=$(nvidia-settings -q GPUCoreTemp | grep Attribute | sed -s 's/^.* //;s/.$//')

    if [ $C0 -ge $TEMP ]; then
        C0="${RED}$C0"
    fi

    echo "${DG}GPU: ${R}${LG}${C0}°${R}"
}

mem_used() {
    USED=$(free -m | grep Mem | awk '{print $3}')
    echo "${USED}"
}

mem_total() {
    TOTAL=$(free -m | grep Mem | awk '{print $2}')
    echo "${TOTAL}"
}

mem_color() {
    MID=7000
    HIGH=9800
    
    USED=$(free -m | grep Mem | awk '{print $3}')

    if [ $USED -ge $HIGH ]; then
        MEM_COLOR="${RED}"
    elif [ $USED -ge $MID ]; then
        MEM_COLOR="${ORANGE}"
    else
        MEM_COLOR="${LG}"
    fi

    echo "${MEM_COLOR}"
}

cpu() {
  echo "$(curl "127.0.0.1:19999/api/v1/data?chart=system.cpu" 2>/dev/null | head -5 | tail -1 | tr ']' ' ' | awk -F, '{printf "%3.0f%", $7+$8}' | sed 's/.* //')"
}

network_() {
    DOWN="${arr_conky[0]}/s"
    UP="${arr_conky[1]}/s"

    echo "${GREEN}^i(${IMG}/down.xbm)${R}${DOWN} ${ORANGE}^i(${IMG}/up.xbm)${R}${UP}"
}

disk_free() {
    DLINE=$(df -h ${DISKP} | tail -1 | awk '{print $2";"$4";"$5}' | sed 's/%//')
    DISK_ARR=(${DLINE//;/ })

    FREE="${DISK_ARR[1]}"
    echo "${FREE}"
}

disk_total() {
    DLINE=$(df -h ${DISKP} | tail -1 | awk '{print $2";"$4";"$5}' | sed 's/%//')
    DISK_ARR=(${DLINE//;/ })

    TOTAL="${DISK_ARR[0]}"
    echo "${TOTAL}"
}

nfs1_() {
    DLINE=$(df -h /nfs/movies | tail -1 | awk '{print $2";"$3";"$5}' | sed 's/%//')
    DISK_ARR=(${DLINE//;/ })

    if [ ${DISK_ARR[2]} -ge $DISKH ]; then
        FREE="${RED}${DISK_ARR[1]}${R}"
    elif [ ${DISK_ARR[2]} -ge $DISKM ]; then
        FREE="${ORANGE}${DISK_ARR[1]}${R}"
    else
        FREE="${LG}${DISK_ARR[1]}${R}"
    fi

    echo "${DG}NFS1: ${R}${FREE}${SS}${LG}${DISK_ARR[0]}${R}"
}

date_() {
    TIME=$(date +"%H:%M")
    DAY=$(date +"%a, %d.%m")

    echo "${DG}$DAY ${WHITE}${TIME}${R}  "
}

bright_() {
    BRIGHTNESS=$(($(sudo cat /sys/class/backlight/acpi_video0/actual_brightness)*6))
    echo "${BRIGHTNESS}%"
}

#echo "^p(_LEFT)^p(-5)$(ws_) ^p(_CENTER)^p(-30)$(cpu) ${S} $(mem) ${S} $(disk_) ${S} $(cpu_temp) ${S} $(bright_) ${S} $(bat_) ${S} $(date_)"
#done

echo '{ "version": 1 }'
# Begin the endless array.
echo '['
# We send an empty first array of blocks to make the loop simpler:
echo '[]'
# Now send blocks with information forever:
while :;
do
    echo ",[ \
            {\"name\":\"cpu\",\"full_text\":\"CPU:\", \"color\": \"${DG}\", \"separator\": false}, \
            {\"name\":\"cpu_val\",\"full_text\":\"$(cpu)\", \"color\": \"${LG}\", \"separator\": false}, \
            {\"name\":\"sep\",\"full_text\":\"|\", \"color\": \"${BLUE}\", \"separator\": false}, \
            {\"name\":\"mem\",\"full_text\":\"RAM:\", \"color\": \"${DG}\", \"separator\": false}, \
            {\"name\":\"mem_used\",\"full_text\":\"$(mem_used)\", \"color\": \"$(mem_color)\", \"separator\": false, \"separator_block_width\": 0}, \
            {\"name\":\"mem_sep\",\"full_text\":\"/\", \"color\": \"${BLUE}\", \"separator\": false, \"separator_block_width\": 0}, \
            {\"name\":\"mem_total\",\"full_text\":\"$(mem_total)\", \"color\": \"${LG}\", \"separator\": false}, \
            {\"name\":\"sep\",\"full_text\":\"|\", \"color\": \"${BLUE}\", \"separator\": false}, \
            {\"name\":\"disk\",\"full_text\":\"DISK:\", \"color\": \"${DG}\", \"separator\": false}, \
            {\"name\":\"disk_free\",\"full_text\":\"$(disk_free)\", \"color\": \"${LG}\", \"separator\": false, \"separator_block_width\": 0}, \
            {\"name\":\"disk_sep\",\"full_text\":\"/\", \"color\": \"${BLUE}\", \"separator\": false, \"separator_block_width\": 0}, \
            {\"name\":\"disk_total\",\"full_text\":\"$(disk_total)\", \"color\": \"${LG}\", \"separator\": false}, \
            {\"name\":\"sep\",\"full_text\":\"|\", \"color\": \"${BLUE}\", \"separator\": false}, \
            {\"name\":\"cpu\",\"full_text\":\"CPU:\", \"color\": \"${DG}\", \"separator\": false}, \
            {\"name\":\"cpu_val\",\"full_text\":\"$(cpu_temp)\", \"color\": \"$(cpu_color)\", \"separator\": false}, \
            {\"name\":\"sep\",\"full_text\":\"|\", \"color\": \"${BLUE}\", \"separator\": false}, \
            {\"name\":\"bat\",\"full_text\":\"BAT:\", \"color\": \"${DG}\", \"separator\": false}, \
            {\"name\":\"bat_val\",\"full_text\":\"$(bat_)\", \"color\": \"$(bat_color)\", \"separator\": false}, \
            {\"name\":\"sep\",\"full_text\":\"|\", \"color\": \"${BLUE}\", \"separator\": false}, \
            {\"name\":\"snd\",\"full_text\":\"SND:\", \"color\": \"${DG}\", \"separator\": false}, \
            {\"name\":\"snd_val\",\"full_text\":\"$(snd_)\", \"color\": \"${LG}\", \"separator\": false}, \
            {\"name\":\"sep\",\"full_text\":\"|\", \"color\": \"${BLUE}\", \"separator\": false}, \
            {\"name\":\"date\",\"full_text\":\"$(date +"%a, %d.%m")\", \"color\": \"${DG}\", \"separator\": false}, \
            {\"name\":\"time\",\"full_text\":\"$(date +"%H:%M")\", \"color\": \"${WHITE}\"} \
    ]"
    sleep 2
done

