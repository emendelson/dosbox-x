#!/bin/bash

if [ $# -eq 0 ]; then
    >&2 echo "Usage: ChangePrinterTimeout.sh <seconds for printer timeout>"
    exit 1
fi

cd "$(dirname "$0")"

TIMEOUT="$1"

# sed -i '' "s/.*for ((n.*/for ((n=0;n<"$TIMEOUT";n++)); do/" pclprint.sh
# sed -i '' "s/.*for ((n.*/for ((n=0;n<"$TIMEOUT";n++)); do/" psprint.sh
# sed -i '' "s/.*for ((n.*/for ((n=0;n<"$TIMEOUT";n++)); do/" textprint.sh

sed -i '' "s/.*repeat with j from 1.*/\t\t\trepeat with j from 1 to "$TIMEOUT" /" selectprint.sh

