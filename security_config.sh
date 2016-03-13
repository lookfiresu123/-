# 密码安全
echo "password required pam_pwquality.so retry=3" >> /etc/pam.d/passwd
# 要求新密码的最小长度为8字符
echo "minlen = 8" >> /etc/security/pwquality.conf 
# 要求新密码的最少类种类为4种
echo "minclass = 4" >> /etc/security/pwquality.conf

# 指定密码的生命周期
# echo "chage -m 90 root"
# echo "chage -m 180 root"

# 账户锁定
echo "auth required pam_faillock.so preauth silent audit deny=3 even_deny_root unlock_time=600" >> /etc/pam.d/system-auth
echo "auth [default=die] pam_faillock.so authfail audit deny=3 unlock_time=600 deny=3 even_deny_root unlock_time=600" >> /etc/pam.d/password-auth
echo "account required pam_faillock.so" >> /etc/pam.d/system-auth
echo "account required pam_faillock.so" >> /etc/pam.d/password-auth
ln -sf /etc/pam.d/system-auth-local /etc/pam.d/system-auth
ln -sf /etc/pam.d/password-auth-local /etc/pam.d/password-auth

# 会话锁定
yum install vlock

# 只读挂载
cd /etc/udev/rules.d/
touch udev.rules
echo "SUBSYSTEM==\"block\",ATTRS{removable}==\"1\",RUN{program}=\"/sbin/blockdev --setro %N\"" >> udev.rules
cd ~

# 允许自动注销
yum install screen
sed -i '1itrap "" 1 2 3 15' /etc/profile
echo "SCREENEXEC=\"screen\"" >> /etc/profile
echo "if \[ -w \$\(tty\)  \]; then" >> /etc/profile
echo "trap \"exec \$SCREENEXEC\" 1 2 3 15" >> /etc/profile
echo "echo -n \'Starting session in 10 seconds\'" >> /etc/profile
echo "sleep 10" >> /etc/profile
echo "exec \$SCREENEXEC" >> /etc/profile
echo "fi" >> /etc/profile
echo "idle 120 quit autodetach off" >> /etc/screenrc

# 保护硬连接和软连接
echo "fs.protected_hardlinks = 1" >> /usr/lib/sysctl.d/50-default.conf

echo "fs.protected_symlinks = 1" >> /usr/lib/sysctl.d/50-default.conf

# 强化rpcbind的安全性
yum install firewalld

# 强化FTP服务
yum install vsftpd
echo "banner_file=/etc/banners/ftp.msg" >> /etc/vsftpd/vsftpd.conf
echo "local_enable=NO" >> /etc/vsftpd/vsftpd.conf

# 强化Postfix服务
echo "net_interfaces = localhost" >> /etc/postfix/main.cf
echo "yum install dovecot" >> /etc/postfix/main.cf

# 安全网络服务
echo "in.telnetd : ALL : severity emerg" >> /etc/hosts.deny
yum install net-tools
yum install nmap
/sbin/sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.default.rp_filter=1

# 防火墙
yum install firewalld
yum install firewall-config
systemctl start firewalld
systemctl start firewalld
systemctl enable firewalld
systemctl enable firewalld

# 使用iptables
# echo "systemctl disable firewalld"
# echo "systemctl stop firewalld"
# echo "yum install iptables-service"
# echo "systemctl start iptables"
# echo "systemctl start ip6tables"
# echo "systemctl enable iptables"
# echo "systemctl enable ip6tables"

# 用DNSSEC强化DNS
yum install unbound
systemctl status unbound
systemctl start unbound
systemctl enable unbound
yum install dnssec-trigger
systemctl status dnssec-trigger
systemctl start dnssec-trigger
systemctl enable dnssec-trigger

# 强化VPNs
yum install libreswan
yum info libreswan
rm /etc/ipsec.d/*db
ipsec initnss
systemctl status ipsec
systemctl start ipsec
systemctl enable ipsec
ipsec newhostkey --configdir /etc/ipsec.d --output /etc/ipsec.d/www.example.com.secrets
ipsec showhostkey --left
ipsec newhostkey --configdir /etc/ipsec.d --output /etc/ipsec.d/www.example.com.secrets
ipsec showhostkey --right
echo "conn mysubnet" >> /etc/ipsec.d/my_site-to-site.conf
echo "    also=mytunnel" >> /etc/ipsec.d/my_site-to-site.conf
echo "    leftsubnet=192.0.1.0/24" >> /etc/ipsec.d/my_site-to-site.conf
echo "    rightsubnet=192.0.2.0/24" >> /etc/ipsec.d/my_site-to-site.conf
echo "conn mysubnet6" >> /etc/ipsec.d/my_site-to-site.conf
echo "    also=mytunnel" >> /etc/ipsec.d/my_site-to-site.conf
echo "    connaddrfamily=ipv6" >> /etc/ipsec.d/my_site-to-site.conf
echo "    leftsubnet=2001:db8:0:1::/64" >> /etc/ipsec.d/my_site-to-site.conf
echo "    rightsubnet=2001:db8:0:2::/64" >> /etc/ipsec.d/my_site-to-site.conf
echo "conn mytunnel" >> /etc/ipsec.d/my_site-to-site.conf
echo "    auto=start" >> /etc/ipsec.d/my_site-to-site.conf
echo "    leftid=@west.example.com" >> /etc/ipsec.d/my_site-to-site.conf
echo "    left=192.1.2.23" >> /etc/ipsec.d/my_site-to-site.conf
echo "    leftrsasigkey=0sAQOrlo+hOafUZDlCQmXFrje/oZm [...] W2n417C/4urYHQkCvuIQ==" >> /etc/ipsec.d/my_site-to-site.conf
echo "    rightid=@east.example.com" >> /etc/ipsec.d/my_site-to-site.conf
echo "    right=192.1.2.45" >> /etc/ipsec.d/my_site-to-site.conf
echo "    rightrsasigkey=0sAQO3fwC6nSSGgt64DWiYZzuHbc4 [...] D/v8t5YTQ==" >> /etc/ipsec.d/my_site-to-site.conf
echo "    authby=rsasig" >> /etc/ipsec.d/my_site-to-site.conf
ipsec auto --add mysubnet
ipsec auto --add mysubnet6
ipsec auto --add mytunnel
ipsec auto --up mysubnet
ipsec auto --up mysubnet6
ipsec auto --up mytunnel

# 使用openssl
# 列出所有公钥加密算法
# openssl list-public-key-algorithms
# 列出所有加密算法
# openssl list-cipher-algorithms
# 列出所有消息摘要算法
# openssl list-message-digest-algorithms
# 产生RSA私钥
# openssl genpkey -algorithm RSA -out privkey.pem
# 使用128位AES和"hello"口令创建RSA私钥
# openssl genpkey -algorithm RSA -out privkey.pem -aes-128-cbc -pass pass:hello
# 请求签名
# openssl req -new -key privkey.pem -out cert.csr
# 创建自签名
# openssl req -new -x509 -key privkey.pem -out selfcert.pem -days 366
# 验证签名（X.509）
# openssl verify cert1.pem cert2.pem
# id用于指定使用那个加密算法
# openssl pkeyutl -in plaintext -out cyphertext -inkey privkey.pem - engine id
# 对加密文件进行签名
# openssl pkeyutl -sign -in plaintext -out sigtext -inkey privkey.pem
# 验证签名文件
# openssl pkeyutl -verifyrecover -in sig -inkey key.pem
# 验证签名
# openssl pkeyutl -verify -in file -sigfile sig -inkey key.pem
# 使用aes-128-cbc算法加密明文
# openssl enc -aes-128-cbc -in plaintext -out plaintext.aes-128-cbc
# 解密密文
# openssl enc -aes-128-cbc -d -in plaintext.aes-128-cbc -out plaintext 
# 生成消息摘要
# openssl dgst algorithm -out filename -sign private-key
# 产生密码的哈希值
# 生成password的哈希值并保存在password-file中
# openssl passwd password -in password-file
# 产生随机数
# 使用随机种子seed-file产生随机数rand-file
# openssl rand -out rand-file -rand seed-file

# 安全审计
yum install audit
ervice auditd start
chkconfig auditd on
service auditd stop
service auditd status
# 配置审计规则的相关命令
# auditctl -w filepath -p wa -k key_name
# auditctl -a action,filter -S system_call -F field=value -k key_name
cp /etc/audit/audit.rules /etc/audit/audit.rules_backup
cp /usr/share/doc/audit-version/stig.rules /etc/audit/audit.rules

# 潜在侵害分析
yum install scap-workbench
yum install scap-security-guide
yum install openscap-scanner
yum install wget
wget http://www.redhat.com/security/data/oval/com.redhat.rhsa-all.xml
wget http://www.redhat.com/security/data/metrics/com.redhat.rhsa-all.xccdf.xml
oscap oval eval --results rhsa-results-oval.xml --report oval-report.html com.redhat.rhsa-all.xml

# federal标准和管理
yum install dracut-fips

# 执行seliux
./autoseconf.sh

# 执行pam
./ks.cfg

# 执行四级安全审计
./audit_start.sh
