# == Class: selenium
#
# Please refer to https://github.com/jhoblitt/puppet-selenium#selenium for
# parameter documentation.
#
#
class selenium(
  $user               = $selenium::params::user,
  $manage_user        = $selenium::params::manage_user,
  $group              = $selenium::params::group,
  $manage_group       = $selenium::params::manage_group,
  $install_root       = $selenium::params::install_root,
  $java               = $selenium::params::java,
  $version            = $selenium::params::version,
  $url                = undef,
  $download_timeout   = $selenium::params::download_timeout,
  $nocheckcertificate = false,
  $manage_logrotate   = true,
  $package            = undef,
) inherits selenium::params {
  validate_string($user)
  validate_string($group)
  validate_string($install_root)
  validate_string($java)
  validate_string($version)
  validate_string($url)
  validate_string($download_timeout)
  validate_bool($nocheckcertificate)
  validate_bool($manage_logrotate)
  validate_string($package)

  include wget

  if $manage_user {
    user { $user:
      gid        => $group,
      system     => true,
      managehome => true,
      home       => '/var/lib/selenium'
    }
  }

  if $manage_group {
    group { $group:
      ensure => present,
      system => true,
    }
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

  if $package != undef {

    package {$package:
      ensure => installed,
    }

  } else {

    if (!defined(Package['wget'])) {
      package {'wget':
        ensure => installed,
      }
    }

    if $nocheckcertificate {
      $_nocheckcertificate = '--no-check-certificate'
    } else {
      $_nocheckcertificate = ''
    }

    exec {'fetch selenium-server-standalone':
      path    => '/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
      user    => $user,
      command => "wget -T ${download_timeout} ${_nocheckcertificate} -O ${jar_path}/${jar_name} ${jar_url}",
      creates => "${jar_path}/${jar_name}",
      require => [File[$jar_path], Package['wget']],
    }

  }

  if $manage_logrotate {
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

}
