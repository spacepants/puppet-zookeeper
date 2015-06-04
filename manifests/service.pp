# == Class zookeeper::service
#
# This class is meant to be called from zookeeper.
# It ensures the service is running.
#
class zookeeper::service {

  service { $::zookeeper::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
