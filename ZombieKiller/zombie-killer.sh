#!/bin/bash

THRESHOLD=300   # 5 min. Change the value if necessary
WAITPID_OPT=11  # WNOHANG(0x1) | WUNTRACED(0x2) | WCONTINUED(0x8)

ppid=`ps -ef | grep parent_process_name | grep -v grep | awk '{print $2}'`

for zpid in `ps -ef | grep child_process_name | grep defunct | grep -v grep | awk '{print $2}'`
do
    TIME_START=`ps -o lstart --noheader -p $zpid`

    if [ -n "$TIME_START" ]; then
        TIME_START_SEC=`date +%s -d "$TIME_START"`
        TIME_NOW_SEC=`date +%s`
        TIME_DIFF_SEC=`expr $TIME_NOW_SEC - $TIME_START_SEC`
    else
        TIME_DIFF_SEC=1
    fi

    if [ $TIME_DIFF_SEC -gt $THRESHOLD ]; then
        gdb -p $ppid --batch-silent -ex "call waitpid($zpid, 0, $WAITPID_OPT)" -ex "detach"
    fi
done

