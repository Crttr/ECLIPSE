#!/bin/sh

printf '\033]P0101018\033]P171394F\033]P5CF7894\033]PDA99BCF\033]P7DDD5E2\033]PFDDD5E2'

exec env LANG=C LC_ALL=C :ANGUAGE=en tuigreet \
	--time \
	--time-format '%d.%m.%Y | %H:%M' \
	--title \
	--custom-title 'ECLIPSE' \
	--greeting 'S Y S T E M   O N L I N E' \
	--remember \
	--asterisks \
	--width 60 \
	--container-padding 2 \
	--theme 'border=magenta;text=white;prompt=magenta;time=white;action=magenta;button=white;container=black;input=white' \
	--background doom \
	--doom-colors 'black,red,magneta' \
	--doom-height 4 \
	--doom-spread 2 \
	--background-fps 20 \
	--cmd 'uwsm start hyprland.desktop'
