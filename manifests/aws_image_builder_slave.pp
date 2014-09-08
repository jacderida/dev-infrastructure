class aws_image_builder_slave_wrapper {
  anchor { 'aws_image_builder_slave_wrapper::begin': } ->
  class { 'role::aws_image_builder_build_slave': } ->
  anchor { 'aws_image_builder_slave_wrapper::end': }
}

include aws_image_builder_slave_wrapper
