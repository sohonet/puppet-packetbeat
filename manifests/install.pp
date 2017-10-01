# packetbeat::install
#
# Manages the state of Package['packetbeat']
#
# @summary Manages the state of Package['packetbeat']
class packetbeat::install {
  assert_private()

  if $packetbeat::ensure == 'present' {
    $package_ensure = $packetbeat::package_ensure
  }
  else {
    $package_ensure = $packetbeat::ensure
  }

  package{'packetbeat':
    ensure => $package_ensure,
  }
}
