Puppet selenium Module
======================

[![Build Status](https://travis-ci.org/jhoblitt/puppet-selenium.png)](https://travis-ci.org/jhoblitt/puppet-selenium)

#### Table of Contents

1. [Overview](#overview)
2. [Description](#description)
3. [Usage](#usage)
    * [Simple](#simple)
    * [Example "profiles/roles"](#example-profilesroles)
    * [Files](#files)
    * [Classes](#classes)
        * [`selenium`](#selenium)
        * [`selenium::server`](#seleniumserver)
        * [`selenium::hub`](#seleniumhub)
        * [`selenium::node`](#seleniumnode)
4. [Why Another Module?](#why-another-module)
5. [Limitations](#limitations)
    * [Tested Platforms](#tested-platforms)
6. [Versioning](#versioning)
7. [Support](#support)
8. [See Also](#see-also)


Overview
--------

Manages Selenium Server 2 - Standalone and Grid

Description
-----------

This is a puppet module for installation and configuration of the [Selenium
Server](http://docs.seleniumhq.org/docs/07_selenium_grid.jsp) 2 browser
automation package.  Support is provided for configuring Selenium Server in
`standalone` mode or as a `Selenium grid` with composed of the `hub` and `node`
modes.

The design intent of this module is to only manage Selenium server and not any
of the other packages that might be required to required to create a selenium
server [profile/role](http://www.craigdunn.org/2012/05/239/).

Usage
-----

The `selenium::server` class is used to setup a `standalone` Selenium instance
to allow the use of a single server as a test node. The `selenium::hub` class
acts as a proxy in front of one or more `selenium::node` instances. A hub +
node(s) setup is refered to as a `Selenium grid`. Running `selenium::server` is
similar to creating a `Selenium grid` by declaring `selenium::hub` and
`selenium::node` on the same host.

It is highly recommend that you read the [Selenium Grid
documentation](http://docs.seleniumhq.org/docs/07_selenium_grid.jsp#what-is-selenium-grid)
to determine what the best approach for your usage case(s) is. 

### Simple

Stand alone server setup with display `:99` (default is `:0`).

```puppet
class { 'selenium::server': display => ':99' }
```

Grid in a box setup with the Selenium `node` talking to the `hub` via
`127.0.0.1`.

```puppet
class { 'selenium::hub': }
class { 'selenium::node': }
```

### Example "profiles"/"roles"

Here are some examples "profiles" and "roles" based on Craig Dunn's blog post
on [Designing Puppet – Roles and Profiles.](http://www.craigdunn.org/2012/05/239/).

These examples assume the presence of these two modules in your Puppet
environment.

 * [`puppetlabs-java`](https://github.com/puppetlabs/puppetlabs-java)
 * [`p0deje/display`](https://github.com/p0deje/puppet-display)

#### Selenium Server Profile

```puppet
class mysite::profile::seleniumserver {
  include java

  # WSXGA+ 1680x1050 -- should nicely fit on a 1920x1280 screen
  class { 'display':
    width  => 1680,
    height => 1050,
  } ->
  class { 'selenium::server': }

  Class['java'] -> Class['selenium::server']
}
```

#### Selenium Hub Profile

```puppet
class mysite::profile::seleniumhub {
  include java

  class { 'selenium::hub': }

  Class['java'] -> Class['selenium::hub']
}
```

#### Selenium Node Profile

```puppet
class mysite::profile::seleniumnode {
  include java

  # WSXGA+ 1680x1050 -- should nicely fit on a 1920x1280 screen
  class { 'display':
    width  => 1680,
    height => 1050,
  } ->
  class { 'selenium::node':
    # If your intending to have node(s) that don't sit on the same system as
    # the hub, you need to point the node at a hub by passing in the hub's url
    # in or using an exported resource from the hub system. Eg.
    # hub => 'http://<myseleniumhub>:4444/grid/register',
  }

  Class['java'] -> Class['selenium::node']
}

```

#### Selenium Server Role

```puppet
class mysite::role::seleniumserver {
  include mysite::profile::seleniumserver
}
```

#### Selenium Hub Role

```puppet
class mysite::role::seleniumhub {
  include mysite::profile::seleniumhub
  include mysite::profile::seleniumnode
}
```

### Files

Unless class `selenium` has `$install_root` changed from the default, these
files paths will be used.  Note that the log files and init scripts are only
created for the relevant configured service.

The log files are set to mode `0644`, so that they can be inspected by users
other than the selenium role account.

```
/opt/selenium
|-- jars
|   `-- selenium-server-standalone-x.xx.x.jar
`-- log
    |-- hub_stderr.log
    |-- hub_stdout.log
    |-- node_stderr.log
    |-- node_stdout.log
    |-- server_stderr.log
    `-- server_stdout.log
/var/log/selenium -> /opt/selenium/log
/etc/init.d/seleniumhub
/etc/init.d/seleniumnode
/etc/init.d/seleniumserver
```

### Classes

#### `selenium`

This class controls common configuration values used by the
`selenium::{server,hub,node}` classes.  It is automatically included in the
manifest by those classes and it need not be explicitly declared except to
override the default values.

```puppet
# defaults
class { 'selenium':
  user             => 'selenium',
  group            => 'selenium',
  install_root     => '/opt/selenium',
  java             => 'java',
  version          => '2.42.1',
  url              => undef,
  download_timeout => '90',
}
```

##### `user`

`String` defaults to: `selenium`

The name/uid of the system role account to execute the server process under and
will have ownership of files.

##### `group`

`String` defaults to: `selenium`

The group/gid of the system role account and group ownership of files.

##### `install_root`

`String` defaults to: `/opt/selenium`

The dirname under which Selenium Server files (including logs) will be
created.

##### `java`

`String` defaults to: `java`

The path of the `java` interpreter to use.

##### `version`

`String` defaults to: `2.42.1` (the latest release as of 2014-05-31)

The version of Selenium Server to download.  Used to form the URL used to fetch
the jar file.

##### `url`

`String` defaults to: `undef`

If defined, `url` will be used to download the Selenium Server jar file.
However, the `version` parameter just match the version of the downloaded file
as this information is needed when starting up the server (this may change to
be be automatically parsed from the `url` in a later release).

##### `download_timeout`

`String` defaults to: `90`

Timeout to download of the package.

#### `selenium::server`

```puppet
# defaults
class { 'selenium::server':
  display    => ':0',
  options    => '-Dwebdriver.enable.native.events=1',
  initsystem => 'sysv',
}
```

##### `display`

`String` defaults to: `:0`

The name of the `X` display to render too.  This is set as an environment
variable passed to Selenium Server

##### `options`

`String` defaults to: `-Dwebdriver.enable.native.events=1`

Options passed to Selenium Server at startup.

##### `initsystem`

`String` defaults to: `sysv`

Possible values are `systemd` and `sysv`.
Creates and uses sysv init scripts or new systemd scripts.

#### `selenium::hub`

Note that by default `selenium::server` and `selenium::hub` will try to listen
on the same TCP port (`4444`) and only one of them will be able to function.

```puppet
# defaults
class { 'selenium::hub':
  options    => '-role hub',
  initsystem => 'sysv',
}
```

##### `options`

`String` defaults to: `-role hub`

Options passed to Selenium Server Hub at startup.

##### `initsystem`

`String` defaults to: `sysv`

Possible values are `systemd` and `sysv`.
Creates and uses sysv init scripts or new systemd scripts.

#### `selenium::node`

```puppet
# defaults
class { 'selenium::node':
  display => ':0',
  options => '-Dwebdriver.enable.native.events=1 -role node',
  hub     => 'http://localhost:4444/grid/register',
}
```

##### `display`

`String` defaults to: `:0`

The name of the `X` display to render too.  This is set as an environment
variable passed to Selenium Server

##### `options`

`String` defaults to: `-Dwebdriver.enable.native.events=1 -role node`

Options passed to Selenium Server Node at startup.

##### `hub`

`String` defaults to: `http://localhost:4444/grid/register`

The URL of the Selenium Server Hub to connect to.

##### `initsystem`

`String` defaults to: `sysv`

Possible values are `systemd` and `sysv`.
Creates and uses sysv init scripts or new systemd scripts.


Why Another Module?
-------------------

At the time work on this module was started, there were no other Selenium
Server modules published on the Puppet Forge.  A number of existing modules
were identified on github but none of them fit the author's needs of:

 * Allowing the external setup of things like `Xvfb`, `java`, etc. and to allow
   the composition of site specific profiles/roles.
 * Supporting a mixed environment of Scientific, Centos, and RedHat Linux
   (basically `$::osfamily == 'RedHat'`
 * Enough `rspec-puppet` coverage to prevent regressions

The later is the most important issue.  Attempting to add additional
`$::operatingsystem/$::osfamily` support to a puppet module without
`rspec-puppet` tests is a process fraught with peril.

The modules that were identified were:

 * [adamgoucher/selenium-puppet](https://github.com/adamgoucher/selenium-puppet)
    - Mostly aimed at Windows but with some Linux/POSIX support
    - no `rspec-puppet` tests (deal breaker)
 * [StoryIQ/puppet-selenium-grid](https://github.com/StoryIQ/puppet-selenium-grid)
    - Debian only
    - no `rspec-puppet` tests (deal breaker)
 * [kayakco/puppet-selenium](https://github.com/kayakco/puppet-selenium)
    - Unreleased deps (deal breaker)
    - Very role like with lots of magic setup (deal breaker)
    - debian-ish (may support Centos)
    - Doesn't appear to be in a ready state


Limitations
-----------

At present, only support for `$::osfamily == 'RedHat'` has been implemented.
Adding other Linux distributions will required the addition of platform
specific init scripts.

### Tested Platforms

 * el6.x
 * Fedora 21

Versioning
----------

This module is versioned according to the [Semantic Versioning
2.0.0](http://semver.org/spec/v2.0.0.html) specification.


Support
-------

Please log tickets and issues at
[github](https://github.com/jhoblitt/puppet-selenium/issues)


See Also
--------

 * [Selenium](http://docs.seleniumhq.org/)
 * [Designing Puppet – Roles and Profiles.](http://www.craigdunn.org/2012/05/239/)
 * [`puppetlabs-java`](https://github.com/puppetlabs/puppetlabs-java)
 * [`p0deje/display`](https://github.com/p0deje/puppet-display)
 * [`maestrodev/wget`](https://github.com/maestrodev/puppet-wget)
 * [`rodjek/logrotate`](https://github.com/rodjek/puppet-logrotate)
