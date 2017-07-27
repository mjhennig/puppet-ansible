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

# https://docs.puppet.com/puppet/latest/provider_development.html
# https://docs.puppet.com/puppet/latest/type.html#exec-provider-posix
Puppet::Type.type(:ansible).provide(
  :posix, 
  :parent => Puppet::Type.type(:exec).provider(:posix),
) do

  @doc = 'Default provider on POSIX systems, inherited from exec.'

  # https://docs.puppet.com/puppet/latest/provider_development.html#suitability
  confine :feature => :posix
  has_feature :umask

  # https://docs.puppet.com/puppet/latest/provider_development.html#default-providers
  defaultfor :feature => :posix

end
