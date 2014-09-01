class role::base_server {
  include user::ec2_user
  include profile::base_box
}
