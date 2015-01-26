# == Class: selenium
#
# Please refer to https://github.com/jhoblitt/puppet-selenium#selenium for
# parameter documentation.
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
    gid        => $group,
    managehome => true,
  }
  group { $group:
    ensure => present,
  }

  $jar_name     = "selenium-server-standalone-${version}.jar"
  $path_version = regsubst($version, '^(\d+\.\d+)\.\d+$', '\1')

  if $url {
    $jar_url = $url
  } else {
    $variant = "${path_version}/${jar_name}"
    $jar_url = "https://selenium-release.storage.googleapis.com/${variant}"
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
    mode   => '0755',
  }

  file { '/var/log/selenium':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => $log_path,
  }

  wget::fetch { 'selenium-server-standalone':
    source             => $jar_url,
    destination        => "${jar_path}/${jar_name}",
    timeout            => $download_timeout,
    execuser           => $user,
    require            => File[$jar_path],
    nocheckcertificate => true,
  }

  logrotate::rule { 'selenium':
    path          => $log_path,
    rotate_every  => 'weekly',
    missingok     => true,
    rotate        => '4',
    compress      => true,
    delaycompress => true,
    copytruncate  => true,
    minsize       => '100k',
  }

}
