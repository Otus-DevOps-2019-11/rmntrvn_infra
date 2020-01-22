# rmntrvn_infra
rmntrvn Infra repository

## Домашняя работа "Знакомство с облачной инфраструктурой и облачными сервисами"

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

---

## Домашняя работа "Основные сервисы Google Cloud Platform (GCP)"

```
testapp_IP = 35.187.75.185
testapp_port = 9292
```

1. Установлена утилита gcloud на локальную машину и проинициализирована аккаунт.

2. Создан инстанс командой.
```
gcloud compute instances create reddit-app \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure
  ```

3. Созданые скрипты:
- [Установка Ruby](install_ruby.sh)
- [Установка MongoDB 3.2](install_mongod.sh)
- [Разворачивание приложения](deploy.sh)
- [Скрипт автоматизации предыдущих скриптов](startup_script.sh)

4. Создание инстанса с использованием скрипта [startup_script.sh](startup_script.sh)
```
gcloud compute instances create reddit-app \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --zone europe-west1-d \
  --metadata-from-file startup-script=startup_script.sh
```

Машина создана.
```
WARNING: You have selected a disk size of under [200GB]. This may result in poor I/O performance. For more information, see: https://developers.google.com/compute/docs/disks#performance.
Created [https://www.googleapis.com/compute/v1/projects/infra-263911/zones/europe-west1-d/instances/reddit-app].
NAME        ZONE            MACHINE_TYPE  PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP    STATUS
reddit-app  europe-west1-d  g1-small                   10.132.0.5   35.187.75.185  RUNNING
```

Проверим порт:
```
rmntrvn@reddit-app:~$ ps aux | grep puma
root      9501  0.2  1.5 513720 26872 ?        Sl   17:48   0:00 puma 3.10.0 (tcp://0.0.0.0:9292) [reddit]
rmntrvn   9565  0.0  0.0  12944   984 pts/1    S+   17:50   0:00 grep --color=auto puma
```

5. Создано правило
```
gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --target-tags 'puma-server' --source-ranges 0.0.0.0/0
```
Результат.
```
Creating firewall...done.
NAME                 NETWORK  DIRECTION  PRIORITY  ALLOW     DENY  DISABLED
default-puma-server  default  INGRESS    1000      tcp:9292        False
```

---

## Домашняя работа "Модели управления инфраструктурой Packer"

1. Создана ветка *packer-base*. Скрипты с предыдущего домашнего задания перенесены в директорию *config-scripts*.
2. Установлен *Packer*, для *gcloud* предоставлены доступы.
3. В директории *packer* создан шаблон [ubuntu16.json](packer/ubuntu16.json)
4. Собран образ командой.
```
packer build ubuntu16.json
```
5. Создаём виртуальную машину с использованием созданного образа reddit-base, проверяем подключение по ssh и разворачиваем приложение:
```
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
```
6. Проверяем работу приложения `<public_ip>:9292` и коммитим в созданную ветку.
7. Выполнено самостоятельное задание с параметризацией переменных.
8. Выполнено задание со (*) - создан файл [immutable.json](packer/immutable.json) для сборки образа.
9. Выполнено задание со (*) - создан файл [create-reddit-vm.sh](config-scripts/create-reddit-vm.sh) для автоматического создания виртуальной машины с использованием образа reddit-full через gcloud утилиту.

## Домашняя работа "Знакомство с Terraform"

0. Создана ветка *terraform-1*
1. Созданы файлы для сборки проекта:

| Файл | Описание |
|------------------------------------------------------|-------------------------------|
| [main.tf](./terraform/main.tf) | Основной файл терраформа |
| [lb.tf](./terraform/lb.tf) | Конфигурация балансировщика |
| [outputs.tf](./terraform/outputs.tf) | Выходная переменная IP адреса |
| [terraform.tfvars](./terraform/terraform.tfvars) | Файл значений переменных |
| [terraform.tfvars.example](terraform/tfvars.example) | Файл примера переменных |
| [variables.tf](./terraform/variables.tf) | Файл переменных |

2. Чтобы запустить проект необходимо выполнить следующую команду.
```
terraform init && terraform apply
```
Файл переменных необходимо переименовать в *terraform.tfvars* или запустить запуск проекта с опцией `-var-file="terraform.tfvars.example"`.
3. Проверить подключение возможно по IP адресу, который будет выведен на экран после запуска инфраструктуры.

## Домашняя работа "Принципы организации инфраструктурного кода и работа над инфраструктурой в команде на примере Terraform"

0. Создана ветка *terraform-2*.
1. Созданы образы на основе файлов *app.json* и *db.json*.
2. Созданы конфигурационные файлы для создания виртуальных машин на основе созданных образов.
3. Конфигурация проект расщеплена на модули - *app*, *db* и *vpc*, каждый их которых выполняет свою роль в сборке проекта.
4. Созданы директории *stage* и *prod*.
5. Создан реестр модулей.

```
Outputs:

storage-bucket_url = gs://storage-bucket-rmntrvn1337

$ gsutil mb gs://storage-bucket-rmntrvn1337
Creating gs://storage-bucket-rmntrvn1337/...
ServiceException: 409 Bucket storage-bucket-rmntrvn1337 already exists.
```
6. (*) Выполнено задание хранение *state*-файла в удаленном бекенде для *prod* и *stage* проектов.
7. (**) Выполнено задание с добавление *provisioner* в модули.

## Домашняя работа "Управление конфигурацией. Знакомство с Ansible"

0. Создана ветка *ansible-1*.
1. Установлен *ansible*.
2. Создан [inventory](./ansible/inventory)-файл в формете INI с указанием хостов, поднятых в GCP.
3. Проверена работа *ansible* для управления хостами.
4. Создан файл [ansible.cfg](./ansible/ansible.cfg) для указания статических данных для хостов.
5. Создан файл [inventory.yml](./ansible/inventory.yml) с формет YAML.
6. Проверена работа модулей *command* и *shell*.
7. Клонирован репозиторий приложения используя *ansible*. При повторном выполнении задачи клонирования с использованием файл [clone.yml](./ansible/clone.yml) видим, что файл применен, но конфигурация на сервере не изменена, т.к. файлы одинаковые.
```
$ ansible-playbook clone.yml

PLAY [Clone] *************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 16.04 on host appserver should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior
Ansible releases. A future Ansible release will default to using the discovered platform python for this host. See
https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation
warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [appserver]

TASK [Clone repo] ********************************************************************************************************************************************************
ok: [appserver]

PLAY RECAP ***************************************************************************************************************************************************************
appserver                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
8. При выполнении команды `ansible app -m command -a 'rm -rf ~/reddit'` и повторном выполнении плейбука наблюдаем, что были приняты изменения, выполнямые в плейбуке.
```
$ ansible app -m command -a 'rm -rf ~/reddit'
[WARNING]: Consider using the file module with state=absent rather than running 'rm'.  If you need to use command because file is insufficient you can add 'warn: false'
to this command task or set 'command_warnings=False' in ansible.cfg to get rid of this message.

[DEPRECATION WARNING]: Distribution Ubuntu 16.04 on host appserver should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior
Ansible releases. A future Ansible release will default to using the discovered platform python for this host. See
https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation
warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
appserver | CHANGED | rc=0 >>


$ ansible-playbook clone.yml

PLAY [Clone] *************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 16.04 on host appserver should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior
Ansible releases. A future Ansible release will default to using the discovered platform python for this host. See
https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation
warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [appserver]

TASK [Clone repo] ********************************************************************************************************************************************************
changed: [appserver]

PLAY RECAP ***************************************************************************************************************************************************************
appserver                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

9. (*) Конвертирован файл (inventory.yml)[./inventory.yml] в (inventory.json)[./inventory.json].
 - Получена статическая конфигурация json файла инвентаризации.
 - Написан скрипт [get_dyn_inventory.sh](./ansible/get_dyn_inventory.sh) для динамического получения данных о хостах.
 - Проверена работы скрипта.
 ```
 $ ansible all -i create_dyn_inventory.sh -m ping
[DEPRECATION WARNING]: Distribution Ubuntu 16.04 on host 104.199.43.190 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior
Ansible releases. A future Ansible release will default to using the discovered platform python for this host. See
https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation
warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
104.199.43.190 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
[DEPRECATION WARNING]: Distribution Ubuntu 16.04 on host 34.76.35.235 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior
Ansible releases. A future Ansible release will default to using the discovered platform python for this host. See
https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation
warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
34.76.35.235 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
 ```

---

## Домашняя работа "Продолжение знакомства с Ansible: templates, handlers, dynamic inventory, vault, tags"

0. Создана ветка *ansible-2*.
1. В результате всех действий созданы плейбуки *app.yml*, *db.yml*, *deploy.yml*, которые импортированы и запускаются из *site.yml*, на основе собранных образов *packer*.
2. Образы необходимо собрать командой в корне репозитория:
Для DB ноды:
```
packer build -var-file=packer/variables.json packer/db.json
```
Для APP ноды:
```
packer build -var-file=packer/variables.json packer/app.json
```
3. Для проверкии выполнить:
```
cd terraform/stage && terraform apply -auto-approve=false
```
В результате чего будут созданы 2 ноды. Полученный в результате IP (*db_external_ip*) для DB ноды нужно указать в файле *app.yml* для переменной *db_host*.
Далее необходимо выполнить следующую команду.
```
cd ansible/ && ansible-playbook site.yml
```
После чего перейти по URL `<app_external_ip>:9292`.
