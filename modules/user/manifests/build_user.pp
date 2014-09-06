class user::build_user {
  $user = 'build_user'
  $home_path = "/home/${user}"

  anchor { 'user::build_user::begin': } ->

  group { $user:
    ensure => present
  } ->

  user { $user:
    ensure     => present,
    shell      => '/bin/bash',
    home       => $home_path,
    comment    => 'Build user account',
    managehome => true
  } ->

  ssh_authorized_key { "${user}_authorized_key":
    ensure => present,
    user   => $user,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDaXs3Dgt+gtatZnFoU6cgwWvaHfq04gdK4e0ttl6t5fL8oYY/1/fzN+l8QQrRmlwg9PZn28nyprYJCmAAYb7eraV1mBdtt+S00javW/EdHlxbFkojEwKKyg6cU1/dAUmHkwhC7Zr7XS8/2zkRIeNpeRl0uyAjMW0Kx5sPbAWNkGpY6Uc/Bowks0vsCuvDrBkLktxHVSxP5UyJ7cI8KTWSauzV5WwSE3ZrvfL6+zhKKEtvAGKWykJI3XdxdfXoKjcbrwglD/1vFq2P4yldl6ZRbvUEvLLPiX80vbFoAPk/2U03Q5r+ypgQHV3SEAzpC6eHpD8BFFjuZY0zJDvzMYIq1',
    target => "${home_path}/.ssh/authorized_keys",
    type   => 'ssh-rsa'
  } ->

  anchor { 'user::build_user::end': }
}
