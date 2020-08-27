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
  $server_options   = ''
  $server_jvm_args  = '-Dwebdriver.enable.native.events=1'
  $hub_options      = '-role hub'
  $hub_jvm_args     = ''
  $node_options     = '-role node'
  $node_jvm_args    = $server_jvm_args
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
        }
        2018: {
          $initsystem = 'init.d'
        }
        default: {
          $initsystem = 'systemd'
        }
      }
    }
    'debian': {
      $initsystem = 'init.d'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
