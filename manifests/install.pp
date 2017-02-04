class packetbeat::install {
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
