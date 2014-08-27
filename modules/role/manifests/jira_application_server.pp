class role::jira_application_server inherits role {
  class { 'user::ec2_user':
    authorized_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQChHxmmN+ycdjfXp3hlUv0xA+ckArWtbak4P5cc3G0WPYKIizd4I+b2AlD6R+2aGwexMC9fM2uF+po++5HP4dgSdAEV8OkemYNwEyZrbnwWNrUgWD1bVYaL6/KCdBLypkG5PUVShwyIL4jPqSYx8eYz7mfXVGNl3+PUu09nQbSR61Z9lyNxjpEvWAbzTlOErsEr7MhTBjRh/Lao0BiHGXy9z1ocY5n2rxDhG9YaR3R8f3ANWD8DGA2j8/0rH76fLpkGHMNHNJZjrr3GJUIw5EMW2ZUFMCGBNS6iC8ugDmHnZfyG9wuPXwaCGAlgBArmwAqAdhlkeuwMcFADVKiBGGHd'
  }
  include profile::base_box
  include profile::aws_cli
  include profile::java_jdk
  include profile::jira_server
}
