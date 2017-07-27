# Manipulates directives in Ansible configuration files
define ansible::setting (
  $config = $::ansible::config,
  $ensure,
  $section = 'defaults',
) {

  # Recognize absent parameters for explicit use of builtin defaults
  $changes = $ensure ? {
    undef => ["remove \"$name\""],
    default => ["set \"$name\" \"$ensure\""],
  }

  # https://docs.puppet.com/guides/augeas.html
  augeas {"${config}#${section}.${name}":
    changes => $changes,
    context => "/files${config}/${section}",
    incl => $config,
    lens => 'Puppet.lns',
    require => Class['ansible'],
  }
}
