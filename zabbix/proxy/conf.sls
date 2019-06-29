{% from "zabbix/map.jinja" import zabbix with context -%}
{% from "zabbix/macros.jinja" import files_switch with context -%}


include:
  - zabbix.proxy


{{ zabbix.proxy.config }}:
  file.managed:
    - source: 'salt://zabbix/files/default/etc/zabbix/zabbix_proxy_4.2.conf.jinja'
    - template: jinja
    - require:
      - pkg: zabbix-proxy
    - watch_in:
      - service: zabbix-proxy
