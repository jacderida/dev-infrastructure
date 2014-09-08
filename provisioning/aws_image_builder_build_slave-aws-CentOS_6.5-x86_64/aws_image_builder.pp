class aws_image_builder_wrapper {
  anchor { 'aws_image_builder_wrapper::begin': } ->
  class { 'role::aws_image_builder_build_slave': } ->
  anchor { 'aws_image_builder_wrapper::end': }
}

include aws_image_builder_wrapper
