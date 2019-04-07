{% from "zabbix/ng/map.jinja" import zabbix with context %}

include:
  - zabbix.ng.frontend.install
  - zabbix.ng.mysql.schema
  - php.ng.fpm

zabbix_frontend_config:
  file.managed:
    - name: {{ zabbix.frontend.config_path }}
    - source: salt://zabbix/ng/files/zabbix.conf.php.jinja
    - template: jinja
    - require:
      - pkg: {{ zabbix.frontend.pkg }}
      - file: /etc/zabbix/web
      - sls: zabbix.ng.mysql.schema
    - reguire_in:
      - sls: php.ng.fpm

# Fix permissions to allow to php-fpm include /etc/zabbix/web/*
/etc/zabbix/web:
  file.directory:
    - mode: 755
    - require:
      - pkg: {{ zabbix.frontend.pkg }}
    - reguire_in:
      - sls: php.ng.fpm

