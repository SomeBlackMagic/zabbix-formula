{% from "zabbix/ng/map.jinja" import zabbix with context %}
{% set tls_type = salt['pillar.get']('zabbix:ng:agent:config:TLSConnect', False) %}
{% set tls_psk_file =  salt['pillar.get']('zabbix:ng:agent:config:TLSPSKFile', False) %}
{% set tls_psk_string  =  salt['pillar.get']('zabbix:ng:agent:config:TLSPSK', False) %}

include:
  - zabbix.ng.agent.install

zabbix_agent_config:
  file.managed:
    - name: {{ zabbix.agent.config_path }}
    - source: salt://zabbix/ng/files/ini.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defailts:
      config: {{ zabbix.agent.config }}
    - reguire:
      - sls: zabbix.ng.agent.install
    - watch_in:
      - service: install_zabbix_agent

{% if tls_type and tls_psk_file and tls_psk_string %}
zabbix_agent_psk_file:
  file.managed:
    - name: {{ tls_psk_file }}
    - user: {{ zabbix.user }}
    - group: {{ zabbix.group }}
    - mode: 600
    - contents: {{ tls_psk_string }}
    - reguire:
      - sls: zabbix.ng.agent.install
    - watch_in:
      - service: install_zabbix_agent
{% endif %}

# make include config directory
{% if 'Include' in zabbix.agent.config %}
{% for key, value in zabbix.agent.config.iteritems() %}
{% if key == 'Include' %}
{{ value }}:
  file.directory:
    - name: {{ value }}
    - user: {{ zabbix.user }}
    - group: {{ zabbix.group }}
    - mode: 755
    - watch_in:
      - service: install_zabbix_agent
{% endif %}
{% endfor %}
{% endif %}
