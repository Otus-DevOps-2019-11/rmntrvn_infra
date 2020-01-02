# rmntrvn_infra
rmntrvn Infra repository

```
bastion_IP = 34.76.51.166
someinternalhost_IP = 10.132.0.4
```

0. Был сгенерирован и добавлен SSH ключ для автоматического проброса на виртуальные машины.
1. Созданы 2 хоста: *bastion* и *someinernalhost*.
2. Хост *basion* имеет внешний IP 34.76.51.166 и локальный IP 10.132.0.2.
3. Хост *someinternalhost* имеет только локальный IP 10.132.0.4.
4. Проверяем подключение по ssh к *bastion*
```sh
$ ssh -i ~/.ssh/id_rsa rmntrvn@34.76.51.166
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-1050-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

0 packages can be updated.
0 updates are security updates.



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

/usr/bin/xauth:  file /home/rmntrvn/.Xauthority does not exist
```

5. Проверяем подключение в *someinternalhost* с *bastion*.
```sh
rmntrvn@bastion:~$ ssh 10.132.0.4
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-1050-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


0 packages can be updated.
0 updates are security updates.


Last login: Thu Jan  2 12:31:19 2020 from 10.132.0.2
```

6. Добавлен приватный SSH-ключ для авторизации.
```sh
$ ssh-add ~/.ssh/id_rsa
Identity added: /home/rmntrvn/.ssh/id_rsa (/home/rmntrvn/.ssh/id_rsa)
```

7. Снова подключаемся к *bastion* с использованием ключа и SSH Agent Forwarding.
```sh
$ ssh -i ~/.ssh/id_rsa -A rmntrvn@34.76.51.166
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-1050-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


0 packages can be updated.
0 updates are security updates.

New release '18.04.3 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Thu Jan  2 12:15:31 2020 from 188.190.152.75
```
8. Проверяем подключение к *someintrnalhost*.
```
rmntrvn@bastion:~$ ssh 10.132.0.4
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-1050-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


0 packages can be updated.
0 updates are security updates.


Last login: Thu Jan  2 12:31:19 2020 from 10.132.0.2

rmntrvn@someinternalhost:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 42:01:0a:84:00:04 brd ff:ff:ff:ff:ff:ff
    inet 10.132.0.4/32 brd 10.132.0.4 scope global ens4
       valid_lft forever preferred_lft forever
    inet6 fe80::4001:aff:fe84:4/64 scope link
       valid_lft forever preferred_lft forever
```

9. Проверяем отсутствие ключей на *bastion*.
```sh
rmntrvn@bastion:~$ ls -la .ssh/
total 16
drwx------ 2 rmntrvn rmntrvn 4096 Jan  2 12:31 .
drwxr-xr-x 4 rmntrvn rmntrvn 4096 Jan  2 12:53 ..
-rw------- 1 rmntrvn rmntrvn  412 Jan  2 12:12 authorized_keys
-rw-r--r-- 1 rmntrvn rmntrvn  222 Jan  2 12:31 known_hosts
```

10. Чтобы подключиться к *someinternalhost* с локальной машины напрямую необходимо выполнить следующую команду.
```sh
$ ssh -i .ssh/id_rsa -J rmntrvn@34.76.51.166 rmntrvn@10.132.0.4
The authenticity of host '10.132.0.4 (<no hostip for proxy command>)' can't be established.
ECDSA key fingerprint is SHA256:5HVFzznC+zZ45kcH/FKGRtyrFPfEjmz7+hIDL412SOE.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '10.132.0.4' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-1050-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


0 packages can be updated.
0 updates are security updates.


Last login: Thu Jan  2 12:33:15 2020 from 10.132.0.2
/usr/bin/xauth:  file /home/rmntrvn/.Xauthority does not exist
rmntrvn@someinternalhost:~$
```

11. Для доступа к хосту *someinternalhost* по псевдониму с локальной машины создадим файл `.ssh/config` и внесем в него следующие данные:
```sh
# DevOps Course / JUMP TO INTERNAL HOST

Host bastion
	Hostname 34.76.51.166
	IdentityFile /home/rmntrvn/.ssh/id_rsa
	User rmntrvn
	Port 22

Host someinternalhost
	Hostname 10.132.0.4
	IdentityFile /home/rmntrvn/.ssh/id_rsa
	User rmntrvn
	Port 22
	ForwardAgent yes
	ProxyJump bastion
```

Проверка:
```sh
$ ssh someinternalhost
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-1050-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


0 packages can be updated.
0 updates are security updates.


Last login: Thu Jan  2 13:24:03 2020 from 10.132.0.2
```

12. В настройках ноды *bastion* разрешает трафик HTTP и HTTPS, в консоли *bastion* создаём скрипт и запускаем его.
```sh
rmntrvn@bastion:~$ cat setupvpn.sh
#!/bin/bash
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.4.list
echo "deb http://repo.pritunl.com/stable/apt xenial main" > /etc/apt/sources.list.d/pritunl.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 0C49F3730359A14518585931BC711F9BA15703C6
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get --assume-yes update
apt-get --assume-yes upgrade
apt-get --assume-yes install pritunl mongodb-org
systemctl start pritunl mongod
systemctl enable pritunl mongod
```
Запуск скрипта командой.
```sh
sudo bash setupvpn.sh
```

13. Переходим по URL https://34.76.51.166/setup и запускаем установку командой.
```sh
sudo pritunl setup-key
```

14. Вводим полученный ключ в поле браузера и нажимаем *Save*. После установки для получения доступов по-умолчанию вводим в консоли следующую команду.
```sh
sudo pritunl default-password
```

15. Заходим в веб-интерфейс, создаём организацию, пользователя и сервер. Привязываем организацию к пользователю. Запоминаем порт сервера. В моём случае UDP/11453.

16. Создано правило в настройках брандмауэра GCP для пропуска трафика со всех IP на UDP порт 11453.

17. Скачиваем в панели VPN файлы для подключения по VPN.
Импортируем файл в клиент OpenVPN и проверяем подключение к серверу *someinternalhost*.
```sh
$ ssh -i .ssh/id_rsa rmntrvn@10.132.0.4
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-1050-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


0 packages can be updated.
0 updates are security updates.


Last login: Thu Jan  2 14:24:44 2020 from 10.132.0.2
rmntrvn@someinternalhost:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 42:01:0a:84:00:04 brd ff:ff:ff:ff:ff:ff
    inet 10.132.0.4/32 brd 10.132.0.4 scope global ens4
       valid_lft forever preferred_lft forever
    inet6 fe80::4001:aff:fe84:4/64 scope link
       valid_lft forever preferred_lft forever
```
