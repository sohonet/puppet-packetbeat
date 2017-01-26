# Class: packetbeat
# ===========================
#
# This class installs the Elastic packetbeat network packet analyzer
# and manages the configuration.
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
# * `fields`
# [Any] Optional fields to add additional information to the output.
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
# * `queue_size`
# [Number] The internal queue size for single events in the processing
# pipeline. (default: 1000)
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
# [Array] A list of values to include in the `tags` field in each published
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
#    class { 'packetbeat':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
#
# Corey Hammerton <corey.hammerton@gmail.com>
#
class packetbeat(
  [Hash] $outputs,
  [Hash] $protocols,
  Pattern[/^present|absent$/] $ensure,
  [String] $beat_name,
  [String] $bpf_filter,
  [Integer] $buffer_size_mb,
  [String] $config_file_mode,
  [String] $device,
  Optional[Hash] $fields,
  [Boolean] $fields_under_root,
  [Boolean] $flow_enable,
  [String] $flow_period,
  [String] $flow_timeout,
  [Hash] $logging,
  [Boolean] $manage_repo,
  [String] $package_ensure,
  [Stdlib::Absolutepath] $path_conf,
  [Stdlib::Absolutepath] $path_data,
  [Stdlib::Absolutepath] $path_home,
  [Stdlib::Absolutepath] $path_logs,
  [Integer] $queue_size,
  Pattern[/^enabled|disabled|running|unmanaged$/] $service_ensure,
  [Boolean] $service_has_restart,
  [Integer] $snaplen,
  Patterh[/^pcap|af_packet|pf_ring$/] $sniff_type,
  Optional[Array[String]] $tags,
  [Boolean] $with_vlans,
) {
  $dir_ensure = $ensure ? {
    'present' => "directory",
    default   => "absent",
  }

  if $manage_repo {
    class{"packetbeat::repo":}

    Anchor["packetbeat::begin"]
    -> Class["packetbeat::repo"]
  }

  if $ensure == 'present' {
    Anchor["packetbeat::begin"]
    -> Class["packetbeat::install"]
    -> Class["packetbeat::config"]
    ~> Class["packetbeat::service"]
  }
  else {
    Anchor["packetbeat::begin"]
    -> Class["packetbeat::service"]
    -> Class["packetbeat::install"]
  }

  anchor{"packetbeat::begin":}
  class{"packetbeat::config":}
  class{"packetbeat::install":
    notify => Class["packetbeat::service"],
  }
  class{"packetbeat::service":}
}
