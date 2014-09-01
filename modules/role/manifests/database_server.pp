class role::database_server inherits role {
  include user::ec2_user
  include profile::base_box
  include profile::aws_cli
  include profile::database
}
