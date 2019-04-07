{% from "zabbix/ng/map.jinja" import zabbix with context %}
{% set osfamily = salt['grains.get']('os_family', False) %}


{% if osfamily == 'Debian' %}
{% set codename = salt['grains.get']('lsb_distrib_codename') %}

install_zabbix_repo_for_{{ codename }}:
  pkgrepo.managed:
    - name: deb http://repo.zabbix.com/zabbix/{{ zabbix.repo_version }}/{{ osfamily|lower }} {{ codename }} main
    - file: /etc/apt/sources.list.d/zabbix.list
    - key_url: https://repo.zabbix.com/zabbix-official-repo.key

{% endif %}




