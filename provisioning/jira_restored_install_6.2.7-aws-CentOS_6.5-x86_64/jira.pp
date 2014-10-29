class jira_wrapper {
  anchor { 'jira_wrapper::begin': } ->
  class { 'role::restored_jira_server': } ->
  anchor { 'jira_wrapper::end': }
}

include jira_wrapper
