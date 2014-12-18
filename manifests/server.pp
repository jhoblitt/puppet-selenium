# == Class: selenium::server
#
# Please refer to https://github.com/jhoblitt/puppet-selenium#seleniumserver
# for parameter documentation.
#
#
class selenium::server(
  $display    = $selenium::params::display,
  $options    = $selenium::params::server_options,
  $initsystem = $selenium::params::initsystem,
) inherits selenium::params {
  validate_string($display)
  validate_string($options)

  include selenium

  anchor { 'selenium::server::begin': } ->
  Class[ 'selenium' ] ->
  selenium::config{ 'server':
    display      => $display,
    user         => $selenium::user,
    group        => $selenium::group,
    install_root => $selenium::install_root,
    options      => $options,
    java         => $selenium::java,
    initsystem   => $initsystem,
  } ->
  anchor { 'selenium::server::end': }
}
