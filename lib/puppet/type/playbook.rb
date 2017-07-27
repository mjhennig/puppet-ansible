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

require_relative '../ansible'
require 'shellwords'

# https://docs.puppet.com/puppet/latest/custom_types.html#creating-a-type
Puppet::Type.newtype(:playbook) do

  @doc = 'Invoke the ansible-playbook(1) executable.'

  # https://ruby-doc.org/core/Module.html#method-i-include
  include Puppet::Ansible::Exec
  include Puppet::Ansible::Params

  # https://docs.puppet.com/puppet/latest/custom_types.html#namevar
  newparam(:name, :namevar => true) do
    desc 'The file name associated with the resource.'
  end

  newparam(:file) do
    desc 'Translates directly into the playbook file name.'
  end

  def command
    Shellwords.join([
      'ansible-playbook', self[:file],
      '--inventory', self[:inventory],
      '--limit', self[:limit],
      '--connection', 'local',
    ])
  end

  # https://docs.puppet.com/puppet/latest/custom_types.html#customizing-behaviour
  newproperty(:returns, :event => :executed_command) do |property|

    desc 'The output and exit code from the ansible-playbook(1) invocation.'
    defaultto '0'

    # Alternative success note, used instead of "changed from notrun to 0".
    def change_to_s(_, _)
      return "executed successfully"
    end

    def event_name
      return :executed_command
    end

    def retrieve
      return @status || :notrun
    end

    def sync
      @output, status = provider.run(resource.command)
      @output.split(/\n/).each(&self.method(:notice))
      @status = status.exitstatus.to_s
      self.fail("ansible-playbook(1) returned #{@status}") if @status != '0'
      return event_name
    end

    # https://tickets.puppetlabs.com/browse/PUP-5624
    validate do |value|
      message = 'Cannot set read-only property $returns'
      raise ArgumentError, message if value != default
    end

  end

end
