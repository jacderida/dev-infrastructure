resources { 'firewall':
  purge => true
}

Firewall {
  before  => Class['base_firewall::post'],
  require => Class['base_firewall::pre']
}

class { ['base_firewall::pre', 'base_firewall::post' ]: }

include role::database_server
