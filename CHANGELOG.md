Changelog
=========

## [0.2.0]

- Adding support for Packetbeat 6.0
-- Removing the `queue_size` class parameter, this setting has been removed from all beats
-- Removing unsupported sniffer type `pf_ring` from available `sniff_type` options
-- Adding new parameter `major_version` to install Packetbeat 6.0 from vendor repositories

## [0.1.1](https://github.com/corey-hammerton/puppet-packetbeat/tree/0.1.1)

- Fixing configuration file validation
- Adding new parameter `disable_config_test` to allow users to opt-out of syntax checking
- Optimizing data validation of class parameters
- Adding Puppet 5 support

## [0.1.0](https://github.com/corey-hammerton/puppet-packetbeat/tree/0.1.0)

- Initial release, review [module examples](https://github.com/corey-hammerton/puppet-packetbeat/blob/0.1.0/examples/init.pp) and [packetbeat documentation](https://www.elastic.co/guide/en/beats/packetbeat/current/index.html)
  for configuration options
