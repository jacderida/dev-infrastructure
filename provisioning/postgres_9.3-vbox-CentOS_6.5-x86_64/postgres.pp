class postgres_wrapper {
  anchor { 'wrapper::begin': } ->
  class { 'base_firewall::pre': } ->
  class { 'base_firewall::post': } ->
  class { 'role::database_server': } ->
  anchor { 'wrapper::end': }
}

class { 'postgres_wrapper': }
