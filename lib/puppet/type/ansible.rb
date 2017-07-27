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
Puppet::Type.newtype(:ansible) do

  @doc = 'Invoke the ansible(1) executable.'

  # https://ruby-doc.org/core/Module.html#method-i-include
  include Puppet::Ansible::Exec
  include Puppet::Ansible::Params

  newparam(:args) do
    desc 'Translates directly into the --args parameter.'
    defaultto ''
  end

  newparam(:module) do
    desc 'Translates directly into the --module-name parameter.'
  end

  # https://docs.puppet.com/puppet/latest/custom_types.html#namevar
  newparam(:name, :namevar => true) do
    desc 'The name associated with the resource.'
  end

  newparam(:target) do
    desc 'Translates directly into the ansible host pattern.'
    defaultto 'localhost'
  end

  def command
    Shellwords.join([
      'ansible', self[:target],
      '--module-name', self[:module],
      '--args', self[:args],
      '--inventory', self[:inventory],
      '--limit', self[:limit],
      '--connection', 'local',
    ])
  end

  # https://docs.puppet.com/puppet/latest/custom_types.html#customizing-behaviour
  newproperty(:returns, :event => :executed_command) do |property|

    desc 'The output and exit code from the Ansible invocation.'
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

    def insync?(is)
      if @status.nil?
        output, status = provider.run("#{resource.command} --check", true)
        status.exitstatus.to_s == '0' \
          && output !~ /^\s*"changed": true,\s*$/ \
          && output =~ /^\s*"changed": false,\s*$/
      else
        super
      end
    end

    def sync
      @output, status = provider.run(resource.command)
      @output.split(/\n/).each(&self.method(:notice))
      @status = status.exitstatus.to_s
      self.fail("Ansible returned #{@status} instead of 0") if @status != '0'
      return event_name 
    end

    # https://tickets.puppetlabs.com/browse/PUP-5624
    validate do |value|
      message = 'Cannot set read-only property $returns' 
      raise ArgumentError, message if value != default
    end

  end

end
