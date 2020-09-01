#!/bin/bash

layout=$(xkb-switch)

if [[ $layout = "us" ]]; then
	echo "🇺🇸"
elif [[ $layout = "ir" ]]; then
	echo "🇮🇷"
else
	echo "UNK"
fi
