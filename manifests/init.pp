# == Class: zookeeper
#
# Full description of class zookeeper here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class zookeeper (
  $version           = $::zookeeper::params::version,
  $mirror            = $::zookeeper::params::mirror,
  $home_dir          = $::zookeeper::params::home_dir,
  $install_dir       = $::zookeeper::params::install_dir,
  $bin_dir           = $::zookeeper::params::bin_dir,
  $data_dir          = $::zookeeper::params::data_dir,
  $log_dir           = $::zookeeper::params::log_dir,
  $client_port       = $::zookeeper::params::client_port,
  $peer_port         = $::zookeeper::params::peer_port,
  $leader_port       = $::zookeeper::params::leader_port,
  $server_address    = $::zookeeper::params::server_address,
  $server_group      = $::zookeeper::params::server_group,
  $server_id         = $::zookeeper::params::server_id,
  $tick_time         = $::zookeeper::params::tick_time,
  $init_limit        = $::zookeeper::params::init_limit,
  $sync_limit        = $::zookeeper::params::sync_limit,
  $snap_retain_count = $::zookeeper::params::snap_retain_count,
  $purge_interval    = $::zookeeper::params::purge_interval,
  $ensemble          = $::zookeeper::params::ensemble,
) inherits ::zookeeper::params {

  validate_string($version)
  validate_string($mirror)
  validate_absolute_path($home_dir)
  validate_absolute_path($bin_dir)
  validate_absolute_path($data_dir)
  validate_absolute_path($log_dir)
  validate_string($client_port)
  validate_string($server_name)
  validate_string($server_group)
  validate_string($server_id)

  class { '::zookeeper::install': } ->
  class { '::zookeeper::config': } ~>
  class { '::zookeeper::service': } ->
  Class['::zookeeper']
}
