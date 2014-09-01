class role::jira_application_server inherits role {
  include user::ec2_user
  include profile::base_box
  include profile::aws_cli
  include profile::java_jdk
  include profile::jira_server
}
