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
  $port         = $selenium::params::port,
  $jar_name     = $selenium::jar_name,
  $classpath    = $selenium::params::default_classpath,
) {
  validate_string($display)
  validate_string($user)
  validate_string($group)
  validate_string($install_root)
  validate_string($options)
  validate_string($java)
  validate_string($jar_name)
  validate_array($classpath)

  # prog is the 'name' of the init.d script.
  $prog = "selenium${name}"

  case $::osfamily {
    'debian': {
      ensure_packages(['daemon'])
      Package['daemon'] -> File[$prog]
    }
    default : {}
  }

  $selenium_jar_file = "${install_root}/jars/${jar_name}"
  $exec_command = size($classpath) ? {
    0       => "-jar ${selenium_jar_file}",
    default => inline_template("-cp ${selenium_jar_file}:<%= @classpath.join(':') %> org.openqa.grid.selenium.GridLauncher")
  }

  file { $prog:
    ensure  => 'file',
    path    => "/etc/init.d/${prog}",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/init.d/${selenium::params::service_template}"),
  } ~>
  service { $prog:
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }

}
