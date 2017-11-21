require 'spec_helper'
describe 'packetbeat', type: 'class' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      describe 'packetbeat::config' do
        it do
          is_expected.to contain_file('packetbeat.yml').with(
            ensure: 'present',
            path: '/etc/packetbeat/packetbeat.yml',
            owner: 'root',
            group: 'root',
            mode: '0644',
            validate_cmd: '/usr/share/packetbeat/bin/packetbeat -N -configtest -c %',
          )
        end

        describe 'with ensure = absent' do
          let(:params) { { 'ensure' => 'absent' } }

          it do
            is_expected.to contain_file('packetbeat.yml').with(
              ensure: 'absent',
              path: '/etc/packetbeat/packetbeat.yml',
              validate_cmd: '/usr/share/packetbeat/bin/packetbeat -N -configtest -c %',
            )
          end
        end

        describe 'with disable_config_test = true' do
          let(:params) { { 'disable_config_test' => true } }

          it do
            is_expected.to contain_file('packetbeat.yml').with(
              ensure: 'present',
              path: '/etc/packetbeat/packetbeat.yml',
              owner: 'root',
              group: 'root',
              mode: '0644',
              validate_cmd: nil,
            )
          end
        end

        describe 'with config_file_mode = 440' do
          let(:params) { { 'config_file_mode' => '0440' } }

          it do
            is_expected.to contain_file('packetbeat.yml').with(
              ensure: 'present',
              path: '/etc/packetbeat/packetbeat.yml',
              owner: 'root',
              group: 'root',
              mode: '0440',
              validate_cmd: '/usr/share/packetbeat/bin/packetbeat -N -configtest -c %',
            )
          end
        end
      end

      describe 'packetbeat::install' do
        it { is_expected.to contain_package('packetbeat').with(ensure: 'present') }

        describe 'with ensure = absent' do
          let(:params) { { 'ensure' => 'absent' } }

          it { is_expected.to contain_package('packetbeat').with(ensure: 'absent') }
        end

        describe 'with package_ensure to a specific version' do
          let(:params) { { 'package_ensure' => '5.6.2-1' } }

          it { is_expected.to contain_package('packetbeat').with(ensure: '5.6.2-1') }
        end

        describe 'with package_ensure = latest' do
          let(:params) { { 'package_ensure' => 'latest' } }

          it { is_expected.to contain_package('packetbeat').with(ensure: 'latest') }
        end
      end

      describe 'packetbeat::repo' do
        case os_facts[:osfamily]
        when 'RedHat'
          it do
            is_expected.to contain_yumrepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
            )
          end
        when 'Debian'
          it { is_expected.to contain_class('apt') }

          it do
            is_expected.to contain_apt__source('beats').with(
              location: 'https://artifacts.elastic.co/packages/5.x/apt',
              release: 'stable',
              repos: 'main',
              key: {
                'id' => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
                'source' => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
              },
            )
          end
        when 'SuSe'
          it do
            is_expected.to contain_zypprepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              autorefresh: 1,
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
              name: 'beats',
              type: 'yum',
            )
          end
        end
      end

      describe 'packetbeat::service' do
        it do
          is_expected.to contain_service('packetbeat').with(
            ensure: 'running',
            enable: true,
            hasrestart: true,
          )
        end

        describe 'with ensure = absent' do
          let(:params) { { 'ensure' => 'absent' } }

          it do
            is_expected.to contain_service('packetbeat').with(
              ensure: 'stopped',
              enable: false,
              hasrestart: true,
            )
          end
        end

        describe 'with service_has_restart = false' do
          let(:params) { { 'service_has_restart' => false } }

          it do
            is_expected.to contain_service('packetbeat').with(
              ensure: 'running',
              enable: true,
              hasrestart: false,
            )
          end
        end

        describe 'with service_ensure = disabled' do
          let(:params) { { 'service_ensure' => 'disabled' } }

          it do
            is_expected.to contain_service('packetbeat').with(
              ensure: 'stopped',
              enable: false,
              hasrestart: true,
            )
          end
        end

        describe 'with service_ensure = running' do
          let(:params) { { 'service_ensure' => 'running' } }

          it do
            is_expected.to contain_service('packetbeat').with(
              ensure: 'running',
              enable: false,
              hasrestart: true,
            )
          end
        end

        describe 'with service_ensure = unmanaged' do
          let(:params) { { 'service_ensure' => 'unmanaged' } }

          it do
            is_expected.to contain_service('packetbeat').with(
              ensure: nil,
              enable: false,
              hasrestart: true,
            )
          end
        end
      end

      context 'with icmp protocol and elasticsearch output' do
        let :params do
          {
            outputs:   {
              'elasticsearch' => {
                'hosts' => ['http://localhost:9200'],
              },
            },
            protocols: {
              'icmp' => {
                'enabled' => true,
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('packetbeat::config').that_notifies('Class[packetbeat::service]') }
        it { is_expected.to contain_class('packetbeat::install').that_comes_before('Class[packetbeat::config]').that_notifies('Class[packetbeat::service]') }
        it { is_expected.to contain_class('packetbeat::repo').that_comes_before('Class[packetbeat::install]') }
        it { is_expected.to contain_class('packetbeat::service') }
      end

      context 'with manage_repo = false' do
        let :params do
          {
            manage_repo: false,
            outputs:     {
              'elasticsearch' => {
                'hosts' => ['http://localhost:9200'],
              },
            },
            protocols:   {
              'icmp' => {
                'enabled' => true,
              },
            },
          }
        end

        it { is_expected.not_to contain_class('packetbeat::repo') }
        it { is_expected.to contain_class('packetbeat::config').that_notifies('Class[packetbeat::service]') }
        it { is_expected.to contain_class('packetbeat::install').that_comes_before('Class[packetbeat::config]').that_notifies('Class[packetbeat::service]') }
        it { is_expected.to contain_class('packetbeat::service') }
      end

      context 'with removed parameter queue_size' do
        let :params do
          {
            outputs:     {
              'elasticsearch' => {
                'hosts' => ['http://localhost:9200'],
              },
            },
            protocols:   {
              'icmp' => {
                'enabled' => true,
              },
            },
            queue_size:  1000,
          }
        end

        it { is_expected.not_to compile }
      end
    end
  end
end
