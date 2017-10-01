require 'facter'

Facter.add('packetbeat_version') do
  confine :kernel => 'Linux' # rubocop:disable Style/HashSyntax
  setcode do
    packetbeat_version = Facter::Util::Resolution.exec(
      '/usr/share/packetbeat/bin/packetbeat -version',
    )

    %r{^packetbeat version ([0-9.]+)}.match(packetbeat_version)[1]
  end
end
