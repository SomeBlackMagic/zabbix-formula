{% from "zabbix/ng/map.jinja" import zabbix with context %}

include:
  - zabbix.ng.repo
{% if zabbix.frontend.use_nginx %}
  - nginx.ng.pkg
  - nginx.ng.servers

disable_{{ zabbix.apache }}:
  service.dead:
    - name: {{ zabbix.apache }}
    - enable: False
{% endif %}

install_zabbix_frontend:
  pkg.installed:
    - name: {{ zabbix.frontend.pkg }}
    - require:
      - sls: zabbix.ng.repo




