# == Class zookeeper::params
#
# This class is meant to be called from zookeeper.
# It sets variables according to platform.
#
class zookeeper::params {
  $version           = '3.4.6'
  $mirror            = 'http://www.apache.org/dist/zookeeper'
  $home_dir          = '/opt/zookeeper'
  $install_dir       = "${home_dir}/zookeeper-${version}"
  $bin_dir           = "${install_dir}/bin"
  $client_port       = '2181'
  $peer_port         = '2888'
  $leader_port       = '3888'
  $server_address    = $::ipaddress
  $server_group      = 'default'
  $server_id         = '1'
  $tick_time         = '2000'
  $init_limit        = '10'
  $sync_limit        = '5'
  $snap_retain_count = undef
  $purge_interval    = undef
  $ensemble          = [ $server_address ]
  case $::osfamily {
    'Debian', 'RedHat', 'Amazon': {
      $data_dir     = '/var/zookeeper'
      $log_dir      = '/var/log/zookeeper'
      $service_name = 'zookeeper'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
