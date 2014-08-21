class user::ec2_user (
  $authorized_key = undef
)
{
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
    key    => $authorized_key,
    target => '/home/ec2-user/.ssh/authorized_keys',
    type   => 'ssh-rsa'
  } ->

  anchor { 'ec2-user::end': }
}
