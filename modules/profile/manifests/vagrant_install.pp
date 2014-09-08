class profile::vagrant_install(
  $user = undef
) {
  $vagrant_path = '/opt/vagrant/bin/vagrant'

  anchor { 'profile::vagrant_install::begin': } ->

  class { 'rvm': } ->

  rvm::system_user { $user: ; } ->

  rvm_system_ruby {
    'ruby-1.9.3-p547':
      ensure      => present,
      default_use => true,
      build_opts  => ['--binary']
  } ->

  class { 'vagrant':
    version => '1.6.3'
  } ->

  vagrant::plugin { 'vagrant-aws':
    user => $user
  } ->

  # It became complicated to get this command to run. Since these boxes are per
  # user, it needs to be run in the context of the build user. However, the
  # actual vagrant command (a shell script), tries to cd into $CURDIR, which
  # was returning the home directory of the user running the puppet apply (under ssh).
  # Since we're saying we want to run this command in the context of the build
  # user, the cd command would fail with insufficient permissions. This meant
  # the cwd needed to be set to the home directory of the build user. This
  # still didn't work, as somewhere, Vagrant makes reference to $HOME.
  # For some reason, Puppet unsets this when it changes the user context.
  # Hence, the environment attribute explicitly sets $HOME.
  exec { 'install aws template box':
    command     => "${vagrant_path} box add aws https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box",
    cwd         => "/home/${user}",
    user        => $user,
    environment => "HOME=/home/${user}",
    timeout     => 1800 # This can take a while to run on slower boxes.
  } ->

  anchor { 'profile::vagrant_install::end': }
}
