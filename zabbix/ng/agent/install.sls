{% from "zabbix/ng/map.jinja" import zabbix with context %}

include:
  - zabbix.ng.repo

install_zabbix_agent:
  pkg.installed:
    - name: {{ zabbix.agent.pkg }}
    - require:
      - sls: zabbix.ng.repo

  service.running:
    - name: {{ zabbix.agent.service }}
    - enable: True
    - require:
      - pkg: install_zabbix_agent

