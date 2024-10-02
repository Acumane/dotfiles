#!/bin/bash
exec &> /dev/null

if [ "$1" = "-k" ]; then
    pgrep -x wf-osk > /dev/null && pkill wf-osk
else
    pgrep -x wf-osk > /dev/null || wf-osk -a pinned -b 0 &
fi
