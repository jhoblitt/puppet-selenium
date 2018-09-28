# == Class: selenium::node
#
# Please refer to https://github.com/jhoblitt/puppet-selenium#seleniumnode for
# parameter documentation.
#
#
class selenium::node(
  $display   = $selenium::params::display,
  $options   = $selenium::params::node_options,
  $hub       = $selenium::params::default_hub,
  $port      = $selenium::params::default_port,
  $classpath = $selenium::params::default_classpath,
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
    port         => $port,
    java         => $selenium::java,
    classpath    => $classpath
  } ->
  anchor { 'selenium::node::end': }
}
