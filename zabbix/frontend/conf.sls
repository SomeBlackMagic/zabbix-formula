{% from "zabbix/map.jinja" import zabbix with context -%}
{% from "zabbix/macros.jinja" import files_switch with context -%}
{% set config_file = salt.file.basename(zabbix.frontend.config) -%}
{% set config_file_dir = salt.file.dirname(zabbix.frontend.config) -%}

{% set settings = salt['pillar.get']('zabbix-frontend', {}) -%}
{% set defaults = zabbix.get('frontend', {}) -%}


include:
  - zabbix.frontend


configure_zabbix:
  file.managed:
    - name: {{ zabbix.frontend.config }}
    - source: {{ files_switch('zabbix',
      [
        zabbix.frontend.config,
        zabbix.frontend.config ~ '.jinja',
        '/etc/zabbix/web/' ~ config_file,
        '/etc/zabbix/web/' ~ config_file ~ '.jinja'
      ]) }}
    - template: jinja
    - require:
      - pkg: zabbix-frontend-php
      - file: {{ config_file_dir }}

apche2_change_port:
  file.replace:
    - name: /etc/apache2/ports.conf
    - pattern: '^Listen .*$'
    - repl: 'Listen {{ settings.get('web_port', defaults.web_port) }}'

# Fix permissions to allow to php-fpm include zabbix frontend config file which is usually located under /etc/zabbix
{{ config_file_dir }}:
  file.directory:
    - mode: 755
    - require:
      - pkg: zabbix-frontend-php


{% if salt['grains.get']('os_family') == 'Debian' -%}
# We don't want the package to mess with apache
zabbix-frontend_debconf:
  debconf.set:
    - name: zabbix-frontend-php
    - data:
        'zabbix-frontend-php/configure-apache': {'type': 'boolean', 'value': False}
        'zabbix-frontend-php/restart-webserver': {'type': 'boolean', 'value': False}
    - prereq:
      - pkg: zabbix-frontend-php
{%- endif %}
