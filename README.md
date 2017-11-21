# packetbeat

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with packetbeat](#setup)
    * [What packetbeat affects](#what-packetbeat-affects)
    * [Beginning with packetbeat](#beginning-with-packetbeat)
1. [Usage - Configuration options and additional functionality](#usage)
    * [Processors](#processors)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Public Classes](#public-classes)
    * [Private Classes](#private-classes)
1. [Limitations - OS compatibility, etc.](#limitations)
    * [Major Versions](#major-versions)
1. [Development - Guide for contributing to the module](#development)
    * [Testing](#testing)

## Description

The `packetbeat` module installs the [packetbeat network packet analyzer](https://www.elastic.co/guide/en/beats/packetbeat/current/index.html) maintained by elastic.

## Setup

### What packetbeat affects 

By default `packetbeat` adds a software repository to your system and installs packetbeat
along with the required configurations.

### Beginning with packetbeat

`packetbeat` requires the `protocols` and `outputs` parameters to be declared, without which
the service does nothing.

```puppet
class{'packetbeat':
  protocols => {
    'icmp' => {
      'enabled' => true,
    },
  },
  outputs   => {
    'elasticsearch' => {
      'hosts' => ['localhost:9200'],
    },
  }
}
```

## Usage

As of this writing all the default values follow the upstream values. This module saves all configuration
options in a `to_yaml()` fashion, therefore multiple instances of the same protocol are not possible.

To ship HTTP traffic to [elasticsearch](https://www.elastic.co/guide/en/beats/packetbeat/current/elasticsearch-output.html)
```puppet
class{'packetbeat':
  protocols => {
    'http' => {
      'ports' => [80]
    }
  },
  outputs   => {
    'elasticsearch' => {
      'hosts' => ['localhost:9200']
    }
  }
}
```

To ship MySQL traffic through [logstash](https://www.elastic.co/guide/en/beats/packetbeat/current/logstash-output.html)
```puppet
class{'packetbeat':
  protocols => {
    'mysql' => {
      'ports' => [3306]
    }
  },
  outputs   => {
    'logstash' => {
      'hosts' => ['localhost:5044'],
      'index' => 'packetbeat'
    }
  }
}
```

[Network device configuation](https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-interfaces.html) and [logging](https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-logging.html) can be configured the same way. Please review the documentation of the [elastic website](https://www.elastic.co/guide/en/beats/packetbeat/current/index.html)

### Processors

Libbeat 5.0 and later include a feature for filtering/enhancing exported data
called [processors](https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-processors.html).
These may be added into the configuration by populating the `processors` parameter
and may apply to all events or those that match certain conditions.

To drop events that have an http response code between 200 and 299
```puppet
class{'packetbeat':
  processors => [
    {
      'drop_event' => {
        'when' => {
          'http.response.code.gte' => 200,
          'http.response.code.lt'  => 300
        }
      }
    }
  ],
  ...
}
```

To drop the `mysql.num_fields` field from the output
```puppet
class{'packetbeat':
  processors => [
    {
      'drop_field' => {
        'fields' => 'mysql.num_fields'
      }
    }
  ]
}
```

For more information please review the [documentation](https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-processors.html)

## Reference
 - [**Public Classes**](#public-classes)
    - [Class: packetbeat](#class-packetbeat)
 - [**Private Classes**](#private-classes)
    - [Class: packetbeat::config](#class-packetbeatconfig)
    - [Class: packetbeat::install](#class-packetbeatinstall)
    - [Class: packetbeat::repo](#class-packetbeatrepo)
    - [Class: packetbeat::service](#class-packetbeatservice)

### Public Classes

#### Class: `packetbeat`

Installs and configures packetbeat.

**Parameters within `packetbeat`**
- `outputs`: [Hash] The required outputs section of the configuration.
- `protocols`: [Hash] The required protocols section of the configuration.
- `ensure`: [String] Valid values are 'present' and 'absent'. Determines weather
  to manage all required resources or remove them from the node. (default: 'present')
- `beat_name`: [String] The name of the beat shipper (default: hostname)
- `bpf_filter`: [String] Overwrite packetbeat's automatically generated `BPF` with
  this value. This setting is only available if `type` is configured for
  'af_packet'. NOTE: It is the responsibility of the user to ensure this is
  in-sync with the protocols.
- `buffer_size_mb`: [Integer] The maximum size of the shared memory buffer to
  use between the kernel and user-space. This setting is only available if `type`
  is configured for 'af_packet'.
- `config_file_mode`: [String] The octal permissions to set on configuration files.
  (default: '0644')
- `device`: [String] The name of the interface from which to capture traffic.
  (default: 'any')
- `disable_config_test`: [Boolean] If true, disable configuration file testing. It
   is generally recommended to leave this parameter at this default value.
   (default: false)
- `fields`: [Hash] Optional fields to add any additional information to the output.
  (default: undef)
- `fields_under_root`: [Boolean] By default custom fields are under a `fields`
  sub-dictionary. When set to true custom fields are added to the root-level
  document. (default: false)
- `flow_enable`: [Boolean] Enables or disables the bidirectional network flows.
  (default: true)
- `flow_period`: [String] Configures the reporting interval where all network
  flows are reported at the same time. This option takes a number followed by a
  time unit suffix, 's' representing seconds, 'm' representing minutes and so
  on. (default: '10s')
- `flow_timeout`: [String] Configures the lifetime of the flow. Like `flow_period`
  this option takes a number followed by a time-unit suffix. (default: '30s')
- `logging`: [Hash] Defines packetbeat's logging configuration, if not explicitly
  configured all logging output is forwarded to syslog on Linux nodes and file
  output on Windows. See the [docs](https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-logging.html) for all available options.
- `manage_repo`: [Boolean] When false does not install the upstream repository
  to the node's package manager. (default: true)
- `package_ensure`: [String] The desired state of the Package resources. Only
  applicable if `ensure` is 'present'. (default: 'present')
- `path_conf`: [Stdlib::Absolutepath] The base path for all packetbeat
  configurations. (default: /etc/packetbeat)
- `path_data`: [Stdlib::Absolutepath] The base path to where packetbeat stores
  its data. (default: /var/lib/packetbeat)
- `path_home`: [Stdlib::Absolutepath] The base path for the packetbeat installation,
  where the packetbeat binary is stored. (default: /usr/share/packetbeat)
- `path_logs`: [Stdlib::Absolutepath] The base path for packetbeat's log files.
  (default: /var/log/packetbeat)
- `processors`: [Array[Hash]] Add processors to the configuration to run on data
  before sending to the output. (default: undef)
- `service_ensure`: [String] Determine the state of the packet beat service. Must
  be one of 'enabled', 'disabled', 'running', 'unmanaged'. (default: enabled)
- `service_has_restart`: [Boolean] When true the Service resource issues the
  'restart' command instead of 'stop' and 'start'. (default: true)
- `snaplen`: [Integer] The maximum size of the packets to capture. Most
  environments can accept the default, on a physical interface the optimal value
  is the MTU size. (default: 65535)
- `sniff_type`: [String] Configure the sniffer type, packet beat only supports
  'pcap', 'af_packet' (Linux only, faster than 'pcap') and 'pf_ring' (Requires
  a kernel module and a re-compilation of Packetbeat, not supported by Elastic).
  (default: 'pcap')
- `tags`: [Array] Optional list of tags to help group different logical properties
  easily. (default: undef)
- `with_vlans`: [Boolean] If traffic contains VLAN tags all traffic is offset by
  four bits and packetbeat's internal BPF filter is ineffective. Only used if
  `sniff_type` is 'af_packet'. (default: undef)

### Private Classes

#### Class: `packetbeat::config`

Manages packetbeats main configuration file under `path_conf`

#### Class: `packetbeat::install`

Installs the packetbeat package.

#### Class: `packetbeat::repo`

Installs the upstream Yum or Apt repository for the system package manager.

#### Class: `packetbeat::service`

Manages the packetbeat service.

## Limitations

This module does not support loading [kibana dashboards](https://www.elastic.co/guide/en/beats/packetbeat/current/packetbeat-sample-dashboards.html)
or [elasticsearch templates](https://www.elastic.co/guide/en/beats/packetbeat/current/packetbeat-template.html), used when outputting
to Elasticsearch.

### Major Versions

This module was written for packetbeat versions 5.0 and greater. There is no
supported for 1.x versions.

## Development

Pull requests and bug reports are welcome. If you're sending a pull request,
please consider writing tests if applicable.

### Testing

Sandbox testing is done through the [PDK](https://puppet.com/docs/pdk/1.0/index.html) utility provided by
Puppet. To utilize `PDK` execute the following commands to validate and
test the new code:

1. Validate syntax of `metadata.json`, all `*.pp*` and all `*.rb` files
```
pdk validate
```
2. Perform tests
```
pdk test unit
```
