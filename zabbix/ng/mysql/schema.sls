{% from "zabbix/ng/map.jinja" import zabbix with context %}

{% set dbhost = zabbix.server.config.get('DBHost', 'localhost') %}
{% set dbname = zabbix.server.config.get('DBName', 'zabbix') %}
{% set dbuser = zabbix.server.config.get('DBUser', 'zabbix') %}
{% set dbpass = zabbix.server.config.get('DBPassword', 'zabbix') %}
{% set schema = zabbix.server.get('dbschema', '/usr/share/doc/zabbix-server-mysql/create.sql.gz') %}

include:
  - mysql.client
  - zabbix.ng.mysql.config
  - zabbix.ng.server.install

zabbix_db_apply_schema:
  cmd.run:
    - name: /bin/zcat {{ schema }} | /usr/bin/mysql -h {{ dbhost }} -u {{ dbuser }} --password={{ dbpass }} {{ dbname }} && touch {{ schema }}.applied
    - unless: test -f {{ schema }}.applied
    - require:
      - sls: zabbix.ng.server.install
      - sls: mysql.client
      - sls: zabbix.ng.mysql.config
      - pkg: install_zcat

install_zcat:
  pkg.installed:
    - name: {{ zabbix.gzip }}

