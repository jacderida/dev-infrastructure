class role::database_server inherits role {
  include user::ec2_user
  include profile::database
}
