class role::restored_database_server {
  include user::ec2_user
  include profile::base_box
  include profile::aws_cli
  include profile::restored_database
}
