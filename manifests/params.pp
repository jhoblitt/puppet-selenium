# == Class: selenium::params
#
# This class should be considered private.
#
#
class selenium::params {
  $display          = ':0'
  $user             = 'selenium'
  $manage_user      = true
  $group            = $user
  $manage_group     = true
  $install_root     = '/opt/selenium'
  $server_options   = '-Dwebdriver.enable.native.events=1'
  $hub_options      = '-role hub'
  $node_options     = "${server_options} -role node"
  $java             = 'java'
  $version          = '2.45.0'
  $default_hub      = 'http://localhost:4444/grid/register'
  $download_timeout = '90'
  $default_classpath = []

  case $::osfamily {
    'redhat': {
      case $::operatingsystemmajrelease {
        6: {
          $initsystem = 'init.d'
          $service_template = 'redhat.selenium.erb'
        }
        default: {
          $initsystem = 'systemd'
          $service_template = 'selenium.erb'
        }
      }
    }
    'debian': {
      $service_template = 'debian.selenium.erb'
      $initsystem = 'init.d'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
