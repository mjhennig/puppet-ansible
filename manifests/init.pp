# Resources associated with the general setup of the Ansible software
class ansible (
  $package = {},
  $config = '/etc/ansible/ansible.cfg',
  $defaults = {},
) {

  # https://forge.puppet.com/puppetlabs/stdlib#ensure_resource
  ensure_resource('package', 'ansible', $package)

  # https://docs.puppet.com/puppet/latest/function.html#each
  $defaults.each |$key, $value| {

    ansible::setting {"defaults.$key":
      config => $config,
      ensure => $value,
      section => 'defaults',
    }
  }
}
