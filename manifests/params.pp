# == Class: selenium::params
#
# This class should be considered private.
#
#
class selenium::params {
  $display         = ':0'
  $user            = 'selenium'
  $group           = $user
  $install_root    = '/opt/selenium'
  $server_options  = '-Dwebdriver.enable.native.events=1'
  $hub_options     = '-role hub'
  $node_options    = "${server_options} -role node"
  $java            = 'java'
  $version         = '2.35.0'
  $default_hub     = 'http://localhost:4444/grid/register'

  case $::osfamily {
    'redhat': {}
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

}
