class profile::base_box {
  anchor { 'profile::base_box::start': } ->

  exec { 'disable requiretty':
    command => '/bin/sed -i \'s/^.*requiretty/#Defaults requiretty/\' /etc/sudoers'
  } ->

  exec { 'Set UseDNS no':
    command => '/bin/echo "UseDNS no" >> /etc/ssh/sshd_config'
  } ->

  exec { 'add /usr/local/bin to PATH':
    command => '/bin/echo \'export PATH=/usr/local/bin:$PATH\' >> /etc/profile.d/usr_local_bin.sh'
  } ->

  exec { 'chmod a+x /etc/profile.d/usr_local_bin.sh':
    command => '/bin/chmod a+x /etc/profile.d/usr_local_bin.sh'
  } ->

  class { 'base_firewall::pre': } ->
  class { 'base_firewall::post': } ->

  anchor { 'profile::base_box::end': }
}
