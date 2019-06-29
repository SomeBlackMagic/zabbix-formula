{% from "zabbix/map.jinja" import zabbix with context -%}
{% set settings = zabbix.get('proxy', {}) -%}

{% set sql_structure_file = settings.get('sql_structure_file') -%}
{% set db_path = settings.get('dbname') -%}

{% set is_db_exsist = False -%}
{% if salt['file.file_exists'](db_path) %}
{%  set is_db_exsist = True -%}
{% endif -%}

check_db_sqllite:
  test.configurable_test_state:
    - name: Is there any tables in '{{ db_path }}' database?
    - changes: True
    - result: True
    - comment: If changes is 'True' data import required.

create_db_folder:
  file.directory:
    - name: {{ settings.get('db_folder') }}
    - user: {{ zabbix.user }}
    - group: {{ zabbix.group }}
    - dirmode: 750
    - onchanges:
        - test: check_db_sqllite

import_sql:
  cmd.run:
    - name: zcat {{ sql_structure_file }} | sqlite3 {{ db_path }}
    - runas: {{ zabbix.user }}
#    - require:
#      - pkg: zabbix-proxy-sqlite3
    - onchanges:
      - test: check_db_sqllite
