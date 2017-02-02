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
          :outputs => {
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
  end
end
