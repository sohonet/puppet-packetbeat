# packetbeat::config
# @api private
#
# Renders the content of Packetbeat's configuration file
#
# @summary Manages Packetbeat's configuration file
class packetbeat::config inherits packetbeat {
  $validate_cmd      = $packetbeat::disable_config_test ? {
    true    => undef,
    default => "${packetbeat::path_home}/bin/packetbeat -N -configtest -c %",
  }
  $packetbeat_config = delete_undef_values({
    'name'              => $packetbeat::beat_name,
    'fields'            => $packetbeat::fields,
    'fields_under_root' => $packetbeat::fields_under_root,
    'logging'           => $packetbeat::logging,
    'path'              => {
      'conf' => $packetbeat::path_conf,
      'data' => $packetbeat::path_data,
      'home' => $packetbeat::path_home,
      'logs' => $packetbeat::path_logs,
    },
    'tags'              => $packetbeat::tags,
    'processors'        => $packetbeat::processors,
    'packetbeat'        => {
      'interfaces' => {
        'device'  => $packetbeat::device,
        'snaplen' => $packetbeat::snaplen,
        'type'    => $packetbeat::sniff_type,
      },
      'flows'      => {
        'enabled' => $packetbeat::flow_enable,
        'period'  => $packetbeat::flow_period,
        'timeout' => $packetbeat::flow_timeout,
      },
      'protocols'  => $packetbeat::protocols,
    },
    'output'     => $packetbeat::outputs,
  })

  if $packetbeat::sniff_type == 'af_packet' {
    $af_packet_config = delete_undef_values({
      'packetbeat' => {
        'interfaces' => {
          'buffer_size_mb' => $packetbeat::buffer_size_mb,
          'with_vlans'     => $packetbeat::with_vlans,
          'bpf_filter'     => $packetbeat::bpf_filter,
        },
      },
    })

    $packetbeat_config = merge($packetbeat_config, $af_packet_config)
  }

  file{'packetbeat.yml':
    ensure       => $packetbeat::ensure,
    path         => "${packetbeat::path_conf}/packetbeat.yml",
    owner        => 'root',
    group        => 'root',
    mode         => $packetbeat::config_file_mode,
    content      => inline_template("### Packetbeat configuration managed by Puppet ###\n\n<%= @packetbeat_config.to_yaml() %>"),
    validate_cmd => $validate_cmd,
  }
}
