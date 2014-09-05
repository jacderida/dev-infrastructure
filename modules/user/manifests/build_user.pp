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
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDXuecZh0RkOWUv1ZZ2gDgAclZD7xSLmtXKVSdLQ5s4CtHsWO0GDlTDnaxs1+SBtZ4iPlzy2kyEQq8nCtX9XvMwR7QnyNA5O56uu+wx5oVcAEiXznju6J3QjS3AjoqgJEXkc4Qb+RB5gE4VhNcO5WTq+t3e3Y827kKWbTnv00fM/4ZP3RSgOdaYChokdE4c4bH+GS2wVbF4oRFBMwq6PSqfpDxDJOsuwoAV0Cddn+zqIa9rseb+y+9wpPUCLbRit5e3oAnwvSIPz6ueVmJ7esBa+VGCuAlpOazRa9GODOXCfQbsgkjfgZExRjLgmNvB30zcvBY+OwYnxRVasIuemt/1',
    target => "${home_path}/.ssh/authorized_keys",
    type   => 'ssh-rsa'
  } ->

  anchor { 'user::build_user::end': }
}
