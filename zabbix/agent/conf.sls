{% from "zabbix/map.jinja" import zabbix with context -%}
{% from "zabbix/macros.jinja" import files_switch with context -%}


include:
  - zabbix.agent


zabbix_agent_configure:
  file.managed:
    - name: {{ zabbix.agent.config }}
    - source: salt://zabbix/files/default/etc/zabbix/zabbix_agentd_4.2.conf.jinja
    - template: jinja
    - require:
      - pkg: zabbix-agent
    - watch_in:
      - module: zabbix-agent-restart
