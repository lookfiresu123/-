# kill the pid of dangerous process

#!/bin/sh

for file in `wc -l 1.txt`
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
    strA="pid="
    echo -e "\n"
    for file in `wc -l /var/log/audit/audit.log`
    do
        newaudit=$file
        break;
    done
    echo "newaudit=$newaudit,oldaudit=$oldaudit"
    tail -n +$oldaudit /var/log/audit/audit.log | ausearch -sv no > 1.txt
    oldaudit=$newaudit
    for file in `wc -l 1.txt`
    do
        new=$file
        break;
    done
    new=`expr $new / 3`
    if [ $new != $old ];
    then
        echo "warning,new=$new,old=$old"
        for line in `tail -n +$old 1.txt`
        do
            result=$(echo $line | grep "${strA}")
            if [[ "$result" != "" ]];
            then
                pid=${line#*=}
                echo $pid
                kill -TERM $pid
                break;
            fi
        done
    fi
    old=$new
    echo -e "\n"
    sleep 30s
done
