#!/usr/bin/zsh
HEART='❤ '
SLOTS_MAX=10
SLOTS_WARNING=5
SLOTS_CRITICAL=3

BATTERY=BAT1

while [ $# -gt 0 ] ; do
	case $1 in
		percent) unset HEART ; SLOTS_MAX=100 ; SLOTS_WARNING=50 ; SLOTS_CRITICAL=30 ;;
		slots_max=*) SLOTS_MAX=${1##slots_max=} ;;
		slots_warning=*) SLOTS_WARNING=${1##slots_warning=} ;;
		slots_critical=*) SLOTS_CRITICAL=${1##slots_critical=} ;;
		battery=*) BATTERY=${1##battery=} ;;
	esac
	shift
done

if [[ `uname` == 'Linux' ]]; then
  current_charge=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep percentage | awk '{print $2}' | sed 's/%//g')
  total_charge=100
else
  battery_info=`ioreg -rc AppleSmartBattery`
  current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
  total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')
fi

#charged_slots=$(echo "((($current_charge/$total_charge)*10)/3)+1" | bc -l | cut -d '.' -f 1)
charged_slots=$(( ${current_charge} * 100 / ${total_charge} * ${SLOTS_MAX} / 100 ))
if [[ ${charged_slots} -gt ${SLOTS_MAX} ]] ; then
	charged_slots=${SLOTS_MAX}
fi

if [[ "${HEART}" ]] ; then
	if [ "${charged_slots}" -lt "${SLOTS_CRITICAL}" ] ; then
		echo -n '#[fg=red,blink]'
	else
		echo -n '#[fg=red]'
	fi
	for i in $(seq 1 ${charged_slots}) ; do
		echo -n "${HEART}"
	done
	echo -n '#[fg=white,noblink]'
	for i in $(seq 1 $(( ${SLOTS_MAX} - ${charged_slots} ))) ; do
		echo -n "${HEART}"
	done
else
	if [ "${charged_slots}" -lt "${SLOTS_CRITICAL}" ] ; then
		echo -n '#[fg=red,blink]'
	elif [ "${charged_slots}" -lt "${SLOTS_WARNING}" ] ; then
		echo -n '#[fg=yellow]'
	else
		echo -n '#[fg=green]'
	fi
	case "${charging}" in
		discharging) echo -n '-' ;;
		charging) echo -n '+' ;;
		charged) echo -n '=' ;;
		*) ;;
	esac
	echo -n "${charged_slots}%#[noblink]"
fi
