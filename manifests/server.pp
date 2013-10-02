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
  $options      = $selenium::params::server_options,
) inherits selenium::params {
  validate_string($display)
  validate_string($options)

  include selenium

  Class[ 'selenium' ] ->
  selenium::config{ 'seleniumstandalone':
    display      => $display,
    user         => $selenium::user,
    group        => $selenium::group,
    install_root => $selenium::install_root,
    options      => $options,
    java         => $selenium::java,
  } ->
  class { 'selenium::service': } ->
  Class[ 'selenium::server' ]

}
