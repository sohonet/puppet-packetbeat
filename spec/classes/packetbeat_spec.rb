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
        expect { should raise_error(Puppet::Error, /expects a value for parameter 'outputs'/) }
      end
    end
  end
end
