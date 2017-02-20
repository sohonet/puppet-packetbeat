# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# https://docs.puppet.com/guides/tests_smoke.html
#
class{'::packetbeat':
  outputs    => {
    'elasticsearch' => {
      'hosts'            => ['elasticsearch01:9200'],
      'template.enabled' => true,
      'template.path'    => '/etc/packetbeat/packetbeat.template.json',
    },
    'logstash'      => {
      'hosts'       => ['logstash01:5044', 'logstash02:5045'],
      'loadbalance' => true,
    },
    'kafka'         => {
      'compression' => 'gzip',
      'hosts'       => ['kafka01:9092', 'kafka02:9092'],
      'topic'       => '%{[type]}',
    },
    'redis'         => {
      'hosts' => ['redis01:6379'],
      'key'   => '%{[fields.list]:fallback}',
    },
  },
  protocols  => {
    'amqp'      => {
      'hide_connection_information' => true,
      'parse_headers'               => true,
      'ports'                       => [5672],
    },
    'cassandra' => {
      'compressor'  => 'snappy',
      'ignored_ops' => ['SUPPORTED', 'OPTIONS'],
    },
    'dns'       => {
      'include_additionals' => true,
      'include_authorities' => true,
      'ports'               => [53],
    },
    'http'      => {
      'hide_keywords'  => ['pass', 'passwd', 'password'],
      'ports'          => [80, 8080],
      'real_ip_header' => 'X-Forwarded-For',
    },
    'icmp'      => {
      'enabled' => true,
    },
    'memcache'  => {
      'parseunknown' => false,
      'ports'        => [11211],
    },
    'mongodb'   => {
      'max_docs' => 50,
    },
    'mysql'     => {
      'max_rows' => 20,
      'ports'    => [3306],
    },
    'pgsql'     => {
      'max_row_length' => 2048,
      'ports'          => [5432],
    },
    'thrift'    => {
      'capture_reply'  => true,
      'protocol_type'  => 'binary',
      'transport_type' => 'socket',
    },
  },
  processors => [
    {
      'add_cloud_metadata' => {
        'timeout' => '3s',
      },
    },
    {
      'drop_event'         => {
        'when' => {
          'http.response.code' => {
            'gte' => 200,
            'lt'  => 300,
          },
        },
      }
    },
    {
      'drop_fields'        => {
        'fields' => ['mysql.insert_id'],
      },
    },
  ],
}
