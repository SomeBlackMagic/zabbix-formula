{% from "zabbix/ng/map.jinja" import zabbix with context %}
{% set tls_psk_file = salt['pillar.get']('zabbix:ng:server:config:TLSPSKFile', False) %}

include:
  - zabbix.ng.repo

install_zabbix_server:
  pkg.installed:
    - name: {{ zabbix.server.pkg }}
    - install_recommends: False
    - require:
      - sls: zabbix.ng.repo
  service.running:
    - name: {{ zabbix.server.service }}
    - enable: True
    - require:
      - pkg: install_zabbix_server
    - watch_any:
      - file: {{ zabbix.server.config_path }}
      {% if tls_psk_file %}
      - file: {{ tls_psk_file }}
      {% endif %}
