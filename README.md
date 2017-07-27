Puppet Module Ansible
=====================

This module integrates [Ansible][a] with [Puppet][p]. It is a PROOF OF CONCEPT,
not even an *alpha*, *beta* or other preview release, so do not expect too much
just yet.

[a]: https://en.wikipedia.org/wiki/Ansible_(software)
[p]: https://en.wikipedia.org/wiki/Puppet_(software)


Synopsis
--------

    ansible {'example':
      args => 'name=apt-transport-https',
      module => 'package',
    }

    ansible::setting {'example':
      config => '/home/user/.ansible.cfg',
      ensure => '/home/user/.ansible/tmp',
      name => 'remote_tmp',
      section => 'defaults',
    }


Hacking
-------

Currently I perform a smoke-test by switching into the repository root and
issueing the following command:

    sudo puppet apply --verbose --modulepath ..:/usr/share/puppet/modules < files/example.pp

Please refer to the `files/example.pp` manifest for details.


Copyright & License
-------------------

Copyright (c) 2017 eyeo GmbH

This is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with the software. If not, see <http://www.gnu.org/licenses/>.


