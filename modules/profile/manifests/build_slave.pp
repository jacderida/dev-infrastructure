class profile::build_slave {
  anchor { 'profile::build_slave::start': } ->

  package { 'libcurl-devel':
    ensure => present
  } ->

  file { '/tmp/git_1.7.12-RHEL.sh':
    ensure => present,
    source => 'puppet:///files/git_1.7.12-RHEL.sh'
  } ->

  exec { 'install git 1.7.12':
    command => '/usr/bin/sudo /bin/bash git_1.7.12-RHEL.sh',
    cwd     => '/tmp'
  } ->

  anchor { 'profile::build_slave::end': }
}
