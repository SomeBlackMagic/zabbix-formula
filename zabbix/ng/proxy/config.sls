{% from "zabbix/ng/map.jinja" import zabbix with context %}
{% set tls_type = salt['pillar.get']('zabbix:ng:proxy:config:TLSConnect', False) %}
{% set tls_psk_file =  salt['pillar.get']('zabbix:ng:proxy:config:TLSPSKFile', False) %}
{% set tls_psk_string  =  salt['pillar.get']('zabbix:ng:proxy:config:TLSPSK', False) %}

include:
  - zabbix.ng.proxy.install

zabbix_proxy_config:
  file.managed:
    - name: {{ zabbix.proxy.config_path }}
    - source: salt://zabbix/ng/files/ini.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defailts:
      config: {{ zabbix.proxy.config }}
    - reguire:
      - sls: zabbix.ng.proxy.install
    - watch_in:
      - service: install_zabbix_proxy

zabbix_proxy_db_file_dir:
  file.directory:
    - name: {{ zabbix.proxy.config.DBDir }}
    - user: {{ zabbix.user }}
    - group: {{ zabbix.group }}
    - mode: 755
    - makedirs: True
    - watch_in:
      - service: install_zabbix_proxy
    - reguire_in:
      - service: install_zabbix_proxy
      
{% if tls_type and tls_psk_file and tls_psk_string %}
zabbix_proxy_psk_file:
  file.managed:
    - name: {{ tls_psk_file }}
    - user: {{ zabbix.user }}
    - group: {{ zabbix.group }}
    - mode: 644
    - contents: {{ tls_psk_string }}
    - reguire:
      - sls: zabbix.ng.proxy.install
    - watch_in:
      - service: install_zabbix_proxy
{% endif %}
