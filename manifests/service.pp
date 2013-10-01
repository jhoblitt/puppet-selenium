# == Class: selenium::service
#
# This class controls the selenium daemon / system service.
#
#
# === Parameters
#
# Accepts no parameters.
#
#
# === Examples
#
#    class{ 'selenium::service': }
#
#
# === Authors
#
# Joshua Hoblitt <jhoblitt@cpan.org>
#
#
class selenium::service inherits selenium::server {

  service { 'selenium':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }

}
