class database_wrapper {
  anchor { 'jenkins_wrapper::begin': } ->
  class { 'role::restored_database_server': } ->
  anchor { 'jenkins_wrapper::end': }
}

include database_wrapper
