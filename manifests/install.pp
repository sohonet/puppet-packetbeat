class packetbeat::install {
  
  case $::kernel {
    'Linux': {
      package{"packetbeat":
        ensure => $packetbeat::package_ensure,
      }
    }
    default: {
      fail("$::kernel is not supported by packetbeat")
    }
  }
}
