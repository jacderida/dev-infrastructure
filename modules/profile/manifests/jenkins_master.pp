class profile::jenkins_master {
  $install_java = hiera('profile::jenkins_master::install_java')
  $use_lts = hiera('profile::jenkins_master::use_lts')
  $port = hiera('profile::jenkins_master::port')
  $plugins = hiera('profile::jenkins_master::plugins')

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

  file { $cron_backup_path:
    ensure => 'directory',
    owner  =>  $cron_path_owner,
    group  =>  $cron_path_group,
    mode   =>  $cron_path_mode,
  } ->

  file { "${cron_backup_path}/jenkins_backup.sh":
    ensure => present,
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
