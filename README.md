# What you need to do:

Clone repo to your ansible roles dir. Repo is ready to include to your own ansible playbooks as submodule.

```
cd $your_ansible_dir_with_roles
mkdir teleport && cd teleport
git clone https://github.com/gnom4ik/ansible_teleport.git .
```

## teleport inventory

```
[all]
teleport-server					ansible_connection=ssh		ansible_host=change_me
mysql-server					ansible_connection=ssh		ansible_host=change_me
mongodb-server					ansible_connection=ssh		ansible_host=change_me
postgresql-server				ansible_connection=ssh		ansible_host=change_me


[teleport-group:children]

mongodb
postgresql
mysql
teleport-server

[teleport-server]

teleport-server

[mongodb]

mongodb-server

[mysql]

mysql-server

[postgresql]

postgresql-server
```

## teleport group vars

```
# Common values
teleport_version: 13.3.1
teleport_config_path: "/etc"
teleport_token_path: "/var/lib/teleport/tmp"
teleport_server_cert_dir: "/var/lib/teleport/certificates"
teleport_server_domain: your.domain.name
teleport_server_port: 443

# PostgreSQL values
teleport_postgresql_cert_name: "psql"
teleport_postgresql_cert_ttl: 8760h
teleport_postgresql_cert_dir: "/etc/postgresql/teleport_certs"
teleport_postgresql_port: 5432

# MongoDB values
teleport_mongodb_cert_name: "mongodb"
teleport_mongodb_cert_ttl: 8760h
teleport_mongodb_cert_dir: "/var/lib/mongodb_tls"
teleport_mongodb_port: 27017

# MySQL values
teleport_mysql_cert_name: "mysql"
teleport_mysql_cert_ttl: 8760h
teleport_mysql_cert_dir: "/etc/mysql/teleport_cert"
teleport_mysql_port: 3306


```

## teleport server host vars

```
teleport_labels:
  product: teleport
  env: test
  zone: test
  type: test
```

## teleport database host vars

You can change all labels as you wish.

```
teleport_labels:
  type: mysql
  zone: test
  env: test
  product: test
```

## teleport simple playbook

```
---
- name: Install teleport
  hosts: teleport-group
  become: yes
  roles:
    - teleport
```
