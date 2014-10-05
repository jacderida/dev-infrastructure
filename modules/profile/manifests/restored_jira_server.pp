class profile::restored_jira_server {
  $installdir = hiera('profile::jira_server::installdir')
  $version = hiera('profile::jira_server::version')
  $user = hiera('profile::jira_server::user')
  $group = hiera('profile::jira_server::group')
  $dbtype = hiera('profile::jira_server::dbtype')
  $dbname = hiera('profile::database::jira_dbname')
  $dbuser = hiera('profile::database::jira_dbuser')
  $dbpassword = hiera('profile::database::jira_dbuser_password')
  $dbserver = hiera('profile::database::dbserver')
  $dbport = hiera('profile::database::port')
  $javahome = hiera('profile::java_jdk::homedir')
  $port = hiera('profile::jira_server::port')

  $cron_command = hiera('profile::jira_server::cron_command')
  $cron_minute = hiera('profile::jira_server::cron_minute')
  $cron_hour = hiera('profile::jira_server::cron_hour')
  $cron_date = hiera('profile::jira_server::cron_date')
  $cron_month = hiera('profile::jira_server::cron_month')
  $cron_weekday = hiera('profile::jira_server::cron_weekday')
  $cron_user = hiera('profile::jira_server::cron_user')
  $cron_backup_path = hiera('profile::jira_server::cron_backup_path')
  $cron_path_owner = hiera('profile::jira_server::cron_path_owner')
  $cron_path_group = hiera('profile::jira_server::cron_path_group')
  $cron_path_mode = hiera('profile::jira_server::cron_path_mode')

  firewall { "120 allow http and https access on ${port}":
    port   => $port,
    proto  => tcp,
    action => accept
  } ->

  anchor { 'profile::jira_server::begin': } ->

  file { $installdir:
    ensure => 'directory'
  } ->

  package { 'wget':
    ensure => present
  } ->

  file { '/tmp/restore_latest_jira_home.sh':
    ensure  => present,
    owner   => 'jira',
    content => template('profile/restore_latest_jira_home.sh.erb')
  } ->

  class { 'jira':
    version        => $version,
    installdir     => $installdir,
    user           => $user,
    group          => $group,
    db             => $dbtype,
    dbuser         => $dbuser,
    dbpassword     => $dbpassword,
    dbserver       => $dbserver,
    dbname         => $dbname,
    dbport         => $dbport,
    javahome       => $javahome,
    tomcatPort     => $port,
    service_ensure => stopped
  } ->

  exec { 'restore jira home':
    command     => "/bin/bash /tmp/restore_latest_jira_home.sh ${dbserver}",
    cwd         => '/tmp',
    user        => 'jira',
    environment => ['AWS_CONFIG_FILE=/etc/aws_config']
  } ->

  service { 'jira':
    ensure => running
  } ->

  file { '/tmp/wait_for_jira_service.sh':
    ensure => present,
    owner  => 'jira',
    source => 'puppet:///files/wait_for_jira_service.sh'
  } ->

  file { $cron_backup_path:
    ensure => 'directory',
    owner  =>  $cron_path_owner,
    group  =>  $cron_path_group,
    mode   =>  $cron_path_mode,
  } ->

  file { "${cron_backup_path}/jira_backup.sh":
    ensure => present,
    source => 'puppet:///files/jira_backup.sh'
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

  exec { 'wait for JIRA service to initialise':
    command => '/bin/bash /tmp/wait_for_jira_service.sh',
    cwd     => '/tmp',
    user    => 'jira'
  } ->

  anchor { 'profile::jira_server::end': }
}
