class role::base_server {
  class { 'user::ec2_user':
    authorized_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCdrSb7JGWvORp2KphbPTGoLcFHS1r+YbGGoKj/tc6lhUg1CmNEqDOnfV5BTxASJ8kw07zRlTf40iagmQYJzDOzIww/QRc6brCdRFEbFOFI8GiyqBgNgEZ20+xMffneP4dj6VB8g88R7e/s1x+pzcsoTXopsORWK/VfNsimN8atQ5V5sGcNQpMYmQovh4mMiC31gKwLVyd/yqNwEBaTvYNzJggc3DdI0/rqCAGadJaNbpYDox7WxdnTxQVanw4Kf5ug/epGFRgkU0FyPLxy46KndHmbouj9IWUEaoKetoIGJG8394wJNG+OetdyxLjBtLPQLHCFf76gXMz+vcxbUq/v'
  }
  include profile::base_box
}