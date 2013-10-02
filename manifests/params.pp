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
  $default_options = '-Dwebdriver.enable.native.events=1'
  $java            = 'java'

  case $::osfamily {
    'redhat': {}
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

}
