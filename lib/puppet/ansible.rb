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

# Ruby module +Puppet::Ansible+ is the foundation of Puppet module +ansbile+.
module Puppet::Ansible

  # https://ruby-doc.org/core/Module.html#method-i-autoload
  autoload :Exec, File.expand_path('../ansible/exec.rb', __FILE__)
  autoload :Params, File.expand_path('../ansible/params.rb', __FILE__)
  autoload :VERSION, File.expand_path('../ansible/version.rb', __FILE__)

end
