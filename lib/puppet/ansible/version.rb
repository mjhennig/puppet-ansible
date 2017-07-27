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

require 'json'

# The Ansible module should be compatible with Puppet versions between 3.7 and
# 4.8, which are the package versions provided by Debian GNU/Linux 8 ("jessie")
# and 9 ("stretch"), respectively, at the time of writing.
module Puppet
  module Ansible

    # Constant +Puppet::Ansible::VERSION+ is the +version+ designated within
    # the +metadata.json+ file found in the source of Puppet module +ansible+.
    VERSION = begin
      path = File.expand_path('../../../../metadata.json', __FILE__)
      file = File.read(path)
      data = JSON.parse(file)
      data['version'] || 'UNDEFINED'
    rescue
      STDERR.puts("Could not retrieve Puppet::Ansible::VERSION: #{$!.message}")
      'UNKNOWN'
    end.freeze

  end
end
