# == Class: selenium::server
#
# simple template
#
# === Examples
#
# include selenium::server
#
class selenium::server(
  $display      = $selenium::params::display,
  $user         = $selenium::params::user,
  $group        = $selenium::params::group,
  $install_root = $selenium::params::install_root,
  $options      = $selenium::params::default_options,
  $java         = $selenium::params::java,
) inherits selenium::params {
  validate_string($display)
  validate_string($user)
  validate_string($group)
  validate_string($install_root)
  validate_string($options)
  validate_string($java)

  class { 'selenium::install': } ->
  selenium::config{ 'seleniumstandalone':
    display      => $display,
    user         => $user,
    group        => $group,
    install_root => $install_root,
    java         => $java,
  } ->
  class { 'selenium::service': } ->
  Class[ 'selenium::server' ]

}
