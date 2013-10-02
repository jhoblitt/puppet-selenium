# == Define: selenium::config
#
# This define should be considered private.
#
# Note that selenium::params && selnenium::install must be included in the
# manifest before this define may be used.
#
# === Parameters
#
# Accepts no parameters.
#
#
# === Examples
#
#    selenium::config{ 'seleniumstandalone': }
#
#
# === Authors
#
# Joshua Hoblitt <jhoblitt@cpan.org>
#
#
define selenium::config(
  $display      = $selenium::params::display,
  $user         = $selenium::params::user,
  $group        = $selenium::params::group,
  $install_root = $selenium::params::install_root,
  $options      = $selenium::params::default_options,
  $java         = $selenium::params::java,
  $jar_name     = $selenium::install::jar_name,
) {
  validate_string($display)
  validate_string($user)
  validate_string($group)
  validate_string($install_root)
  validate_string($options)
  validate_string($java)

  # prog is the 'name' of the init.d script.
  $prog     = $name

  file { "/etc/init.d/${prog}":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/init.d/selenium.erb"),
  }

}
