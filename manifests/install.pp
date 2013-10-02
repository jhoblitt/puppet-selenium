# == Class: megaraid::lsiget
#
# installs the `lsiget` utility for LSI MegaRAID controllers
#
# See: http://mycusthelp.info/LSI/_cs/AnswerDetail.aspx?inc=8264
#
#
# === Parameters
#
# Accepts no parameters.
#
#
# === Examples
#
#    class{ 'megaraid::lsiget': }
#
#
# === Authors
#
# Joshua Hoblitt <jhoblitt@cpan.org>
#
#
class selenium::install(
  $version = '2.35.0',
  $url     = undef,
) {
  validate_string($version)
  validate_string($url)

  include wget

  user { $selenium::server::user:
    gid => [$selenium::server::group],
  }
  group { $selenium::server::group: }

  $jar_name = "selenium-server-standalone-${version}.jar"

  if $url {
    $jar_url = $url
  } else {
    $jar_url = "https://selenium.googlecode.com/files/${jar_name}"
  }

  File {
    owner => $selenium::server::user,
    group => $selenium::server::group,
  }

  file { $selenium::server::install_root:
    ensure => directory,
  }

  $jar_path = "${selenium::server::install_root}/jars"
  $log_path = "${selenium::server::install_root}/log"

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
    execuser    => $selenium::server::user,
    require     => File[$jar_path],
  }

}
