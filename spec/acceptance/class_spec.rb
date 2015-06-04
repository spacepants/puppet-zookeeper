require 'spec_helper_acceptance'

describe 'zookeeper class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'java': } ->
      class { 'zookeeper': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/opt/zookeeper/zookeeper-3.4.6') do
      it { is_expected.to be_directory }
    end

    describe service('zookeeper') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
