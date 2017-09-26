require 'spec_helper'
describe 'packetbeat', type: 'class' do
  on_supported_os.each do |os, f|
    context "on #{os}" do
      context 'with defaults' do
        it { is_expected.to raise_error(Puppet::Error) }
      end

      context 'with icmp protocol and elasticsearch output' do
        let :params do
          {
            outputs:   {
              'elasticsearch' => {
                'hosts' => ['http://localhost:9200']
              }
            },
            protocols: {
              'icmp' => {
                'enabled' => true
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('packetbeat::config') }
        it { is_expected.to contain_class('packetbeat::install') }
        it { is_expected.to contain_class('packetbeat::repo') }
        it { is_expected.to contain_class('packetbeat::service') }

        it do
          is_expected.to contain_file('packetbeat.yml').with(
            path: '/etc/packetbeat/packetbeat.yml',
            mode: '0644'
          )
        end

        it do
          is_expected.to contain_package('packetbeat').with(
            ensure: 'present'
          )
        end

        if f[:os][:family] == 'RedHat'
          it do
            is_expected.to contain_yumrepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
            )
          end
        elsif f[:os][:family] == 'Debian'
          it do
            is_expected.to contain_apt__source('beats').with(
              location: 'https://artifacts.elastic.co/packages/5.x/apt',
              release: 'stable',
              repos: 'main',
              key: {
                id: '46095ACC8548582C1A2699A9D27D666CD88E42B4',
                source: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
              }
            )
          end
        elsif f[:os][:family] == 'SuSe'
          it do
            is_expected.to contain_zypprepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              autorefresh: 1,
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
              name: 'beats',
              type: 'yum'
            )
          end
        end
      end

      context 'with manage_repo = false' do
        let :params do
          {
            manage_repo: false,
            outputs:     {
              'elasticsearch' => {
                'hosts' => ['http://localhost:9200']
              }
            },
            protocols:   {
              'icmp' => {
                'enabled' => true
              }
            }
          }
        end

        it { is_expected.not_to contain_class('packetbeat::repo') }
        it { is_expected.to contain_class('packetbeat::config') }
        it { is_expected.to contain_class('packetbeat::install') }
        it { is_expected.to contain_class('packetbeat::service') }

        it do
          if f[:os][:family] == 'RedHat'
            is_exptected.not_to contain_yumrepo('beats')
          elsif f[:os][:family] == 'Debian'
            is_expected.not_to contain_apt__source('beats')
          end
        end

        it do
          is_expected.to contain_file('packetbeat.yml').with(
            path: '/etc/packetbeat/packetbeat.yml',
            mode: '0644'
          )
        end

        it do
          is_expected.to contain_package('packetbeat').with(
            ensure: 'present'
          )
        end

        it do
          is_expected.to contain_service('packetbeat').with(
            ensure: 'running',
            enable: true,
            hasrestart: true
          )
        end
      end

      context 'with service_ensure = disabled' do
        let :params do
          {
            outputs:        {
              'elasticsearch' => {
                'hosts' => ['http://localhost:9200']
              }
            },
            protocols:      {
              'icmp' => {
                'enabled' => true
              }
            },
            service_ensure: 'disabled'
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('packetbeat::config') }
        it { is_expected.to contain_class('packetbeat::install') }
        it { is_expected.to contain_class('packetbeat::repo') }
        it { is_expected.to contain_class('packetbeat::service') }

        it do
          is_expected.to contain_file('packetbeat.yml').with(
            path: '/etc/packetbeat/packetbeat.yml',
            mode: '0644'
          )
        end

        it do
          is_expected.to contain_package('packetbeat').with(
            ensure: 'present'
          )
        end

        if f[:os][:family] == 'RedHat'
          it do
            is_expected.to contain_yumrepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
            )
          end
        elsif f[:os][:family] == 'Debian'
          it do
            is_expected.to contain_apt__source('beats').with(
              location: 'https://artifacts.elastic.co/packages/5.x/apt',
              release: 'stable',
              repos: 'main',
              key: {
                id: '46095ACC8548582C1A2699A9D27D666CD88E42B4',
                source: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
              }
            )
          end
        elsif f[:os][:family] == 'SuSe'
          it do
            is_expected.to contain_zypprepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              autorefresh: 1,
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
              name: 'beats',
              type: 'yum'
            )
          end
        end

        it do
          is_expected.to contain_service('packetbeat').with(
            ensure: 'stopped',
            enable: false,
            hasrestart: true
          )
        end
      end

      context 'with service_ensure = running' do
        let :params do
          {
            outputs:        {
              'elasticsearch' => {
                'hosts' => ['http://localhost:9200']
              }
            },
            protocols:      {
              'icmp' => {
                'enabled' => true
              }
            },
            service_ensure: 'running'
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('packetbeat::config') }
        it { is_expected.to contain_class('packetbeat::install') }
        it { is_expected.to contain_class('packetbeat::repo') }
        it { is_expected.to contain_class('packetbeat::service') }

        if f[:os][:family] == 'RedHat'
          it do
            is_expected.to contain_yumrepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
            )
          end
        elsif f[:os][:family] == 'Debian'
          it do
            is_expected.to contain_apt__source('beats').with(
              location: 'https://artifacts.elastic.co/packages/5.x/apt',
              release: 'stable',
              repos: 'main',
              key: {
                id: '46095ACC8548582C1A2699A9D27D666CD88E42B4',
                source: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
              }
            )
          end
        elsif f[:os][:family] == 'SuSe'
          it do
            is_expected.to contain_zypprepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              autorefresh: 1,
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
              name: 'beats',
              type: 'yum'
            )
          end
        end

        it do
          is_expected.to contain_package('packetbeat').with(
            ensure: 'present'
          )
        end

        it do
          is_expected.to contain_file('packetbeat.yml').with(
            path: '/etc/packetbeat/packetbeat.yml',
            mode: '0644'
          )
        end

        it do
          is_expected.to contain_service('packetbeat').with(
            ensure: 'running',
            enable: false,
            hasrestart: true
          )
        end
      end

      context 'with service_ensure = running' do
        let :params do
          {
            outputs:        {
              'elasticsearch' => {
                'hosts' => ['http://localhost:9200']
              }
            },
            protocols:      {
              'icmp' => {
                'enabled' => true
              }
            },
            service_ensure: 'running'
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('packetbeat::config') }
        it { is_expected.to contain_class('packetbeat::install') }
        it { is_expected.to contain_class('packetbeat::repo') }
        it { is_expected.to contain_class('packetbeat::service') }

        if f[:os][:family] == 'RedHat'
          it do
            is_expected.to contain_yumrepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
            )
          end
        elsif f[:os][:family] == 'Debian'
          it do
            is_expected.to contain_apt__source('beats').with(
              location: 'https://artifacts.elastic.co/packages/5.x/apt',
              release: 'stable',
              repos: 'main',
              key: {
                id: '46095ACC8548582C1A2699A9D27D666CD88E42B4',
                source: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
              }
            )
          end
        elsif f[:os][:family] == 'SuSe'
          it do
            is_expected.to contain_zypprepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              autorefresh: 1,
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
              name: 'beats',
              type: 'yum'
            )
          end
        end

        it do
          is_expected.to contain_package('packetbeat').with(
            ensure: 'present'
          )
        end

        it do
          is_expected.to contain_file('packetbeat.yml').with(
            path: '/etc/packetbeat/packetbeat.yml',
            mode: '0644'
          )
        end

        it do
          is_expected.to contain_service('packetbeat').with(
            ensure: 'running',
            enable: false,
            hasrestart: true
          )
        end
      end

      context 'with service_ensure = unmanaged' do
        let :params do
          {
            outputs:        {
              'elasticsearch' => {
                'hosts' => ['http://localhost:9200']
              }
            },
            protocols:      {
              'icmp' => {
                'enabled' => true
              }
            },
            service_ensure: 'unmanaged'
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('packetbeat::config') }
        it { is_expected.to contain_class('packetbeat::install') }
        it { is_expected.to contain_class('packetbeat::repo') }
        it { is_expected.to contain_class('packetbeat::service') }

        if f[:os][:family] == 'RedHat'
          it do
            is_expected.to contain_yumrepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
            )
          end
        elsif f[:os][:family] == 'Debian'
          it do
            is_expected.to contain_apt__source('beats').with(
              location: 'https://artifacts.elastic.co/packages/5.x/apt',
              release: 'stable',
              repos: 'main',
              key: {
                id: '46095ACC8548582C1A2699A9D27D666CD88E42B4',
                source: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
              }
            )
          end
        elsif f[:os][:family] == 'SuSe'
          it do
            is_expected.to contain_zypprepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              autorefresh: 1,
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
              name: 'beats',
              type: 'yum'
            )
          end
        end

        it do
          is_expected.to contain_package('packetbeat').with(
            ensure: 'present'
          )
        end

        it do
          is_expected.to contain_file('packetbeat.yml').with(
            path: '/etc/packetbeat/packetbeat.yml',
            mode: '0644'
          )
        end

        it do
          is_expected.to contain_service('packetbeat').with(
            ensure: nil,
            enable: false,
            hasrestart: true
          )
        end
      end

      context 'with service_has_restart = false' do
        let :params do
          {
            outputs:             {
              'elasticsearch' => {
                'hosts' => ['http://localhost:9200']
              }
            },
            protocols:           {
              'icmp' => {
                'enabled' => true
              }
            },
            service_has_restart: false
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('packetbeat::config') }
        it { is_expected.to contain_class('packetbeat::install') }
        it { is_expected.to contain_class('packetbeat::repo') }
        it { is_expected.to contain_class('packetbeat::service') }

        if f[:os][:family] == 'RedHat'
          it do
            is_expected.to contain_yumrepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
            )
          end
        elsif f[:os][:family] == 'Debian'
          it do
            is_expected.to contain_apt__source('beats').with(
              location: 'https://artifacts.elastic.co/packages/5.x/apt',
              release: 'stable',
              repos: 'main',
              key: {
                id: '46095ACC8548582C1A2699A9D27D666CD88E42B4',
                source: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
              }
            )
          end
        elsif f[:os][:family] == 'SuSe'
          it do
            is_expected.to contain_zypprepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              autorefresh: 1,
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
              name: 'beats',
              type: 'yum'
            )
          end
        end

        it do
          is_expected.to contain_package('packetbeat').with(
            ensure: 'present'
          )
        end

        it do
          is_expected.to contain_file('packetbeat.yml').with(
            path: '/etc/packetbeat/packetbeat.yml',
            mode: '0644'
          )
        end

        it do
          is_expected.to contain_service('packetbeat').with(
            ensure: 'running',
            enable: true,
            hasrestart: false
          )
        end
      end

      context 'with config_file_mode = 440' do
        let :params do
          {
            config_file_mode: '0440',
            outputs:          {
              'elasticsearch' => {
                'hosts' => ['http://localhost:9200']
              }
            },
            protocols:        {
              'icmp' => {
                'enabled' => true
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('packetbeat::config') }
        it { is_expected.to contain_class('packetbeat::install') }
        it { is_expected.to contain_class('packetbeat::repo') }
        it { is_expected.to contain_class('packetbeat::service') }

        if f[:os][:family] == 'RedHat'
          it do
            is_expected.to contain_yumrepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
            )
          end
        elsif f[:os][:family] == 'Debian'
          it do
            is_expected.to contain_apt__source('beats').with(
              location: 'https://artifacts.elastic.co/packages/5.x/apt',
              release: 'stable',
              repos: 'main',
              key: {
                id: '46095ACC8548582C1A2699A9D27D666CD88E42B4',
                source: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
              }
            )
          end
        elsif f[:os][:family] == 'SuSe'
          it do
            is_expected.to contain_zypprepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              autorefresh: 1,
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
              name: 'beats',
              type: 'yum'
            )
          end
        end

        it do
          is_expected.to contain_package('packetbeat').with(
            ensure: 'present'
          )
        end

        it do
          is_expected.to contain_file('packetbeat.yml').with(
            path: '/etc/packetbeat/packetbeat.yml',
            mode: '0440'
          )
        end

        it do
          is_expected.to contain_service('packetbeat').with(
            ensure: 'running',
            enable: true,
            hasrestart: true
          )
        end
      end

      context 'with disable_config_test = true' do
        let :params do
          {
            disable_config_test: true,
            outputs:             {
              'elasticsearch' => {
                'hosts' => ['http://localhost:9200']
              }
            },
            protocols:           {
              'icmp' => {
                'enabled' => true
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('packetbeat::config') }
        it { is_expected.to contain_class('packetbeat::install') }
        it { is_expected.to contain_class('packetbeat::repo') }
        it { is_expected.to contain_class('packetbeat::service') }

        it do
          is_expected.to contain_file('packetbeat.yml').with(
            path:         '/etc/packetbeat/packetbeat.yml',
            mode:         '0644',
            validate_cmd: nil
          )
        end

        it do
          is_expected.to contain_package('packetbeat').with(
            ensure: 'present'
          )
        end

        if f[:os][:family] == 'RedHat'
          it do
            is_expected.to contain_yumrepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
            )
          end
        elsif f[:os][:family] == 'Debian'
          it do
            is_expected.to contain_apt__source('beats').with(
              location: 'https://artifacts.elastic.co/packages/5.x/apt',
              release: 'stable',
              repos: 'main',
              key: {
                id: '46095ACC8548582C1A2699A9D27D666CD88E42B4',
                source: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
              }
            )
          end
        elsif f[:os][:family] == 'SuSe'
          it do
            is_expected.to contain_zypprepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              autorefresh: 1,
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
              name: 'beats',
              type: 'yum'
            )
          end
        end
      end

      context 'with ensure = absent' do
        let :params do
          {
            ensure:    'absent',
            outputs:   {
              'elasticsearch' => {
                'hosts' => ['http://localhost:9200']
              }
            },
            protocols: {
              'icmp' => {
                'enabled' => true
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('packetbeat::config') }
        it { is_expected.to contain_class('packetbeat::install') }
        it { is_expected.to contain_class('packetbeat::repo') }
        it { is_expected.to contain_class('packetbeat::service') }

        if f[:os][:family] == 'RedHat'
          it do
            is_expected.to contain_yumrepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
            )
          end
        elsif f[:os][:family] == 'Debian'
          it do
            is_expected.to contain_apt__source('beats').with(
              location: 'https://artifacts.elastic.co/packages/5.x/apt',
              release: 'stable',
              repos: 'main',
              key: {
                id: '46095ACC8548582C1A2699A9D27D666CD88E42B4',
                source: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
              }
            )
          end
        elsif f[:os][:family] == 'SuSe'
          it do
            is_expected.to contain_zypprepo('beats').with(
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
              autorefresh: 1,
              enabled: 1,
              gpgcheck: 1,
              gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
              name: 'beats',
              type: 'yum'
            )
          end
        end

        it do
          is_expected.to contain_package('packetbeat').with(
            ensure: 'absent'
          )
        end

        it do
          is_expected.to contain_file('packetbeat.yml').with(
            ensure: 'absent'
          )
        end

        it do
          is_expected.to contain_service('packetbeat').with(
            ensure: 'stopped',
            enable: false,
            hasrestart: true
          )
        end
      end
    end
  end
end
