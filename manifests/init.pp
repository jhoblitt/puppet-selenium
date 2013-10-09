# == Class: selenium
#
# === Parameters
#
# This class controls common configuration values used by the
# `selenium::{server,hub,node}` classes.  It is automatically included in the
# manifest by those classes and it need not be explicitly declared except to
# override the default values.
#
# ```puppet
# # defaults
# class { 'selenium':
#   user         => 'selenium',
#   group        => 'selenium',
#   install_root => '/opt/selenium',
#   java         => 'java',
#   version      => '2.35.0',
#   url          => undef,
# }
# ```
#
# #### `user`
#
# `String`
#
# The name/uid of the system role account to execute the server process under
# and will have ownership of files.
#
# defaults to: `selenium`
#
# #### `group`
#
# `String`
#
# The group/gid of the system role account and group ownership of files.
#
# defaults to: `selenium`
#
# #### `install_root`
#
# `String`
#
# The dirname under which Selenium Server files (including logs) will be
# created.
#
# defaults to: `/opt/selenium`
#
# #### `java`
#
# `String`
#
# The path of the `java` interpreter to use.
#
# defaults to: `java`
#
# #### `version`
#
# `String`
#
# The version of Selenium Server to download.  Used to form the URL used to
# fetch the jar file.
#
# defaults to: `2.35.0` (the latest release as of 2013-10-08)
#
# #### `url`
#
# `String`
#
# If defined, `url` will be used to download the Selenium Server jar file.
# However, the `version` parameter just match the version of the downloaded
# file as this information is needed when starting up the server (this may
# change to be be automatically parsed from the `url` in a later release).
#
# defaults to: `undef`
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
