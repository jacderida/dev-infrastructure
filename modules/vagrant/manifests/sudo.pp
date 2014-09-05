# == Class: vagrant::sudo
#
# Install sudo configuration for vagrant
#
# === Examples
#
#  include vagrant::sudo
#
class vagrant::sudo (
  $sudoers_dir = undef
) {

  include vagrant

  if $sudoers_dir == undef {
    case $::operatingsystem {
      centos, redhat, fedora, debian, ubuntu: {
        $basedir = '/etc/sudoers.d'
        $file = 'linux'
      }
      darwin: {
        $basedir = '/etc/sudoers.d'
        $file = 'osx'
      }
      windows: {
        fail("Unsupported operating system to install sudo configuration: ${::operatingsystem}")
      }
      default: {
        fail("Unrecognized operating system: ${::operatingsystem}")
      }
    }
  } else {
    $basedir = $sudoers_dir
  }

  file { "${basedir}/vagrant":
    ensure  => link,
    target  => "/opt/vagrant/embedded/gems/gems/vagrant-${vagrant::version}/contrib/sudoers/${file}",
    require => Class['vagrant']
  }

}
