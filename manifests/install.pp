class packetbeat::install {
  
  case $::kernel {
    'Linux': {
      package{"packetbeat":
        ensure => $packetbeat::package_ensure,
      }
    }
    'Windows': {
      $filename = regsubst($packetbeat::download_url, '^https.*\/([^\/]+)\.[^.].*', '\1')

      exec{
        "install ${filename}":
          cwd         => "${packetbeat::install_dir}/Packetbeat",
          command     => "./install-service-packetbeat.ps1",
          onlyif      => 'if(Get-WmiObject -Class Win32_Service -Filter "Name=\'packetbeat\'") { exit 1 } else {exit 0 }',
          provider    => powershell,
          refreshonly => true;
        "rename packetbeat":
          command     => "Rename-Item '${packetbeat::install_dir}/${filename}' Packetbeat",
          creates     => "${packetbeat::install_dir}/Packetbeat",
          provider    => powershell,
          refreshonly => true,
          notify      => Exec["install ${filename}];
      }
      file{${packetbeat::install_dir}:
        ensure => ${packetbeat::dir_ensure},
      }
      staging::deploy{"packetbeat.zip":
        source  => "https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-5.1.2-windows-x86_64.zip",
        target  => ${packetbeat::install_dir},
        require => File[${packetbeat::install_dir}],
        notify  => Exec["rename packetbeat"],
      }
    }
    default: {
      fail("$::kernel is not supported by packetbeat")
    }
  }
}
