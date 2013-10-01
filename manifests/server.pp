# == Class: selenium::server
#
# simple template
#
# === Examples
#
# include selenium::server
#
class selenium::server(
  $user         = $selenium::params::user,
  $group        = $selenium::params::group,
  $install_path = $selenium::params::install_path,
) inherits selenium::params {
  validate_string($user) 
  validate_string($group)
  validate_string($install_path)

  user { $user:
    gid => [$group],
  }
  group { $group: }

  class { 'selenium::install': } ->
  class { 'selenium::config': } ->
  class { 'selenium::service': } ->
  Class[ 'selenium::server' ]

}
