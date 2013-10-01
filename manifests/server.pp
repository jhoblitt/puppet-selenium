# == Class: selenium::server
#
# simple template
#
# === Examples
#
# include selenium::server
#
class selenium::server(
  $user  = $selenium::params::user,
  $group = $selenium::params::group,
) inherits selenium::params {
  validate_string($user)
  validate_string($group)

  user { $user:
    managehome => true,
    gid        => [$group],
  }
  group { $group: }

}
