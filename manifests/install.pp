class packetbeat::install {
  if $packetbeat::ensure == 'present' {
    $package_ensure = $packetbeat::package_ensure
  }
  else {
    $package_ensure = $packetbeat::ensure
  }

  case $::kernel {
    'Linux': {
      package{'packetbeat':
        ensure => $package_ensure,
      }
    }
    default: {
      fail("${::kernel} is not supported by packetbeat")
    }
  }
}
