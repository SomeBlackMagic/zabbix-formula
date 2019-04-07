{% from "zabbix/ng/map.jinja" import zabbix with context %}
{% set tls_psk_file = salt['pillar.get']('zabbix:ng:proxy:config:TLSPSKFile', False) %}

include:
  - zabbix.ng.repo

install_zabbix_proxy:
  pkg.installed:
     - name: {{ zabbix.proxy.pkg }}
     - require:
       - sls: zabbix.ng.repo
  service.running:
    - name: {{ zabbix.proxy.service }}
    - enable: True
    - require:
      - pkg: install_zabbix_proxy
    - watch_any:
      - file: {{ zabbix.proxy.config_path }}
      {% if tls_psk_file %}
      - file: {{ tls_psk_file }}
      {% endif %}


enable_autostart_zabbix_proxy:
  file.managed:
    - name: {{ zabbix.proxy.proxy_start_path }}
    - user: root
    - group: root
    - mode: 644
    - contents: 'START=yes'
    - require:
      - pkg: install_zabbix_proxy


