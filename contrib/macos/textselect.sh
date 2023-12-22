#!/bin/bash


cd "$(dirname "$0")"

osascript ./textselect.scpt "$1"

exit 0
