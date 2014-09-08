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

  # This is easier than putting the application's directory on the PATH.
  # Other scripts can then reference it from /usr/local/bin, because it
  # turns out there's actually another packer program in /usr/sbin, which
  # generally tends to be on the path before anything else.
  exec { 'symlink packer to /usr/local/bin':
    command => "ln -s ${packer_path}/packer /usr/local/bin/packer"
  } ->

  anchor { 'profile::packer_install::end': }
}
