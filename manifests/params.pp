# == Class: selenium::params
#
# This class should be considered private.
#
#
class selenium::params {
  $user         = 'selenium'
  $group        = $user
  $install_path = '/opt/selenium'

  case $::osfamily {
    'redhat': {}
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

}
