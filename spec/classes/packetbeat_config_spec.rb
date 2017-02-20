require 'spec_helper'
describe 'packetbeat::config', type: 'class' do
  context 'with defaults' do
    it { is_expected.to raise_error(Puppet::Error) }
  end
end
