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

  file { '/etc/aws_config':
    ensure => present,
    source => 'puppet:///files/aws_config',
    mode   => '0744'
  } ->

  exec { 'create /etc/aws.sh':
    command => '/bin/echo "export AWS_CONFIG_FILE=/etc/aws_config" >> /etc/profile.d/aws.sh'
  } ->

  exec { 'chmod a+x /etc/aws.sh':
    command => "/bin/chmod a+x /etc/profile.d/aws.sh"
  } ->

  exec { 'set aws access key id':
    command => "/bin/sed -i 's#<default access key>#${::aws_access_key_id}#g' /etc/aws_config"
  } ->

  exec { 'set aws secret key':
    command => "/bin/sed -i 's#<default secret key>#${::aws_secret_access_key}#g' /etc/aws_config"
  } ->

  anchor { 'profile::aws_cli::end': }
}
