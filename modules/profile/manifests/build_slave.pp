class profile::build_slave {
  anchor { 'profile::build_slave::start': } ->

  package { 'libcurl-devel':
    ensure => present
  } ->

  package { 'wget':
    ensure => present
  } ->

  file { '/tmp/git_1.7.12-RHEL.sh':
    ensure => present,
    source => 'puppet:///files/git_1.7.12-RHEL.sh'
  } ->

  exec { 'install git 1.7.12':
    command => '/usr/bin/sudo /bin/bash git_1.7.12-RHEL.sh',
    cwd     => '/tmp',
    timeout => 1800 # This can take a little while to run on slower boxes.
  } ->

  file { '/tmp/jq-1.4.sh':
    ensure => present,
    source => 'puppet:///files/jq-1.4.sh'
  } ->

  exec { 'install jq 1.4':
    command => '/usr/bin/sudo /bin/bash jq-1.4.sh',
    cwd     => '/tmp',
    timeout => 1800 # This can take a little while to run on slower boxes.
  } ->

  anchor { 'profile::build_slave::end': }
}
