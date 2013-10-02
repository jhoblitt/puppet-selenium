# == Class: selenium::config
#
# This class should be considered private.
#
#
# === Parameters
#
# Accepts no parameters.
#
#
# === Examples
#
#    class{ 'selenium::config': }
#
#
# === Authors
#
# Joshua Hoblitt <jhoblitt@cpan.org>
#
#
class selenium::config {

  $options = '-Dwebdriver.enable.native.events=1'
  $prog    = 'selenium'

  file { '/etc/init.d/selenium':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/init.d/selenium.erb"),
  }

}
