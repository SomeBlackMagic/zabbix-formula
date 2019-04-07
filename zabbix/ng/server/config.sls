{% from "zabbix/ng/map.jinja" import zabbix with context %}
{% set tls_type = salt['pillar.get']('zabbix:ng:server:config:TLSConnect', False) %}
{% set tls_psk_file =  salt['pillar.get']('zabbix:ng:server:config:TLSPSKFile', False) %}
{% set tls_psk_string  =  salt['pillar.get']('zabbix:ng:server:config:TLSPSK', False) %}

include:
  - zabbix.ng.server.install

zabbix_server_config:
  file.managed:
    - name: {{ zabbix.server.config_path }}
    - source: salt://zabbix/ng/files/ini.jinja
    - user: {{ zabbix.user }}
    - group: {{ zabbix.group }}
    - mode: 644
    - template: jinja
    - defailts:
      config: {{ zabbix.server.config }}
    - reguire:
      - sls: zabbix.ng.server.install
    - watch_in:
      - service: install_zabbix_server

{% if tls_type and tls_psk_file and tls_psk_string %}
zabbix_server_psk_file:
  file.managed:
    - name: {{ tls_psk_file }}
    - user: {{ zabbix.user }}
    - group: {{ zabbix.group }}
    - mode: 600
    - contents: {{ tls_psk_string }}
    - reguire:
      - sls: zabbix.ng.server.install
    - watch_in:
      - watch_in: install_zabbix_server
{% endif %}

# make include config directory
{% if 'Include' in zabbix.server.config %}
{% for key, value in zabbix.server.config.iteritems() %}
{% if key == 'Include' %}
{{ value }}:
  file.directory:
    - name: {{ value }}
    - user: {{ zabbix.user }}
    - group: {{ zabbix.group }}
    - mode: 755
    - watch_in:
      - service: install_zabbix_server
{% endif %}
{% endfor %}
{% endif %}
