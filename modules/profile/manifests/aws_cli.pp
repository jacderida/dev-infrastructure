class profile::aws_cli (
  $user = "ec2-user"
)
{
  anchor { 'profile::aws_cli::start': } ->

  package { 'python-pip':
    ensure => present
  } ->

  package { 'python-devel':
    ensure => present
  } ->

  exec { 'install aws cli':
    command => '/usr/bin/sudo /usr/bin/pip install awscli'
  } ->

  file { "/home/${user}/.aws":
    ensure => directory
  } ->

  file { "/home/${user}/.aws/config":
    ensure => present,
    source => 'puppet:///files/aws_config'
  } ->

  exec { 'set aws access key id':
    command => "/bin/sed -i 's#<default access key>#$::aws_access_key_id#g' /home/${user}/.aws/config"
  } ->

  exec { 'set aws secret key':
    command => "/bin/sed -i 's#<default secret key>#$::aws_secret_access_key#g' /home/${user}/.aws/config"
  } ->

  anchor { 'profile::aws_cli::end': }
}
