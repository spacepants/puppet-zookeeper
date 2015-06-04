# == Class zookeeper::config
#
# This class is called from zookeeper for service config.
#
class zookeeper::config {
  #Define zookeeper config file for cluster
  concat { "${::zookeeper::install_dir}/conf/zoo.cfg":
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  concat::fragment { 'header':
    target  => "${::zookeeper::install_dir}/conf/zoo.cfg",
    order   => '01',
    content => template('zookeeper/zoo.cfg.header.erb'),
  }
  concat::fragment { 'cluster':
    target  => "${::zookeeper::install_dir}/conf/zoo.cfg",
    order   => '05',
    content => template('zookeeper/server.erb'),
  }

  #Add myid file to each node configured
  file { "${::zookeeper::data_dir}/myid":
    ensure  => file,
    content => "${::zookeeper::server_id}\n",
  }

  #Setup init script
  file { "/etc/init.d/${::zookeeper::service_name}":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('zookeeper/zookeeper.init.erb'),
  }

}
