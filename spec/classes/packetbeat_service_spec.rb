require 'spec_helper'
describe 'packetbeat::service', type: 'class' do
  context 'with defaults' do
    it { is_expected.to raise_error(Puppet::Error) }
  end
end
