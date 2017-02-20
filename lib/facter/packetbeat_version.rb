require 'facter'

Facter.add('packetbeat_version') do
  confine :kernel => 'Linux' # rubocop:disable Style/HashSyntax
  setcode do
    packetbeat_version = Facter::Util::Resolution.exec('/usr/share/packetbeat/bin/packetbeat -version')

    %r{^packetbeat version ([^\s]+)?}.match(packetbeat_version)[1] unless packetbeat_version.nil?
  end
end
