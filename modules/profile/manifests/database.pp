class profile::database {
  $admin_password = hiera('profile::database::admin_password')
  $port = hiera('profile::database::port')
  $jira_dbname = hiera('profile::database::jira_dbname')
  $jira_dbuser = hiera('profile::database::jira_dbuser')
  $jira_dbuser_password = hiera('profile::database::jira_dbuser_password')
  $jira_db_encoding = hiera('profile::database::jira_db_encoding')

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
  anchor { 'postgres::end': }
}
