# == Class zookeeper::install
#
# This class is called from zookeeper for install.
#
class zookeeper::install {

  #File definition for the home folder for zookeeper
  file { $::zookeeper::home_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  #Zookeeper datadir
  file { $::zookeeper::data_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
  }

  #Log folder
  file { $::zookeeper::log_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
  }

  staging::deploy { "zookeeper-${::zookeeper::version}.tar.gz":
    target  => $::zookeeper::home_dir,
    source  => "${::zookeeper::mirror}/zookeeper-${::zookeeper::version}/zookeeper-${::zookeeper::version}.tar.gz",
    require => File[$::zookeeper::home_dir],
    notify  => Exec['chown install dir'],
  }

  exec { 'chown install dir':
    command     => "/bin/chown -R root:root ${::zookeeper::install_dir}",
    refreshonly => true,
  }

  #Symlink install into current
  file { "${::zookeeper::home_dir}/current":
    ensure  => link,
    target  => $::zookeeper::install_dir,
    require => Staging::Deploy["zookeeper-${::zookeeper::version}.tar.gz"],
  }

  #Symlink configs into /etc
  file { '/etc/zookeeper':
    ensure  => link,
    target  => "${::zookeeper::home_dir}/current/conf",
    require => File["${::zookeeper::home_dir}/current"],
  }

}
