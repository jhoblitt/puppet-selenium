# == Class: selenium::hub
#
# Please refer to https://github.com/jhoblitt/puppet-selenium#seleniumhub for
# parameter documentation.
#
#
class selenium::hub(
  $options   = $selenium::params::hub_options,
  $port      = $selenium::params::default_port,
  $classpath = $selenium::params::default_classpath,
) inherits selenium::params {
  validate_string($options)

  include selenium

  anchor { 'selenium::hub::begin': } ->
  Class[ 'selenium' ] ->
  selenium::config{ 'hub':
    user         => $selenium::user,
    group        => $selenium::group,
    install_root => $selenium::install_root,
    options      => $options,
    port         => $port,
    java         => $selenium::java,
    classpath    => $classpath,
  } ->
  anchor { 'selenium::hub::end': }
}
