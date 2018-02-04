# Changelog

All notable changes to this project will be documented in this file

## [0.2.0]

* Adding support for Packetbeat 6.0
** Removing unsupported sniffer type `pf_ring` from available `sniff_type` options
** Adding new parameter `major_version` to allow installation of 6.x packages from vendor
** Adding new optional parameter `queue` to configure internal queue settings
* Parameter `queue_size` is only applicable if `major_version` is '5'

## [0.1.1](https://github.com/corey-hammerton/puppet-packetbeat/tree/0.1.1)

This is a bug fix release with support for Puppet 5

**Added**
* Puppet 5 support
* Parameter `disable_config_test`, enabling users to opt-out of configuration file validation

**Bug Fixes**
* Packetbeat configuration file validation

**Misc**
* Replacing Pattern type parameters that allow specific values with Enum

## [0.1.0](https://github.com/corey-hammerton/puppet-packetbeat/tree/0.1.0)

Initial release, review module and [documentation](https://www.elastic.co/guide/en/beats/packetbeat/current/index.html) for configuration options

**Added**

**Bug Fixes**

**Misc**
