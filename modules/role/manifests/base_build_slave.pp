class role::base_build_slave {
  include profile::base_box
  include user::ec2_user
  include user::build_user
  include profile::java_jdk
  include profile::build_slave
}
