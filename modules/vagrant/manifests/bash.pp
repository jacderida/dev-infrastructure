# == Class: vagrant::bash
#
# Install bash completion for vagrant
#
# === Examples
#
#  include vagrant::bash
#
class vagrant::bash (
  $completion_dir = undef
) {

  include vagrant

  if $completion_dir == undef {
    case $::operatingsystem {
      centos, redhat, fedora, debian, ubuntu: {
        $basedir = '/etc/bash_completion.d'
      }
      darwin: {
        $basedir = '/usr/local/etc/bash_completion.d'
      }
      windows: {
        fail("Unsupported operating system to install bash completion: ${::operatingsystem}")
      }
      default: {
        fail("Unrecognized operating system: ${::operatingsystem}")
      }
    }
  } else {
    $basedir = $completion_dir
  }

  file { "${basedir}/vagrant.sh":
    ensure  => link,
    target  => "/opt/vagrant/embedded/gems/gems/vagrant-${vagrant::version}/contrib/bash/completion.sh",
    require => Class['vagrant']
  }

}
