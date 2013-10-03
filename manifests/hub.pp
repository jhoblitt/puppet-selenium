# == Class: selenium::hub
#
# simple template
#
#
# === Examples
#
# include selenium::hub
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
