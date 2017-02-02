require 'spec_helper'
describe 'packetbeat' , :type => 'class' do
  context 'on RHEL/CentOS system' do
    let :facts do
      {
        kernel: 'Linux',
        osfamily: 'RedHat',
        rubyversion: '2.1.0',
        pupperverion: Puppet.version
      }
    end

    context 'defaults' do
      it do 
        expect { should raise_error(Puppet::Error) }
      end
    end

    context 'with icmp protocol and elasticsearch output' do
      let :params do
        {
          :outputs   => {
            'elasticsearch' => {
              'hosts' => ['http://localhost:9200']
            }
          },
          :protocols => {
            'icmp' => {
              'enabled' => true
            }
          }
        }
      end

      it do
        is_expected.to compile.with_all_deps

        should contain_yumrepo('beats').with(
          baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
          enabled: 1,
          gpgcheck: 1,
          gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
        )
        should contain_package('packetbeat').with(
          ensure: 'present'
        )
        should contain_file('packetbeat.yml').with(
          path: '/etc/packetbeat/packetbeat.yml',
          mode: '0644'
        )
        should contain_service('packetbeat').with(
          ensure: 'running',
          enable: true,
          hasrestart: true
        )
      end
    end

    context 'with manage_repo = false' do
      let :params do
        {
          :manage_repo => false,
          :outputs     => {
            'elasticsearch' => {
              'hosts' => ['http://localhost:9200']
            }
          },
          :protocols   => {
            'icmp' => {
              'enabled' => true
            }
          }
        }
      end

      it do
        is_expected.not_to contain_class('packetbeat::repo')
        is_expected.not_to contain_yumrepo('beats')

        should contain_package('packetbeat').with(
          ensure: 'present'
        )
        should contain_file('packetbeat.yml').with(
          path: '/etc/packetbeat/packetbeat.yml',
          mode: '0644'
        )
        should contain_service('packetbeat').with(
          ensure: 'running',
          enable: true,
          hasrestart: true
        )
      end
    end

    context 'with service_ensure = disabled' do
      let :params do
        {
          :outputs        => {
            'elasticsearch' => {
              'hosts' => ['http://localhost:9200']
            }
          },
          :protocols      => {
            'icmp' => {
              'enabled' => true
            }
          },
          :service_ensure => 'disabled'
        }
      end

      it do
        is_expected.to compile.with_all_deps

        should contain_yumrepo('beats').with(
          baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
          enabled: 1,
          gpgcheck: 1,
          gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
        )
        should contain_package('packetbeat').with(
          ensure: 'present'
        )
        should contain_file('packetbeat.yml').with(
          path: '/etc/packetbeat/packetbeat.yml',
          mode: '0644'
        )
        should contain_service('packetbeat').with(
          ensure: 'stopped',
          enable: false,
          hasrestart: true
        )
      end
    end

    context 'with service_ensure = running' do
      let :params do
        {
          :outputs        => {
            'elasticsearch' => {
              'hosts' => ['http://localhost:9200']
            }
          },
          :protocols      => {
            'icmp' => {
              'enabled' => true
            }
          },
          :service_ensure => 'running'
        }
      end

      it do
        is_expected.to compile.with_all_deps

        should contain_yumrepo('beats').with(
          baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
          enabled: 1,
          gpgcheck: 1,
          gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
        )
        should contain_package('packetbeat').with(
          ensure: 'present'
        )
        should contain_file('packetbeat.yml').with(
          path: '/etc/packetbeat/packetbeat.yml',
          mode: '0644'
        )
        should contain_service('packetbeat').with(
          ensure: 'running',
          enable: false,
          hasrestart: true
        )
      end
    end

    context 'with service_ensure = unmanaged' do
      let :params do
        {
          :outputs        => {
            'elasticsearch' => {
              'hosts' => ['http://localhost:9200']
            }
          },
          :protocols      => {
            'icmp' => {
              'enabled' => true
            }
          },
          :service_ensure => 'unmanaged'
        }
      end

      it do
        is_expected.to compile.with_all_deps

        should contain_yumrepo('beats').with(
          baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
          enabled: 1,
          gpgcheck: 1,
          gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
        )
        should contain_package('packetbeat').with(
          ensure: 'present'
        )
        should contain_file('packetbeat.yml').with(
          path: '/etc/packetbeat/packetbeat.yml',
          mode: '0644'
        )
        should contain_service('packetbeat').with(
          ensure: nil,
          enable: false,
          hasrestart: true
        )
      end
    end

    context 'with service_has_restart = false' do
      let :params do
        {
          :outputs             => {
            'elasticsearch' => {
              'hosts' => ['http://localhost:9200']
            }
          },
          :protocols           => {
            'icmp' => {
              'enabled' => true
            }
          },
          :service_has_restart => false
        }
      end

      it do
        is_expected.to compile.with_all_deps

        should contain_yumrepo('beats').with(
          baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
          enabled: 1,
          gpgcheck: 1,
          gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
        )
        should contain_package('packetbeat').with(
          ensure: 'present'
        )
        should contain_file('packetbeat.yml').with(
          path: '/etc/packetbeat/packetbeat.yml',
          mode: '0644'
        )
        should contain_service('packetbeat').with(
          ensure: 'running',
          enable: true,
          hasrestart: false
        )
      end
    end

    context 'with config_file_mode = 440' do
      let :params do
        {
          :config_file_mode => '0440',
          :outputs          => {
            'elasticsearch' => {
              'hosts' => ['http://localhost:9200']
            }
          },
          :protocols        => {
            'icmp' => {
              'enabled' => true
            }
          },
        }
      end

      it do
        is_expected.to compile.with_all_deps

        should contain_yumrepo('beats').with(
          baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
          enabled: 1,
          gpgcheck: 1,
          gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
        )
        should contain_package('packetbeat').with(
          ensure: 'present'
        )
        should contain_file('packetbeat.yml').with(
          path: '/etc/packetbeat/packetbeat.yml',
          mode: '0440'
        )
        should contain_service('packetbeat').with(
          ensure: 'running',
          enable: true,
          hasrestart: true
        )
      end
    end

    context 'with ensure = absent' do
      let :params do
        {
          :ensure    => 'absent',
          :outputs   => {
            'elasticsearch' => {
              'hosts' => ['http://localhost:9200']
            }
          },
          :protocols => {
            'icmp' => {
              'enabled' => true
            }
          },
        }
      end

      it do
        is_expected.to compile.with_all_deps

        should contain_yumrepo('beats').with(
          baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
          enabled: 1,
          gpgcheck: 1,
          gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
        )
        should contain_package('packetbeat').with(
          ensure: 'absent'
        )
        should contain_file('packetbeat.yml').with(
          ensure: 'absent'
        )
        should contain_service('packetbeat').with(
          ensure: 'stopped',
          enable: false,
          hasrestart: true
        )
      end
    end
  end
end
