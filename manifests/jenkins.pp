class jenkins_wrapper {
  anchor { 'jenkins_wrapper::begin': } ->
  class { 'role::jenkins_master_server': } ->
  anchor { 'jenkins_wrapper::end': }
}

include jenkins_wrapper
