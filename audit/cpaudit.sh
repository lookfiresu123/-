#!/bin/sh

for file in `wc -l /var/log/audit/audit.log`
do
    oldaudit=$file
    break;
done

while true
do
    for file in `wc -l /var/log/audit/audit.log`
    do
        newaudit=$file
        break;
    done
    if [ $newaudit != $oldaudit  ];
    then
        cp /var/log/audit/audit.log ~/save.log
    fi
    sleep 3600s
done
