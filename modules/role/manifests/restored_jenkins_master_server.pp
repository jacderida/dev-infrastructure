class role::restored_jenkins_master_server {
  include user::ec2_user
  include profile::base_box
  include profile::java_jdk
  include profile::aws_cli
  include profile::restored_jenkins_master
}
