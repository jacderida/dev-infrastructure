class jira_wrapper {
  anchor { 'jira_wrapper::begin': } ->
  class { 'role::jira_application_server': } ->
  anchor { 'jira_wrapper::end': }
}

include jira_wrapper
