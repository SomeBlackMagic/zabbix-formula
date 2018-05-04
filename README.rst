==============
zabbix-formula
==============

A saltstack formula to manage Zabbix.

This formula has been developed distributing declarations in different files to
make it usable in most situations. It should be useful in scenarios ranging from
a simple install of the packages (without any special configuration) to a more
complex set-up with different nodes for agent, server, database and frontend.

Customization
=============

First, **see if providing pillar data is enough for your customization needs**.
That's the recommended way and should be enough for most cases. See that
sometimes there's a key named ``extra_conf`` that's used to add arbitrary
configuration lines in the templates provided.

When providing pillar data is not enough for your needs, you can apply the
Template Override and Files Switch (TOFS) pattern as described in the
documentation file ``TOFS_pattern.md``.

The formula is designed to be independent from other formulas so you could use
this in a non-100% salted environment (i.e. it's not required –although
recommended– to use other formulas to provision other parts of a complete
system).

Using RedHat EPEL repo Zabbix packages
======================================

If you want to use the EPEL repo packages, as the naming conventions are
different, you need to tweak the default values of ``map.jinja`` to obtain the
desired results. In short:

* Don't use the ``zabbix.agent.repo`` sls assuming that EPEL repos are already
  configured

* Override the ``map.jinja`` definitions using pillar values like this

.. code:: yaml

    zabbix:
      lookup:
        agent:
          pkg: zabbix22-agent
        server:
          pkg: zabbix22-server-mysql


Now you just have to use ``zabbix.agent.conf`` sls file and that's it.

Example of usage
================

Just as an example, this is a ``top.sls`` file to install a complete modular
self-contained Zabbix system:

.. code:: yaml

  base:
    '*':
      - zabbix.agent.repo
      - zabbix.agent.conf

      - mysql.server.conf
      - mysql.client.conf
      - zabbix.mysql.conf
      - zabbix.mysql.schema

      - zabbix.server.repo
      - zabbix.server.conf

      - nginx.conf

      - php.fpm.repo
      - php.fpm.conf
      - php.fpm.mysql
      - php.fpm.bcmath
      - php.fpm.mbstring
      - php.fpm.gd
      - php.fpm.xml
      - php.fpm.opcache

      - zabbix.frontend.repo
      - zabbix.frontend.conf

You need the appropriate mysql, nginx and php formulas to complete the
installation with this ``top.sls`` file.

.. note::

    See the full `Salt Formulas
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_ doc.

Available states
================

.. contents::
    :local:

``zabbix.agent``
----------------

Installs the zabbix-agent package and starts the associated zabbix-
agent service.

``zabbix.agent.conf``
---------------------

Configures the zabbix-agent package.

``zabbix.agent.repo``
---------------------

Configures official Zabbix repo specifically for the agent. Actually it just
includes zabbix.repo and adds a requisite for the pkg state declaration

``zabbix.frontend``
-------------------

Installs Zabbix frontend.

``zabbix.frontend.conf``
----------------------

Configures the zabbix-frontend package. Actually you need to use other formulas
for apache/nginx and php5-fpm to complete a working setup.

``zabbix.frontend.repo``
----------------------

Configures official Zabbix repo specifically for the frontend. Actually it just
includes zabbix.repo and adds a requisite for the pkg state declaration.

``zabbix.mysql.conf``
----------------

Creates database and mysql user for Zabbix.

``zabbix.mysql.schema``
---------------------

Creates mysql schema for Zabbix.

``zabbix.repo``
----------------

Configures official Zabbix repo.

``zabbix.server``
-----------------

Installs the zabbix-server package and starts the associated zabbix-
server service.

``zabbix.server.conf``
----------------------

Configures the zabbix-server package.

``zabbix.server.repo``
----------------------

Configures official Zabbix repo specifically for the server. Actually it just
includes zabbix.repo and adds a requisite for the pkg state declaration

``zabbix.users``
----------------

Declares users and groups that could be needed in other formulas (e.g. in the
users formula to make an user pertain to the service group).

==================
zabbix-formula ng
==================

New install formula, more simple and flexible. (For now support only Debian)
Pillar data is optional, all neaded to install data exist in map.jinja, pillar owerwrite only neaded parameters.
Depends: `mysql-formula 
          <https://github.com/saltstack-formulas/mysql-formula>`_, `nginx-formula 
          <https://github.com/saltstack-formulas/nginx-formula>`_, `php-formula 
          <https://github.com/saltstack-formulas/php-formula>`_.

Example of usage
================

.. code:: yaml

  base:
    '*':
    # full install with all dependencies to one server
    # server 
    - zabbix.ng.server

    # agent
    - zabbix.ng.agent

    # proxy
    - zabbix.ng.frontend

    # to install only needed modules
    - zabbix.ng.server.install

    - zabbix.ng.frontend.install

    - zabbix.ng.agent.install

    - zabbix.ng.mysql.config
    - zabbix.ng.mysql.schema

    - zabbix.ng.proxy.install

    - zabbix.ng.repo


Available states
================

.. contents::
    :local:

``zabbix.ng.repo``
------------------

Configures official Zabbix repo, included in all install states.

``zabbix.ng.agent``
-------------------

Installs the zabbix-agent package, apply config and starts the associated zabbix-agent service.

``zabbix.ng.agent.install``
---------------------------

Installs the zabbix-agent package and starts the associated zabbix-agent service.

``zabbix.ng.server``
--------------------

Installs the zabbix-server package, apply config, install mysql, install php and starts the associated zabbix-server service.

``zabbix.ng.server.install``
----------------------------

Installs the zabbix-server package and starts the associated zabbix-server service.

``zabbix.ng.proxy``
-------------------

Installs the zabbix-proxy package, apply config and starts the associated zabbix-agent service.

``zabbix.ng.proxy.install`` 
---------------------------

Installs the zabbix-proxy package and starts the associated zabbix-agent service.

``zabbix.ng.frontend``
----------------------

Installs the zabbix-frontend package and configure frontend connetcion to DB.

``zabbix.ng.frontend.install``
------------------------------

Installs the zabbix-frontend package.

``zabbix.ng.mysql``
-------------------

Creates database, mysql user for Zabbix and apply Zabbix schema.

``zabbix.ng.mysql.config``
--------------------------

Creates database and mysql user for Zabbix.


