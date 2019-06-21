{% from "zabbix/map.jinja" import zabbix with context -%}

{% set settings = salt['pillar.get']('zabbix-mysql', {}) -%}
{% set defaults = zabbix.get('mysql', {}) -%}
# This required for backward compatibility
{% if 'dbpass' in settings -%}
  {%  do settings.update({'dbpassword': settings['dbpass']}) -%}
{% endif -%}

{% set dbhost = settings.get('dbhost', defaults.dbhost) -%}
{% set dbname = settings.get('dbname', defaults.dbname) -%}
{% set dbuser = settings.get('dbuser', defaults.dbuser) -%}
{% set dbpassword = settings.get('dbpassword', defaults.dbpassword) -%}

{% set schema = zabbix.server.get('dbschema', '/usr/share/doc/zabbix-server-mysql/create.sql.gz') %}

include:
  - zabbix.mysql.conf

zabbix_db_apply_schema:
  cmd.run:
    - name: /bin/zcat {{ schema }} | /usr/bin/mysql -h {{ dbhost }} -u {{ dbuser }} --password={{ dbpassword }} {{ dbname }} && touch {{ schema }}.applied
    - unless: test -f {{ schema }}.applied
    - require:
        - pkg: install_zcat

install_zcat:
  pkg.installed:
    - name: gzip
