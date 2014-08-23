class role::database_server inherits role {
  class { 'user::ec2_user':
    authorized_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCiiQ1rHZZNQu11o6IejtxZi8s1Snke9oWeOmF+phkmTUjv2VSQljK+2MEH+iv/Du5VFXsBStgOSlQ1PdcbnlwIObDZIstAtrpBnDjh/BT8/0DTSB//6wZgkLuxCGluK2BBLZxDe3f39WK3A9Tt2Dh/zl/VG0JETRmZLQ46OxIqNlSlP8Ow+Zn/RGEfoqfSEy5YnKb309uY8BZ21rRfMG32Z1oCPqEc7wzkaWoGdi9mq98hNB2197TqV5OJLt+BiIeTrtFhpdZMCpFZy+0iWFuTog738rrC/dqDeIToTj6YomIWl44i8VRjGLszDb8rbJGkb3di8Zj93j9T8CIzjq65'
  }
  include profile::base_box
  include profile::database
}
