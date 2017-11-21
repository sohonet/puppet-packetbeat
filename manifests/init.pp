# Class: packetbeat
# ===========================
#
# This class installs the Elastic packetbeat network packet analyzer
# and manages the configuration.
#
# @summary Installs, configures and manages Packetbeat on the target node.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `outputs`
# [Hash] The names and parameters of the perferred output target(s).
#
# * `protocols`
# [Hash] The names and parameters of the transaction protocols to configure.
# See https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-protocols.html
# for the full list of protocols supported by Packetbeat.
#
# * `ensure`
# [String] Determines weather all resources should be managed or removed
# from the target node. Must be 'present' or 'absent'.
# (default: 'present')
#
# * `beat_name`
# [String] The name of the beat, also included in each published transaction.
# (default: $::fqdn)
#
# * `config_file_mode`
# [String] The octal permission mode set for configuration files on Linux
# nodes. (default: '0644')
# 
# * `device`
# [String] The name of the interface device from which to capture the 
# traffic. (default: 'any')
#
# * `disable_config_test`
# [Boolean] If true, disable configuration file testing. It is generally
# recommended to leave this parameter at this default value. (default: false)
#
# * `fields`
# Optional[Hash] Optional fields to add additional information to the output.
# (default: undef)
#
# * `fields_under_root`
# [Boolean] By default libbeat stores custom fields under a `fields`
# sub-dictionary. Set this to true to store custom fields in the
# top-level field. (default: false)
#
# * `flow_enable`
# [Boolean] Toggles the option to capture bidirectional network flows.
# (default: true)
#
# * `flow_period`
# [String] Configures the flow period, where all flows are reported
# simultaneously. Setting to '-1' disables this feature, flows are then
# reported when timed out. (default: 10s)
#
# * `flow_timeout`
# [String] The maximum reportable lifetime of a network flow. This option
# can be suffixed with s for seconds, m for minutes, h for hours, etc.
# (default: 30s)
#
# * `logging`
# [Hash] The configuration section of `packetbeat.yml` for configuring the
# logging output.
#
# * `manage_repo`
# [Boolean] Weather the upstream (elastic) repo should be configured or
# not. (default: true)
#
# * `package_ensure`
# [String] The state the packetbeat package should be in. (default: present)
#
# * `path_conf`
# [Absolute Path] The location of the configuration files. This setting
# also controls the path to `packetbeat.yml`.
#
# * `path_data`
# [Absolute Path] The location of the persistent data files.
#
# * `path_home`
# [Absolute Path] The home of the Packetbeat configuration.
#
# * `path_logs`
# [Absolute Path] The location of the logs created by Packetbeat.
#
# * `processors`
# Optional[Array[Hash]] Configure processors to perform filtering, 
# enhancing or additional decoding of data before being sent to the
# output.
#
# * `service_ensure`
# [String] The desired state of the packetbeat service. Must be one of
# 'enabled', 'disabled', 'running' or 'unmanaged'. (default: 'enabled')
#
# * `service_has_restart`
# [Boolean] Tells the Service resource to issue a 'restart' command instead
# of 'stop' then 'start'. (default: true)
#
# * `snaplen`
# [Number] The maximum size of the packetsto capture. If the device is a
# physical interface the MTU size is the optimal setting. (default: 65535)
#
# * `sniff_type`
# [String] The sniffer type to use. Packet only has support for pcap,
# af_packet and pf_ring. (default: 'pcap')
#
# * `tags`
# Optional[Array] A list of values to include in the `tags` field in each published
# message, making it easier to group servers by logical property.
# (default: [])
#
# * `buffer_size_mb`
# [Number] The maximum size of the shared memory buffer between the kernel
# and the user space. This is only applicable if $sniff_type == 'af_packet'
# (default: undef)
# 
# * `with_vlans`
# [Boolean] If the captured traffic contains VLAN tags the BPF filter
# Packetbeat automatically generates becomes ineffective because all
# the traffic is offset by four bytes. Set this to true to configure
# Packetbeat to filter VLAN tags. This is only applicable if 
# $sniff_type == 'af_packet'
#
# * `bpf_filter`
# [String] Configure a custom BPF filter for capturing traffic on the
# device. This disables automatic filter generation in Packetbeat, it
# is the responsibility of the users to keep this in-sync with the
# protocols
#
# Examples
# --------
#
# @example
# class{'packetbeat':
#   processors => [
#     {
#       'drop_fields' => {
#         'fields' => ['field1', 'field2']
#       }
#     }
#   ],
#   protocols => {
#     'icmp' => {
#       'enabled' => true
#     }
#   },
#   outputs   => {
#     'elasticsearch' => {
#       'hosts' => ['localhost:9200']
#     }
#   }
# }
class packetbeat(
  Hash $outputs                                                       = {},
  Hash $protocols                                                     = {},
  Enum['present', 'absent'] $ensure                                   = 'present',
  String $beat_name                                                   = $::hostname,
  Optional[String] $bpf_filter                                        = undef,
  Optional[Integer] $buffer_size_mb                                   = undef,
  String $config_file_mode                                            = '0644',
  String $device                                                      = 'any',
  Boolean $disable_config_test                                        = false,
  Optional[Hash] $fields                                              = undef,
  Boolean $fields_under_root                                          = false,
  Boolean $flow_enable                                                = true,
  String $flow_period                                                 = '10s',
  String $flow_timeout                                                = '30s',
  Hash $logging                                                       = {
    'to_files' => true,
    'level'    => 'info',
    'metrics'  => {
      'enabled' => true,
      'period'  => '30s',
    },
    'files'    => {
      'name'             => 'packetbeat',
      'keepfiles'        => 7,
      'path'             => '/var/log/packetbeat',
      'rotateeverybytes' => 10485760,
    },
  },
  Boolean $manage_repo                                                = true,
  String $package_ensure                                              = 'present',
  Stdlib::Absolutepath $path_conf                                     = '/etc/packetbeat',
  Stdlib::Absolutepath $path_data                                     = '/var/lib/packetbeat',
  Stdlib::Absolutepath $path_home                                     = '/usr/share/packetbeat',
  Stdlib::Absolutepath $path_logs                                     = '/var/log/packetbeat',
  Optional[Array[Hash]] $processors                                   = undef,
  Enum['enabled', 'disabled', 'running', 'unmanaged'] $service_ensure = 'enabled',
  Boolean $service_has_restart                                        = true,
  Integer $snaplen                                                    = 65535,
  Enum['pcap', 'af_packet', 'pf_ring'] $sniff_type                    = 'pcap',
  Optional[Array[String]] $tags                                       = undef,
  Optional[Boolean] $with_vlans                                       = undef,
) {
  if $manage_repo {
    class{'::packetbeat::repo':}

    Anchor['packetbeat::begin']
    -> Class['packetbeat::repo']
    -> Class['packetbeat::install']
  }

  if $ensure == 'present' {
    Anchor['packetbeat::begin']
    -> Class['packetbeat::install']
    -> Class['packetbeat::config']
    ~> Class['packetbeat::service']

    Class['packetbeat::install']
    ~> Class['packetbeat::service']
  }
  else {
    Anchor['packetbeat::begin']
    -> Class['packetbeat::service']
    -> Class['packetbeat::install']
  }

  anchor{'packetbeat::begin':}
  class{'::packetbeat::config':}
  class{'::packetbeat::install':}
  class{'::packetbeat::service':}
}
