#!/bin/bash
while true
do
for var in `cat /root/black`
    do
        for pid in `ps -A | grep $var | awk '{print $1}'`
            do
                kill -9 $pid
            done
    done
done
exit
