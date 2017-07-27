# vi: set fenc=utf-8 ft=ruby ts=8 sw=2 sts=2 et:
# coding: utf-8

# Copyright (c) 2017 eyeo GmbH
#
# This is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with the software. If not, see <http://www.gnu.org/licenses/>.

require 'puppet'

# The +Puppet::Ansible::Params+ module eases the integration of ansible(1) and
# ansible-playbook(1) as Puppet resource types by defining a set of parameters
# that translate into options supported by both executables.
module Puppet::Ansible::Params

  # Method +included+ is a hook invoked by Ruby when the module is included
  # in another context. It defines a set of new parameters on the +base+, which
  # is expected to be a +Puppet::Type+ definition, each of which is associated
  # with an Ansible executable option.
  def self.included(base)

    # http://docs.ansible.com/ansible/latest/intro_inventory.html
    base.newparam(:inventory) do
      desc 'Translates directrly into the --inventory parameter.'
      defaultto 'localhost,'
    end

    # https://lmddgtfy.net/?q=ansible%20--limit
    base.newparam(:limit) do
      desc 'Translates directly into the --limit parameter.'
      defaultto 'all'
    end

  end

end
