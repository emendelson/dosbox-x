#!/bin/bash


cd "$(dirname "$0")"

osascript ./pclselect.scpt "$1"

exit 0
