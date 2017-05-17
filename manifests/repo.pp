class packetbeat::repo {
  assert_private()

  case $::osfamily {
    'Debian': {
      include ::apt

      if !defined(Apt::Source['beats']) {
        apt::source{'beats':
          location => 'https://artifacts.elastic.co/packages/5.x/apt',
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
      if !defined(Yumrepo['beats']) {
        yumrepo{'beats':
          descr    => 'Elastic repository for 5.x packages',
          baseurl  => 'https://artifacts.elastic.co/packages/5.x/yum',
          gpgcheck => 1,
          gpgkey   => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
          enabled  => 1,
        }
      }
    }
    'SuSe': {
      exec { 'topbeat_suse_import_gpg':
        command => 'rpmkeys --import https://artifacts.elastic.co/GPG-KEY-elasticsearch',
        unless  => 'test $(rpm -qa gpg-pubkey | grep -i "D88E42B4" | wc -l) -eq 1 ',
        notify  => [ Zypprepo['beats'] ],
      }
      if !defined (Zypprepo['beats']) {
        zypprepo{'beats':
          baseurl     => 'https://artifacts.elastic.co/packages/5.x/yum',
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
