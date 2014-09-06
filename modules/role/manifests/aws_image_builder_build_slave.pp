class role::aws_image_builder_build_slave inherits role::base_build_slave {
  include profile::aws_cli
  include profile::packer_install
  class { 'profile::vagrant_install':
    user => 'build_user'
  }
}
