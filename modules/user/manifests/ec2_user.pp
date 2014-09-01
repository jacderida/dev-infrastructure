class user::ec2_user {
  anchor { 'ec2-user::begin': } ->
  user { 'ec2-user':
    ensure     => present,
    shell      => '/bin/bash',
    home       => '/home/ec2-user',
    managehome => true
  } ->

  exec { 'add ec2-user to sudoers':
    command => '/bin/echo "ec2-user        ALL=(ALL)        NOPASSWD: ALL" >> /etc/sudoers.d/ec2-user'
  } ->

  exec { 'set read only for root user':
    command => '/bin/chmod a+x /etc/sudoers.d/ec2-user'
  } ->

  ssh_authorized_key { 'ec2-user_authorized_key':
    ensure => present,
    user   => 'ec2-user',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDXuecZh0RkOWUv1ZZ2gDgAclZD7xSLmtXKVSdLQ5s4CtHsWO0GDlTDnaxs1+SBtZ4iPlzy2kyEQq8nCtX9XvMwR7QnyNA5O56uu+wx5oVcAEiXznju6J3QjS3AjoqgJEXkc4Qb+RB5gE4VhNcO5WTq+t3e3Y827kKWbTnv00fM/4ZP3RSgOdaYChokdE4c4bH+GS2wVbF4oRFBMwq6PSqfpDxDJOsuwoAV0Cddn+zqIa9rseb+y+9wpPUCLbRit5e3oAnwvSIPz6ueVmJ7esBa+VGCuAlpOazRa9GODOXCfQbsgkjfgZExRjLgmNvB30zcvBY+OwYnxRVasIuemt/1',
    target => '/home/ec2-user/.ssh/authorized_keys',
    type   => 'ssh-rsa'
  } ->

  anchor { 'ec2-user::end': }
}
