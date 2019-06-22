include:
{% if (pillar['zabbix'] is defined) and (pillar['zabbix'] is not none) %}
  - zabbix.repo
{% endif %}

{% if (pillar['zabbix-server'] is defined) and (pillar['zabbix-server'] is not none) %}
  - zabbix.server.repo
  - zabbix.server.conf
{% endif %}

{% if (pillar['zabbix-agent'] is defined) and (pillar['zabbix-agent'] is not none) %}
  - zabbix.agent
{% endif %}

{% if (pillar['zabbix-frontend'] is defined) and (pillar['zabbix-frontend'] is not none) %}
  - zabbix.frontend.conf
  - zabbix.frontend.repo
{% endif %}

{% if (pillar['zabbix-mysql'] is defined) and (pillar['zabbix-mysql'] is not none) %}
  - zabbix.mysql.conf
  - zabbix.mysql.schema
{% endif %}
