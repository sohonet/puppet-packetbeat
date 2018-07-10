# packetbeat::service
# @api private
#
# Manages the state of Service['packetbeat']
#
# @summary Manages the state of Service['packetbeat']
class packetbeat::service inherits packetbeat {
  if $packetbeat::ensure == 'present' {
    case $packetbeat::service_ensure {
      'enabled': {
        $service_ensure = 'running'
        $service_enable = true
      }
      'disabled': {
        $service_ensure = 'stopped'
        $service_enable = false
      }
      'running': {
        $service_ensure = 'running'
        $service_enable = false
      }
      'unmanaged': {
        $service_ensure = undef
        $service_enable = false
      }
      default: {
      }
    }
  }
  else {
    $service_ensure = 'stopped'
    $service_enable = false
  }

  service{'packetbeat':
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasrestart => $packetbeat::service_has_restart,
  }
}
