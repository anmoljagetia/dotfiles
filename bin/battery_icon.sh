#!/bin/bash

get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value="$(tmux show-option -gqv "$option")"
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

is_osx() {
	[ $(uname) == "Darwin" ]
}

command_exists() {
	local command="$1"
	type "$command" >/dev/null 2>&1
}

battery_status() {
	if command_exists "pmset"; then
		pmset -g batt | awk -F '; *' 'NR==2 { print $2 }'
	elif command_exists "upower"; then
		# sort order: attached, charging, discharging
		for battery in $(upower -e | grep battery); do
			upower -i $battery | grep state | awk '{print $2}'
		done | sort | head -1
	elif command_exists "acpi"; then
		acpi -b | grep -oi 'discharging' | awk '{print tolower($0)}'
	fi
}

# script global variables
charged_icon=""
charging_icon=""
attached_icon=""
discharging_icon=""

charged_default="❇ "
charged_default_osx="🔋 "
charging_default="⚡️ "
attached_default="⚠️ "
discharging_default=""

charged_default() {
	echo "$charged_default"
}

# icons are set as script global variables
get_icon_settings() {
	charged_icon=$(get_tmux_option "@batt_charged_icon" "$(charged_default)")
	charging_icon=$(get_tmux_option "@batt_charging_icon" "$charging_default")
	attached_icon=$(get_tmux_option "@batt_attached_icon" "$attached_default")
	discharging_icon=$(get_tmux_option "@batt_discharging_icon" "$discharging_default")
}

print_icon() {
	local status=$1
	if [[ $status =~ (charged) ]]; then
		printf "$charged_icon"
	elif [[ $status =~ (^charging) ]]; then
		printf "$charging_icon"
	elif [[ $status =~ (^discharging) ]]; then
		printf "$discharging_icon"
	elif [[ $status =~ (attached) ]]; then
		printf "$attached_icon"
	fi
}

main() {
	get_icon_settings
	status=$(battery_status)
	print_icon "$status"
}
main
