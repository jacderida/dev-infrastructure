class profile::packer_install {
  Exec { path => [ '/usr/bin/', '/usr/sbin/', '/sbin/', '/bin/'] }

  $packer_path = '/opt/packer-0.6.0'
  $source_url = 'https://dl.bintray.com/mitchellh/packer/0.6.1_linux_amd64.zip'

  anchor { 'profile::packer_install::begin': } ->

  package { 'unzip':
    ensure => present
  } ->

  archive { 'packer_linux_amd64':
    ensure           => present,
    url              => $source_url,
    target           => $packer_path,
    extension        => 'zip',
    checksum         => false,
    src_target       => '/tmp',
    timeout          => 0,
    follow_redirects => true
  } ->

  exec { 'add packer to $PATH':
    command => "/bin/echo \"export PATH=${packer_path}:\$PATH\" >> /etc/profile.d/packer.sh"
  } ->

  exec { 'chmod a+x /etc/profile.d/packer.sh':
    command => '/bin/chmod a+x /etc/profile.d/packer.sh'
  } ->

  anchor { 'profile::packer_install::end': }
}
