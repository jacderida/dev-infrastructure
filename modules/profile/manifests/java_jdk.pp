class profile::java_jdk {
  class { 'java':
    distribution => 'jdk',
    version      => 'latest'
  }
}
