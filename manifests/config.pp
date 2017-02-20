class packetbeat::config {
  assert_private()

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
    'queue_size'        => $packetbeat::queue_size,
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
      'output'     => $packetbeat::outputs,
      'protocols'  => $packetbeat::protocols,
    },
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
    validate_cmd => "${packetbeat::path_home}/bin/packetbeat -N -configtest -e %",
  }
}
