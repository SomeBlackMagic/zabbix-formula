{% from "zabbix/ng/map.jinja" import zabbix with context %}

{% set dbhost = zabbix.server.config.get('DBHost', 'localhost') %}
{% set dbname = zabbix.server.config.get('DBName', 'zabbix') %}
{% set dbuser = zabbix.server.config.get('DBUser', 'zabbix') %}
{% set dbpass = zabbix.server.config.get('DBPassword', 'zabbix') %}
{% set scheme = zabbix.server.get('dbscheme', '/usr/share/doc/zabbix-server-mysql/create.sql.gz') %}

include:
  - mysql.client
  - zabbix.ng.mysql.config
  - zabbix.ng.server.install

zabbix_db_apply_scheme:
  cmd.run:
    - name: /bin/zcat {{ scheme }} | /usr/bin/mysql -h {{ dbhost }} -u {{ dbuser }} --password={{ dbpass }} {{ dbname }} && touch {{ scheme }}.applied
    - unless: test -f {{ scheme }}.applied
    - require:
      - sls: zabbix.ng.server.install
      - sls: mysql.client
      - sls: zabbix.ng.mysql.config



