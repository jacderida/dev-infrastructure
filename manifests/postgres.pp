class postgres_wrapper {
  anchor { 'wrapper::begin': } ->
  class { 'role::database_server': } ->
  anchor { 'wrapper::end': }
}

class { 'postgres_wrapper': }
