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

  class { 'jenkins':
    lts          => $use_lts,
    install_java => $install_java,
    plugin_hash  => $plugins,
    config_hash  => { 'JENKINS_PORT' => { 'value' => $port } }
  }
}
