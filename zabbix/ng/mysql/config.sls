{% from "zabbix/ng/map.jinja" import zabbix with context %}

{% set dbhost = zabbix.server.config.get('DBHost', 'localhost') %}
{% set dbname = zabbix.server.config.get('DBName', 'zabbix') %}
{% set dbuser = zabbix.server.config.get('DBUser', 'zabbix') %}
{% set dbpass = zabbix.server.config.get('DBPassword', 'zabbix') %}
{% set scheme = zabbix.server.get('dbscheme', '/usr/share/doc/zabbix-server-mysql/create.sql.gz') %}

{% set dbroot_user = zabbix.server.get('dbroot_user') %}
{% set dbroot_pass = zabbix.server.get('dbroot_pass') %}
{% set dbuser_host = zabbix.server.get('dbuser_host', 'localhost') -%}

include:
  - mysql.server

zabbix_db:
  mysql_database.present:
    - name: {{ dbname }}
    - host: {{ dbhost }}
    {%- if dbroot_user and dbroot_pass %}
    - connection_host: {{ dbhost }}
    - connection_user: {{ dbroot_user }}
    - connection_pass: {{ dbroot_pass }}
    {%- endif %}
    - character_set: utf8
    - collate: utf8_bin
    - require:
      - sls: mysql.server
  mysql_user.present:
    - name: {{ dbuser }}
    - host: '{{ dbuser_host }}'
    - password: {{ dbpass }}
    {%- if dbroot_user and dbroot_pass %}
    - connection_host: {{ dbhost }}
    - connection_user: {{ dbroot_user }}
    - connection_pass: {{ dbroot_pass }}
    {%- endif %}
    - require:
      - mysql_database: zabbix_db
  mysql_grants.present:
    - grant: all privileges
    - database: {{ dbname }}.*
    - user: {{ dbuser }}
    - host: '{{ dbuser_host }}'
    {%- if dbroot_user and dbroot_pass %}
    - connection_host: {{ dbhost }}
    - connection_user: {{ dbroot_user }}
    - connection_pass: {{ dbroot_pass }}
    {%- endif %}
    - require:
      - mysql_database: zabbix_db
      - mysql_user: zabbix_db


