require 'spec_helper'

describe 'zookeeper' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "zookeeper class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('zookeeper') }
          it { is_expected.to contain_class('zookeeper::params') }
          it { is_expected.to contain_class('zookeeper::install').that_comes_before('zookeeper::config') }
          it { is_expected.to contain_class('zookeeper::config') }
          it { is_expected.to contain_class('zookeeper::service').that_subscribes_to('zookeeper::config') }

          it { is_expected.to contain_file('/opt/zookeeper').with(
            :ensure => 'directory',
            :owner  => 'root',
            :group  => 'root'
          ) }
          it { is_expected.to contain_file('/var/zookeeper').with(
            :ensure => 'directory',
            :owner  => 'root',
            :group  => 'root'
          ) }
          it { is_expected.to contain_file('/var/log/zookeeper').with(
            :ensure => 'directory',
            :owner  => 'root',
            :group  => 'root'
          ) }
          it { is_expected.to contain_staging__deploy('zookeeper-3.4.6.tar.gz').with(
            :target => '/opt/zookeeper',
            :source => 'http://www.apache.org/dist/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz'
          ).that_requires(
            'File[/opt/zookeeper]'
          ).that_notifies(
            'Exec[chown install dir]'
          ) }
          it { is_expected.to contain_exec('chown install dir').with(
            :command     => '/bin/chown -R root:root /opt/zookeeper/zookeeper-3.4.6',
            :refreshonly => true
          ) }
          it { is_expected.to contain_file('/opt/zookeeper/current').with(
            :ensure => 'link',
            :target => '/opt/zookeeper/zookeeper-3.4.6'
          ).that_requires('Staging::Deploy[zookeeper-3.4.6.tar.gz]') }
          it { is_expected.to contain_file('/etc/zookeeper').with(
            :ensure => 'link',
            :target => '/opt/zookeeper/current/conf'
          ).that_requires('File[/opt/zookeeper/current]') }

          it { is_expected.to contain_concat('/opt/zookeeper/zookeeper-3.4.6/conf/zoo.cfg').with(
            :owner => 'root',
            :group => 'root',
            :mode  => '0644'
          ) }
          it { is_expected.to contain_concat__fragment('header').with(
            :target => '/opt/zookeeper/zookeeper-3.4.6/conf/zoo.cfg',
            :order  => '01'
          ) }
          it { is_expected.to contain_concat__fragment('cluster').with(
            :target => '/opt/zookeeper/zookeeper-3.4.6/conf/zoo.cfg',
            :order  => '05'
          ) }
          it { is_expected.to contain_file('/var/zookeeper/myid').with(
            :ensure  => 'file'
          ).with_content(/1\n/) }
          it { is_expected.to contain_file('/etc/init.d/zookeeper').with(
            :ensure => 'file',
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0755'
          ).with_content(/ZOOBIN=\"\/opt\/zookeeper\/zookeeper-3.4.6\/bin\"/) }

          it { is_expected.to contain_service('zookeeper').with(
            :ensure     => 'running',
            :enable     => true,
            :hasstatus  => true,
            :hasrestart => true
          ) }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'zookeeper class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('zookeeper') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
