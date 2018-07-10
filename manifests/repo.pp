# packetbeat::repo
# @api private
#
# If included configure the relevant repo manager on the target node.
#
# @summary Manages the relevant repo manager on the target node.
class packetbeat::repo inherits packetbeat {
  case $::osfamily {
    'Debian': {
      include ::apt

      $download_url = $packetbeat::major_version ? {
        '6' => 'https://artifacts.elastic.co/packages/6.x/apt',
        '5' => 'https://artifacts.elastic.co/packages/5.x/apt',
      }

      if !defined(Apt::Source['beats']) {
        apt::source{'beats':
          location => $download_url,
          release  => 'stable',
          repos    => 'main',
          key      => {
            id     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
            source => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
          },
        }
      }
    }
    'Redhat': {
      $download_url = $packetbeat::major_version ? {
        '6' => 'https://artifacts.elastic.co/packages/6.x/yum',
        '5' => 'https://artifacts.elastic.co/packages/5.x/yum',
      }

      if !defined(Yumrepo['beats']) {
        yumrepo{'beats':
          descr    => 'Elastic repository for 5.x packages',
          baseurl  => $download_url,
          gpgcheck => 1,
          gpgkey   => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
          enabled  => 1,
        }
      }
    }
    'SuSe': {
      $download_url = $packetbeat::major_version ? {
        '6' => 'https://artifacts.elastic.co/packages/6.x/yum',
        '5' => 'https://artifacts.elastic.co/packages/5.x/yum',
      }

      exec { 'topbeat_suse_import_gpg':
        command => '/usr/bin/rpmkeys --import https://artifacts.elastic.co/GPG-KEY-elasticsearch',
        unless  => '/usr/bin/test $(rpm -qa gpg-pubkey | grep -i "D88E42B4" | wc -l) -eq 1 ',
        notify  => [ Zypprepo['beats'] ],
      }
      if !defined (Zypprepo['beats']) {
        zypprepo{'beats':
          baseurl     => $download_url,
          enabled     => 1,
          autorefresh => 1,
          name        => 'beats',
          gpgcheck    => 1,
          gpgkey      => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
          type        => 'yum',
        }
      }
    }
    default: {
    }
  }
}
