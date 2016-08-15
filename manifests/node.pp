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
  $classpath = $selenium::params::default_classpath,
  $initsystem = $selenium::params::initsystem,
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
    options      => "${safe_options} -log ${selenium::install_root}/log/seleniumnode.log",
    java         => $selenium::java,
    classpath    => $classpath,
    initsystem   => $initsystem,
  } ->
  anchor { 'selenium::node::end': }
}
