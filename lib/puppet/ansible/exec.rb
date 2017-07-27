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

# The +Puppet::Ansible::Exec+ module eases the creation of exec-like custom
# resource types by defining the parameters required by exec's providers on
# the +Puppet::Type+ that includes the module during definition.
module Puppet::Ansible::Exec

  # Method +included+ is a hook invoked by Ruby when the module is included
  # in another context. It defines a set of new parameters on the +base+, which
  # is expected to be a +Puppet::Type+ definition, each of which is compatible
  # with Puppet's providers for its native +exec+ resource type.
  def self.included(base)

    # https://docs.puppet.com/puppet/latest/type.html#exec-attribute-cwd
    base.newparam(:cwd, :parent => Puppet::Parameter::Path) do
      desc 'The execution directory analogous to the exec $cwd attribute.'
    end

    # https://docs.puppet.com/puppet/latest/type.html#exec-attribute-environment
    base.newparam(:environment) do
      desc 'Any custom variables, analogous to the exec $environment attribute.'
    end

    # https://docs.puppet.com/puppet/latest/type.html#exec-attribute-group
    base.newparam(:group) do
      desc 'The execution group, analogous to the exec $group attribute.'
    end

    # https://docs.puppet.com/puppet/latest/type.html#exec-attribute-path
    base.newparam(:path) do
      desc 'The environment PATH, analogous to the exec $path attribute.'
      defaultto ['/usr/bin', '/bin']
    end

    # https://docs.puppet.com/puppet/latest/type.html#exec-attribute-timeout
    base.newparam(:timeout) do
      desc 'The max. execution time, analogous to the exec $timeout attribute.'
      defaultto 300
    end

    # https://docs.puppet.com/puppet/latest/type.html#exec-attribute-umask
    base.newparam(:umask, :required_feature => :umask) do
      desc 'The new file mode bitmask, analogous to the exec $umask attribute.'
    end

    # https://docs.puppet.com/puppet/latest/type.html#exec-attribute-user
    base.newparam(:user) do
      desc 'The user to run as, analogous to the exec $user attribute.'
    end

  end

end
