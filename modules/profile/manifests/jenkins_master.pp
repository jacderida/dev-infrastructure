class profile::jenkins_master {
  $install_java = hiera('profile::jenkins_master::install_java')
  $use_lts = hiera('profile::jenkins_master::use_lts')
  $port = hiera('profile::jenkins_master::port')
  $plugins = hiera('profile::jenkins_master::plugins')

  firewall { "120 allow http and https access on ${port}":
    port   => $port,
    proto  => tcp,
    action => accept
  } ->

  anchor { 'profile::jenkins_master::start': } ->

  class { 'jenkins':
    lts          => $use_lts,
    install_java => $install_java,
    plugin_hash  => $plugins,
    config_hash  => { 'JENKINS_PORT' => { 'value' => $port } }
  } ->

  # This is a temporary measure to allow the userContent directory time to be created.
  # There is a way to wait on services starting. It's based on looking for output in the
  # log, but I need to come back to it later.
  exec { 'sleeping for 90 seconds':
    command => '/bin/sleep 90'
  } ->

  file { '/var/lib/jenkins/userContent/doony.min.js':
    ensure => present,
    owner  => 'jenkins',
    source => 'puppet:///files/doony.min.js'
  } ->

  file { '/var/lib/jenkins/userContent/doony.min.css':
    ensure => present,
    owner  => 'jenkins',
    source => 'puppet:///files/doony.min.css'
  } ->

  anchor { 'profile::jenkins_master::end': }
}
