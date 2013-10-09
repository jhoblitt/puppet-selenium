# == Class: selenium::node
#
# === Parameters
#
# ```puppet
# # defaults
# class { 'selenium::node':
#   display => ':0',
#   options => '-Dwebdriver.enable.native.events=1 -role node',
#   hub     => 'http://localhost:4444/grid/register',
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
# Options passed to Selenium Server Node at startup.
#
# defaults to: `-Dwebdriver.enable.native.events=1 -role node`
#
# #### `hub`
#
# `String`
#
# The URL of the Selenium Server Hub to connect to.
#
# defaults to: `http://localhost:4444/grid/register`
#
#
# === Authors
#
# Joshua Hoblitt <jhoblitt@cpan.org>
#
#
class selenium::node(
  $display = $selenium::params::display,
  $options = $selenium::params::node_options,
  $hub     = $selenium::params::default_hub,
) inherits selenium::params {
  validate_string($display)
  validate_string($options)
  validate_string($hub)

  include selenium

  $safe_options = "${options} -hub ${hub}"

  anchor { 'selenium::node::begin': } ->
  Class[ 'selenium' ] ->
  selenium::config{ 'node':
    display      => $display,
    user         => $selenium::user,
    group        => $selenium::group,
    install_root => $selenium::install_root,
    options      => $safe_options,
    java         => $selenium::java,
  } ->
  anchor { 'selenium::node::end': }
}
