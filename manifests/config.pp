# == Define: selenium::config
#
# This define should be considered private.
#
define selenium::config(
  $display      = $selenium::params::display,
  $user         = $selenium::params::user,
  $group        = $selenium::params::group,
  $install_root = $selenium::params::install_root,
  $options      = $selenium::params::server_options,
  $java         = $selenium::params::java,
  $jar_name     = $selenium::jar_name,
  $initsystem   = $selenium::params::initsystem,
) {
  validate_string($display)
  validate_string($user)
  validate_string($group)
  validate_string($install_root)
  validate_string($options)
  validate_string($java)
  validate_string($jar_name)
  validate_re($initsystem, '^(sysv|systemd)$')

  # prog is the 'name' of the init.d script.
  $prog = "selenium${name}"

  case $initsystem {
    'systemd' : {
      file { "/usr/lib/systemd/system/${prog}.service":
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template("${module_name}/systemd/selenium.erb"),
        notify  => Service[$prog],
      }

      file { "/etc/${prog}.conf":
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template("${module_name}/systemd/conf.erb"),
        notify  => Service[$prog],
      }
    }
    default  : {
      file { "/etc/init.d/${prog}":
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template("${module_name}/init.d/selenium.erb"),
        notify  => Service[$prog],
      }
    }
  }

  service { $prog:
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }

}
