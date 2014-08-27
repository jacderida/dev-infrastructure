class profile::database {
  $admin_password = hiera('profile::database::admin_password')
  $port = hiera('profile::database::port')
  $jira_dbname = hiera('profile::database::jira_dbname')
  $jira_dbuser = hiera('profile::database::jira_dbuser')
  $jira_dbuser_password = hiera('profile::database::jira_dbuser_password')
  $jira_db_encoding = hiera('profile::database::jira_db_encoding')
  $cron_command = hiera('profile::database::cron_command')
  $cron_minute = hiera('profile::database::cron_minute')
  $cron_hour = hiera('profile::database::cron_hour')
  $cron_date = hiera('profile::database::cron_date')
  $cron_month = hiera('profile::database::cron_month')
  $cron_weekday = hiera('profile::database::cron_weekday')
  $cron_user = hiera('profile::database::cron_user')
  $cron_backup_path = hiera('profile::database::cron_backup_path')
  $cron_path_owner = hiera('profile::database::cron_path_owner')
  $cron_path_group = hiera('profile::database::cron_path_group')
  $cron_path_mode = hiera('profile::database::cron_path_mode')

  firewall { "120 allow access on ${port}":
    port   => $port,
    proto  => tcp,
    action => accept
  } ->

  postgresql::server::pg_hba_rule{'allow network access':
    description => 'allow postgres user to be accessed by cron locally',
    type        => 'local',
    user        => 'postgres',
    database    => 'all',
    auth_method => 'trust',
    order       => '001',
  }

  anchor { 'postgres::start': } ->
  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.3'
  } ->

  class { 'postgresql::server':
    ip_mask_allow_all_users => '0.0.0.0/0',
    listen_addresses        => '*',
    postgres_password       => $admin_password
  } ->

  postgresql::server::role { $jira_dbuser:
    createdb      => true,
    password_hash => postgresql_password($jira_dbuser, $jira_dbuser_password)
  } ->

  postgresql::server::db { $jira_dbname:
    user     => $jira_dbuser,
    password => postgresql_password($jira_dbuser, $jira_dbuser_password),
    owner    => $jira_dbuser,
    encoding => $jira_db_encoding
  } ->
  anchor { 'postgres::end': } ->

  file { $cron_backup_path:
    ensure => 'directory',
    owner  =>  $cron_path_owner,
    group  =>  $cron_path_group,
    mode   =>  $cron_path_mode,
  } ->

  file { "${cron_backup_path}/database_backup.sh":
    ensure => present,
    source => 'puppet:///files/database_backup.sh'
  } ->

  cron::job { 'postgres_backup':
    minute  => $cron_minute,
    hour    => $cron_hour,
    date    => $cron_date,
    month   => $cron_month,
    weekday => $cron_weekday,
    user    => $cron_user,
    command => $cron_command
  }
}
