#!/bin/bash


cd "$(dirname "$0")"

osascript ./psselect.scpt "$1"

exit 0
