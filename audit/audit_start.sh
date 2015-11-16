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
cd /home/root/four-level/audit
./2.sh & ./cpaudit.sh & ./total.sh
