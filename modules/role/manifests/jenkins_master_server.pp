class role::jenkins_master_server {
  include user::ec2_user
  include profile::base_box
  include profile::java_jdk
  include profile::aws_cli
  include profile::jenkins_master
}
