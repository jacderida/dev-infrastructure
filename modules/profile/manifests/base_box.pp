class profile::base_box {
  anchor { 'profile::base_box::start': } ->

  exec { 'disable requiretty':
    command => '/bin/sed -i \'s/^.*requiretty/#Defaults requiretty/\' /etc/sudoers'
  } ->

  exec { 'Set UseDNS no':
    command => '/bin/echo "UseDNS no" >> /etc/ssh/sshd_config'
  } ->

  class { 'base_firewall::pre': } ->
  class { 'base_firewall::post': } ->

  anchor { 'profile::base_box::end': }
}
