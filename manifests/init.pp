# == Class: selenium
#
#
# === Parameters
#
# Accepts no parameters.
#
#
# === Examples
#
#    class{ 'selenium': }
#
#
# === Authors
#
# Joshua Hoblitt <jhoblitt@cpan.org>
#
#
class selenium(
  $user         = $selenium::params::user,
  $group        = $selenium::params::group,
  $install_root = $selenium::params::install_root,
  $java         = $selenium::params::java,
  $version      = $selenium::params::version,
  $url          = undef,
) inherits selenium::params {
  validate_string($user)
  validate_string($group)
  validate_string($install_root)
  validate_string($java)
  validate_string($version)
  validate_string($url)

  include wget

  user { $user:
    gid => [$group],
  }
  group { $group: }

  $jar_name = "selenium-server-standalone-${version}.jar"

  if $url {
    $jar_url = $url
  } else {
    $jar_url = "https://selenium.googlecode.com/files/${jar_name}"
  }

  File {
    owner => $user,
    group => $group,
  }

  file { $install_root:
    ensure => directory,
  }

  $jar_path = "${install_root}/jars"
  $log_path = "${install_root}/log"

  file { $jar_path:
    ensure => directory,
  }

  file { $log_path:
    ensure => directory,
  }

  file { '/var/log/selenium':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => $log_path,
  }

  wget::fetch { 'selenium-server-standalone':
    source      => $jar_url,
    destination => "${jar_path}/${jar_name}",
    timeout     => 90,
    execuser    => $user,
    require     => File[$jar_path],
  }

}
