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
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCiiQ1rHZZNQu11o6IejtxZi8s1Snke9oWeOmF+phkmTUjv2VSQljK+2MEH+iv/Du5VFXsBStgOSlQ1PdcbnlwIObDZIstAtrpBnDjh/BT8/0DTSB//6wZgkLuxCGluK2BBLZxDe3f39WK3A9Tt2Dh/zl/VG0JETRmZLQ46OxIqNlSlP8Ow+Zn/RGEfoqfSEy5YnKb309uY8BZ21rRfMG32Z1oCPqEc7wzkaWoGdi9mq98hNB2197TqV5OJLt+BiIeTrtFhpdZMCpFZy+0iWFuTog738rrC/dqDeIToTj6YomIWl44i8VRjGLszDb8rbJGkb3di8Zj93j9T8CIzjq65',
    target => '/home/ec2-user/.ssh/authorized_keys',
    type   => 'ssh-rsa'
  } ->

  anchor { 'ec2-user::end': }
}
