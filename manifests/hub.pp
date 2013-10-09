# == Class: selenium::hub
#
# === Parameters
#
# Note that by default `selenium::server` and `selenium::hub` will try to
# listen on the same TCP port (`4444`) and only one of them will be able to
# function.
#
# ```puppet
# # defaults
# class { 'selenium::hub':
#   options => '-role hub',
# }
# ```
#
# #### `options`
#
# `String`
#
# Options passed to Selenium Server Hub at startup.
#
# defaults to: `-role hub`
#
#
# === Authors
#
# Joshua Hoblitt <jhoblitt@cpan.org>
#
#
class selenium::hub(
  $options = $selenium::params::hub_options,
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
    java         => $selenium::java,
  } ->
  anchor { 'selenium::hub::end': }
}
