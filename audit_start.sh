cd /etc/audit/rules.d

#自主访问控制
echo "-a exit,always -S setxattr -F key=setxattr_or_chcon" >> audit.rules
echo "-a exit,always -S getxattr -F key=getxattr_or_chcon" >> audit.rules
echo "-a exit,always -S chmod -F key=chmod" >> audit.rules
#主体对自主访问客体操作结果的审计
# echo "-a exit,always -S open -F path=... -F key=access_test" >> audit.rules

#主体对客体标记、类型、完整性控制的审计
echo "-a exit,always -S setxattr -F key=setxattr_or_chcon" >> audit.rules
echo "-a exit,always -S getxattr -F key=getxattr_or_chcon" >> audit.rules

#安全事件选择
# echo "-a exit,always -S 相应的系统调用号 -F path=要保护客体的绝对路径名 -F key=自己设置关键字" >> audit.rules

#受保护的审计踪迹存储
echo "-a entry,always -S open -S write -S read -F path=/var/log/audit/audit.log -F key=change_auditor" >> audit.rules

#在audit.rules中加入对该受保护客体的auditctl规则：
#客体为文件：echo "–a exit,always –S all –F 相应的客体文件名" >> audit.rules
#客体为系统调用：echo "–a exit,always –S 相应的系统调用号" >> audit.rules
#客体为进程：echo "-a entry,always -S all -F pid=相应的进程号" >> audit.rules
#客体为用户：echo "-a exit,always -S all -F uid=相应的用户id" >> audit.rules

#为程序分配设置用户id
echo "-a exit,always -S chown -F key=chown" >> audit.rules
echo "-a exit,always -S lchown -F key=lchown" >> audit.rules
echo "-a exit,always -S fchown -F key=fchown" >> audit.rules
echo "-a exit,always -S fchownat -F key=fchownat" >> audit.rules

#改变日期和时间
echo "-a exit,always -S settimeofday -F key=settimeofday" >> audit.rules
echo "-a exit,always -S stime -F key=stime" >> audit.rules
echo "-a exit,always -S clock_settime -F key=clock_settime" >> audit.rules

#将某个客体引入某个用户的地址空间
# echo "-w 客体的绝对路径名 -p rwxa -k 关键字" >> audit.rules

#删除客体
echo "-a exit,always -S kill -F key=kill" >> audit.rules

#基于身份鉴别或客体属性的用户的审计活动
#echo "-a exit,always -S 系统调用号 -F uid=用户id" >> audit.rules

#实时报警:2.sh; 审计数据可用性确保:cpaudit.sh; 黑名单:total.sh
#echo "yum install git"
#echo "git clone https://github.com/lookfiresu123/four-level.git"
cd /home/root
mkdir four-level
cd four-level
mkdir audit
cd /home/root/four-level/audit

touch 2.txt black
touch 2.sh total.sh cpaudit.sh
chmod a+x 2.sh total.sh cpaudit.sh
echo "tail" >> black

#清空2.sh和black
echo "> total.sh"
echo "> 2.sh"
echo "> cpaudit.sh"

#填充2.sh
echo "# alarm in real time" >> 2.sh
echo "#!/bin/sh" >> 2.sh
echo "for file in \`wc -l 2.txt\`" >> 2.sh
echo "do" >> 2.sh
echo "    old=\$file" >> 2.sh
echo "    break;" >> 2.sh
echo "done" >> 2.sh
echo "for file in \`wc -l /war/log/audit/audit.log\`" >> 2.sh
echo "do" >> 2.sh
echo "    oldaudit=\$file" >> 2.sh
echo "    break;" >> 2.sh
echo "done" >> 2.sh
echo "while true" >> 2.sh
echo "do" >> 2.sh
echo "    for file in \`wc -l /var/log/audit/audit.log\`" >> 2.sh
echo "    do" >> 2.sh
echo "        newaudit=\$file" >> 2.sh
echo "        break;" >> 2.sh
echo "    done" >> 2.sh
echo "    echo \"newaudit=\$newaudit,oldaudit=\$oldaudit\"" >> 2.sh
echo "    tail -n +\$oldaudit /var/log/audit/audit.log | ausearch -sv no >> 2.txt" >> 2.sh
echo "    oldaudit=\$[\$newaudit+1]" >> 2.sh
echo "    for file in \`wc -l 2.txt\`" >> 2.sh
echo "    do" >> 2.sh
echo "        new=\$file" >> 2.sh
echo "        break;" >> 2.sh
echo "    done" >> 2.sh
echo "    if [ \$new != \$old ];" >> 2.sh
echo "    then" >> 2.sh
echo "        echo \"warning,new=\$new,old=\$old\"" >> 2.sh
echo "        echo \">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\" >> 2.txt" >> 2.sh
echo "        echo \`date\` >> 2.txt" >> 2.sh
echo "        echo \"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\" >> 2.txt" >> 2.sh
echo "        \`zenity --notification --text=warning\`" >> 2.sh
echo "    fi" >> 2.sh
echo "    for file in \`wc -l 2.txt\`" >> 2.sh
echo "    do" >> 2.sh
echo "        new=\$file" >> 2.sh
echo "        break;" >> 2.sh
echo "    done" >> 2.sh
echo "    old=\$new" >> 2.sh
echo "    echo -e \"\n\"" >> 2.sh
echo "    sleep 30s" >> 2.sh
echo " done" >> 2.sh

#填充cpaudit.sh
echo "#!/bin/sh" >> cpaudit.sh
echo "for file in \`wc -l /var/log/audit/audit.log\`" >> cpaudit.sh
echo "do" >> cpaudit.sh
echo "    oldaudit=\$file" >> cpaudit.sh
echo "    break;" >> cpaudit.sh
echo "done" >> cpaudit.sh
echo "while true" >> cpaudit.sh
echo "do" >> cpaudit.sh
echo "    for file in \`wc -l /var/log/audit/audit.log\`" >> cpaudit.sh
echo "    do" >> cpaudit.sh
echo "        newaudit=\$file" >> cpaudit.sh
echo "        break;" >> cpaudit.sh
echo "    done" >> cpaudit.sh
echo "    if [ \$newaudit != \$oldaudit  ];" >> cpaudit.sh
echo "    then" >> cpaudit.sh
echo "        cp /var/log/audit/audit.log ~/save.log" >> cpaudit.sh
echo "    fi" >> cpaudit.sh
echo "    sleep 3600s" >> cpaudit.sh
echo "done" >> cpaudit.sh

#填充total.sh
echo "#!/bin/bash" >> total.sh
echo "while true" >> total.sh
echo "do" >> total.sh
echo "for var in \`cat /root/black\`" >> total.sh
echo "    do" >> total.sh
echo "        for pid in \`ps -A | grep \$var | awk '{print \$1}'\`" >> total.sh
echo "            do" >> total.sh
echo "                kill -9 \$pid" >> total.sh
echo "            done" >> total.sh
echo "    done" >> total.sh
echo "done" >> total.sh
echo "exit" >> total.sh

./2.sh & ./cpaudit.sh & ./total.sh
