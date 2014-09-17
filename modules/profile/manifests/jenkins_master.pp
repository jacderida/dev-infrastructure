class profile::jenkins_master {
  $install_java = hiera('profile::jenkins_master::install_java')
  $use_lts = hiera('profile::jenkins_master::use_lts')
  $port = hiera('profile::jenkins_master::port')
  $plugins = hiera('profile::jenkins_master::plugins')
  $jenkins_home_path = hiera('profile::jenkins_master::jenkins_home_path')

  $cron_command = hiera('profile::jenkins_master::cron_command')
  $cron_minute = hiera('profile::jenkins_master::cron_minute')
  $cron_hour = hiera('profile::jenkins_master::cron_hour')
  $cron_date = hiera('profile::jenkins_master::cron_date')
  $cron_month = hiera('profile::jenkins_master::cron_month')
  $cron_weekday = hiera('profile::jenkins_master::cron_weekday')
  $cron_user = hiera('profile::jenkins_master::cron_user')
  $cron_backup_path = hiera('profile::jenkins_master::cron_backup_path')
  $cron_path_owner = hiera('profile::jenkins_master::cron_path_owner')
  $cron_path_group = hiera('profile::jenkins_master::cron_path_group')
  $cron_path_mode = hiera('profile::jenkins_master::cron_path_mode')

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

  file { '/tmp/wait_for_jenkins_service.sh':
    ensure => present,
    owner  => 'jenkins',
    source => 'puppet:///files/wait_for_jenkins_service.sh'
  } ->

  file { $cron_backup_path:
    ensure => 'directory',
    owner  =>  $cron_path_owner,
    group  =>  $cron_path_group,
    mode   =>  $cron_path_mode,
  } ->

  file { "${cron_backup_path}/jenkins_backup.sh":
    ensure  => present,
    content => template('profile/jenkins_backup.sh.erb')
  } ->

  cron::job { 'jira_backup':
    minute  => $cron_minute,
    hour    => $cron_hour,
    date    => $cron_date,
    month   => $cron_month,
    weekday => $cron_weekday,
    user    => $cron_user,
    command => $cron_command
  } ->

  exec { 'wait for jenkins service to initialise':
    command => '/bin/bash /tmp/wait_for_jenkins_service.sh',
    cwd     => '/tmp',
    user    => 'jenkins'
  } ->

  file { "${jenkins_home_path}/userContent/doony.min.js":
    ensure => present,
    owner  => 'jenkins',
    source => 'puppet:///files/doony.min.js'
  } ->

  file { "${jenkins_home_path}/userContent/doony.min.css":
    ensure => present,
    owner  => 'jenkins',
    source => 'puppet:///files/doony.min.css'
  } ->

  file { "${jenkins_home_path}/userContent/get_host.py":
    ensure => present,
    owner  => 'jenkins',
    source => 'puppet:///files/get_host.py'
  } ->

  anchor { 'profile::jenkins_master::end': }
}
