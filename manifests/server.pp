# == Class: selenium::server
#
# === Parameters
#
# ```puppet
# # defaults
# class { 'selenium::server':
#   display => ':0',
#   options => '-Dwebdriver.enable.native.events=1',
# }
# ```
#
# #### `display`
#
# `String`
#
# The name of the `X` display to render too.  This is set as an environment
# variable passed to Selenium Server
#
# defaults to: `:0`
#
# #### `options`
#
# `String`
#
# Options passed to Selenium Server at startup.
#
# defaults to: `-Dwebdriver.enable.native.events=1`
#
#
# === Authors
#
# Joshua Hoblitt <jhoblitt@cpan.org>
#
#
class selenium::server(
  $display = $selenium::params::display,
  $options = $selenium::params::server_options,
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
  } ->
  anchor { 'selenium::server::end': }
}
