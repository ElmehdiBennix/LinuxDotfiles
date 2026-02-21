#!/bin/bash

if [ $# -eq 0 ]; then
	echo "Usage: $0 --title | --arturl | --artist | --length | --album | --source"
	exit 1
fi

get_metadata() {
	playerctl metadata --format "{{ $1 }}" 2>/dev/null
}

get_source_info() {
	trackid=$(get_metadata "mpris:trackid")
	if [[ "$trackid" == *"firefox"* ]]; then
		echo -e "Firefox 󰈹"
	elif [[ "$trackid" == *"spotify"* ]]; then
		echo -e "Spotify "
	elif [[ "$trackid" == *"chromium"* || "$trackid" == *"chrome"* ]]; then
		echo -e "Chrome "
	elif [[ "$trackid" == *"zen"* ]]; then
		echo -e "Zen 󰈹"
	elif [[ "$trackid" == *"vlc"* ]]; then
		echo -e "VLC 󰕼"
	elif [[ "$trackid" == *"mpv"* ]]; then
		echo -e "MPV "
	else
		echo ""
	fi
}

case "$1" in
--title)
	title=$(get_metadata "xesam:title")
	if [ -n "$title" ]; then
		echo "${title:0:28}"
	fi
	;;
--arturl)
	url=$(get_metadata "mpris:artUrl")
	if [ -n "$url" ]; then
		echo "${url#file://}"
	fi
	;;
--artist)
	artist=$(get_metadata "xesam:artist")
	if [ -n "$artist" ]; then
		echo "${artist:0:30}"
	fi
	;;
--length)
	length=$(get_metadata "mpris:length")
	if [ -n "$length" ]; then
		echo "$(($length / 1000000 / 60))m"
	fi
	;;
--status)
	status=$(playerctl status 2>/dev/null)
	if [[ $status == "Playing" ]]; then
		echo "󰎆"
	elif [[ $status == "Paused" ]]; then
		echo "󱑽"
	fi
	;;
--album)
	album=$(get_metadata "xesam:album")
	if [[ -n "$album" ]]; then
		echo "$album"
	else
		if [[ -n $(playerctl status 2>/dev/null) ]]; then
			echo "No album"
		fi
	fi
	;;
--source)
	get_source_info
	;;
*)
	echo "Invalid option: $1"
	exit 1
	;;
esac
