# alarm in real time

#!/bin/sh

for file in `wc -l 2.txt`
do
    old=$file
    break;
done

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
    echo "newaudit=$newaudit,oldaudit=$oldaudit"
    tail -n +$oldaudit /var/log/audit/audit.log | ausearch -sv no >> 2.txt
    oldaudit=$[$newaudit+1]
    for file in `wc -l 2.txt`
    do
        new=$file
        break;
    done
    if [ $new != $old ];
    then
        echo "warning,new=$new,old=$old"
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" >> 2.txt
        echo `date` >> 2.txt
        echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" >> 2.txt
    fi
    for file in `wc -l 2.txt`
    do
        new=$file
        break;
    done
    old=$new
    echo -e "\n"
    sleep 10s
done
