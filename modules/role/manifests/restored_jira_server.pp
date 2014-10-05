class role::restored_jira_server {
  include user::ec2_user
  include profile::base_box
  include profile::aws_cli
  include profile::java_jdk
  include profile::restored_jira_server
}
