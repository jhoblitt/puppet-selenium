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
#   user             => 'selenium',
#   group            => 'selenium',
#   install_root     => '/opt/selenium',
#   java             => 'java',
#   version          => '2.39.0',
#   url              => undef,
#   download_timeout => '90',
# }
# ```
#
# #### `user`
#
# `String` defaults to: `selenium`
#
# The name/uid of the system role account to execute the server process under
# and will have ownership of files.
#
# #### `group`
#
# `String` defaults to: `selenium`
#
# The group/gid of the system role account and group ownership of files.
#
# #### `install_root`
#
# `String` defaults to: `/opt/selenium`
#
# The dirname under which Selenium Server files (including logs) will be
# created.
#
# #### `java`
#
# `String` defaults to: `java`
#
# The path of the `java` interpreter to use.
#
# #### `version`
#
# `String` defaults to: `2.39.0` (the latest release as of 2013-12-20)
#
# The version of Selenium Server to download.  Used to form the URL used to
# fetch the jar file.
#
# #### `url`
#
# `String` defaults to: `undef`
#
# If defined, `url` will be used to download the Selenium Server jar file.
# However, the `version` parameter just match the version of the downloaded
# file as this information is needed when starting up the server (this may
# change to be be automatically parsed from the `url` in a later release).
#
# #### `download_timeout`
#
# `String` defaults to: `90`
#
# Timeout to download of the package.
#
# === Authors
#
# Joshua Hoblitt <jhoblitt@cpan.org>
#
#
class selenium(
  $user             = $selenium::params::user,
  $group            = $selenium::params::group,
  $install_root     = $selenium::params::install_root,
  $java             = $selenium::params::java,
  $version          = $selenium::params::version,
  $url              = undef,
  $download_timeout = $selenium::params::download_timeout,
) inherits selenium::params {
  validate_string($user)
  validate_string($group)
  validate_string($install_root)
  validate_string($java)
  validate_string($version)
  validate_string($url)
  validate_string($download_timeout)

  include wget

  user { $user:
    gid    => $group,
  }
  group { $group:
    ensure => present,
  }

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
    mode => 0755,
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
    timeout     => $download_timeout,
    execuser    => $user,
    require     => File[$jar_path],
  }

  logrotate::rule { 'selenium':
    path          => $log_path,
    rotate_every  => 'weekly',
    missingok     => true,
    rotate        => 4,
    compress      => true,
    delaycompress => true,
    copytruncate  => true,
    minsize       => '100k',
  }

}
