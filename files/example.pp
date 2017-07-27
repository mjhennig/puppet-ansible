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

include ansible

# manifests/setting.pp
ansible::setting {'example':
  ensure => 'example-value',
  section => 'example-section',
}

# For behavioral comparision of the exec providers underlying the ansible type,
# and to have something to notify in the context of the examples below
exec {'echo trigger':
  logoutput => true,
  path => '/bin',
  refreshonly => true,
}

playbook {'example':
  file => 'files/example.yaml',
}

# Does not trigger the notification if Ansible does not indicate a change
ansible {"copy example":
  args => 'content=example dest=/tmp/example',
  module => 'copy',
  notify => Exec['echo trigger'],
}

# An example for a Git/Mercurial bridge based on the Ansible/Puppet integration
define repository (
  $cleanup = false,
  $ensure = undef,
  $path = undef,
  $provider = undef,
  $source,
) {

  # Naive provider auto-detection is naive, duh, works surprisingly well though
  if $provider != undef {
    $backend = $provider
  }
  elsif $source =~ /\bgit(hub|lab)?\b/ {
    $backend = 'git'
  }
  else {
    $backend = 'mercurial'
  }

  # The actual provider emulation within the Puppet DSL is just a bunch of 
  # variables for later use with existing named types
  if $ensure != undef and $ensure =~ /^(absent|purged)$/ {

    # http://docs.ansible.com/ansible/latest/file_module.html
    $args = {
      'path' => $name,
      'state' => 'absent',
    }

    $module = 'file'
  }
  elsif $backend == 'git' {

    # http://docs.ansible.com/ansible/latest/git_module.html
    $args = {
      'dest' => $name,
      'force' => $cleanup,
      'repo' => $source,
      'version' => pick($ensure, 'HEAD'),
    }

    $module = 'git'
  }
  elsif $backend == 'hg' or $backend == 'mercurial' {

    # http://docs.ansible.com/ansible/latest/hg_module.html
    $args = {
      'dest' => $name,
      'force' => $cleanup,
      'repo' => $source,
      'revision' => pick($ensure, 'tip'),
    }

    $module = 'hg'
  }
  else {
    fail("Unsupported repository provider: $backend")
  }

  # https://forge.puppet.com/puppetlabs/stdlib#join
  # https://forge.puppet.com/puppetlabs/stdlib#join_keys_to_values
  ansible {"repository $title":
    args => join(join_keys_to_values($args, '='), ' ') ,
    module => $module,
    path => $path,
  }
}

# Always notifies because the "hg" Ansible module outputs SKIPPPED when
# run in check mode (instead of comparing current and desired state)
#repository {'/tmp/sitescripts-hg':
# ensure => 'master',
# notify => Exec['echo trigger'],
# source => 'https://hg.adblockplus.org/sitescripts',
#}

# The "git" module actually makes an effort; triggering works as expected
repository {'/tmp/sitescripts-git':
  ensure => 'master',
  notify => Exec['echo trigger'],
  source => 'https://github.com/adblockplus/sitescripts',
}
