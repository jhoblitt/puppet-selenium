Puppet selenium Module
=========================

[![Build Status](https://travis-ci.org/jhoblitt/puppet-selenium.png)](https://travis-ci.org/jhoblitt/puppet-selenium)

#### Table of Contents

1. [Overview](#overview)
2. [Description](#description)
3. [Usage](#usage)
    * [Simple](#simple)
    * [Files](#files)
    * [`selenium`](#selenium)
    * [`selenium::server`](#selenium--server)
    * [`selenium::hub`](#selenium--hub)
    * [`selenium::node`](#selenium--node)
4. [Why Another Module?](#why-another-module)
5. [Limitations](#limitations)
    * [Tested Platforms](#tested-platforms)
6. [Support](#support)


Overview
--------

Manages Selenium Server 2 - Standalone and Grid

Description
-----------

This is a puppet module for installation and configuration of the [Selenium
Server](http://docs.seleniumhq.org/docs/07_selenium_grid.jsp) 2 browser
automation package.  Support is provided for configuring Selenium Server in
`standalone` mode along with the grid modes of `hub` and `node`.

The design intent of this module is to only manage Selenium server and not any
of the other packages that might be required to required to create a selenium
server [role](http://www.craigdunn.org/2012/05/239/).

Usage
-----

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

### Files

Unless class `selenium` has `$install_root` changed from the default, these files paths will be used.  Note that the log files and init scripts are only created for the relevant configured service.

The log files will have the mode `0644` so that they can be inspected by users
other than the selenium role account.

```
/opt/selenium
|-- jars
|   `-- selenium-server-standalone-2.35.0.jar
`-- log
    |-- hub_stderr.log
    |-- hub_stdout.log
    |-- node_stderr.log
    |-- node_stdout.log
    |-- server_stderr.log
    `-- server_stdout.log
/etc/init.d/seleniumhub
/etc/init.d/seleniumnode
/etc/init.d/seleniumserver
```

### `selenium`

This class controls common configuration values used by the
`selenium::{server,hub,node}` classes.  It is automatically included in the
manifest by those classes and it need not be explicitly declared except to
override the default values.

```puppet
# defaults
class { 'selenium':
  user         => 'selenium',
  group        => 'selenium',
  install_root => '/opt/selenium',
  java         => 'java',
  version      => '2.35.0',
  url          => undef,
}
```

#### `user`

`String`

The name/uid of the system role account to execute the server process under and
will have ownership of files.

defaults to: `selenium`

#### `group`

`String`

The group/gid of the system role account and group ownership of files.

defaults to: `selenium`

#### `install_root`

`String`

The dirname under which Selenium Server files (including logs) will be created.

defaults to: `/opt/selenium`

#### `java`

`String`

The path of the `java` interpreter to use.

defaults to: `java`

#### `version`

`String`

The version of Selenium Server to download.  Used to form the URL used to fetch the jar file.

defaults to: `2.35.0` (the latest release as of 2013-10-08)

#### `url`

`String`

If defined, `url` will be used to download the Selenium Server jar file.  However, the `version` parameter just match the version of the downloaded file as this information is needed when starting up the server (this may change to be be automatically parsed from the `url` in a later release).

defaults to: `undef`

### `selenium::server`

```puppet
# defaults
class { 'selenium::server':
  display => ':0',
  options => '-Dwebdriver.enable.native.events=1',
}
```

#### `display`

`String`

The name of the `X` display to render too.  This is set as an environment
variable passed to Selenium Server

defaults to: `:0`

#### `options`

`String`

Options passed to Selenium Server at startup.

defaults to: `-Dwebdriver.enable.native.events=1`

### `selenium::hub`

Note that by default `selenium::server` and `selenium::hub` will try to listen
on the same TCP port (`4444`) and only one of them will be able to function.

```puppet
# defaults
class { 'selenium::hub':
  display => ':0',
  options => '-Dwebdriver.enable.native.events=1',
}
```

#### `options`

`String`

Options passed to Selenium Server Hub at startup.

defaults to: `-role hub`

### `selenium::node`

```puppet
# defaults
class { 'selenium::node':
  display => ':0',
  options => '-Dwebdriver.enable.native.events=1 -role node',
  hub     => 'http://localhost:4444/grid/register',
}
```

#### `display`

`String`

The name of the `X` display to render too.  This is set as an environment
variable passed to Selenium Server

defaults to: `:0`

#### `options`

`String`

Options passed to Selenium Server Node at startup.

defaults to: `-Dwebdriver.enable.native.events=1 -role node`

#### `hub`

`String`

The URL of the Selenium Server Hub to connect to.

defaults to: `http://localhost:4444/grid/register`


Why Another Module?
-------------------

At the time work on this module was started, there were no other Selenium
Server modules published on the Puppet Forge.  A number of existing modules
were identified on github but none of them fit the authors needs of:

* Allowing the external setup of things like `Xvfb`, `java`, etc.
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


Support
-------

Please log tickets and issues at
[github](https://github.com/jhoblitt/puppet-selenium/issues)

See Also
--------

* [Selenium](http://docs.seleniumhq.org/)
