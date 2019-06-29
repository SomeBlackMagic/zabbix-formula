include:
{% if (pillar['zabbix'] is defined) and (pillar['zabbix'] is not none) %}
  - zabbix.repo
{% endif %}

{% if (pillar['zabbix-mysql'] is defined) and (pillar['zabbix-mysql'] is not none) %}
  - zabbix.mysql.conf
  - zabbix.mysql.schema
{% endif %}

{% if (pillar['zabbix-server'] is defined) and (pillar['zabbix-server'] is not none) %}
  - zabbix.server.repo
  - zabbix.server.conf
{% endif %}

{% if (pillar['zabbix']['agent'] is defined) and (pillar['zabbix']['agent'] is not none) %}
  - zabbix.agent.repo
  - zabbix.agent.conf
  - zabbix.agent
{% endif %}

{% if (pillar['zabbix-frontend'] is defined) and (pillar['zabbix-frontend'] is not none) %}
  - zabbix.frontend.conf
  - zabbix.frontend.repo
{% endif %}

{% if (pillar['zabbix-proxy'] is defined) and (pillar['zabbix-proxy'] is not none) %}
  - zabbix.proxy
  - zabbix.proxy.repo
  - zabbix.proxy.conf
  - zabbix.proxy.schema
{% endif %}
