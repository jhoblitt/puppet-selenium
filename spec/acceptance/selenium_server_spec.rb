require 'spec_helper_acceptance'

describe 'selenium::server class' do
  after(:all) do
    shell "service seleniumserver stop"
  end

  describe 'running puppet code' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
        include java
        Class['java'] -> Class['selenium::server']
        class { 'selenium':
          nocheckcertificate => true
        }        
        class { 'selenium::server': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  describe file('/etc/init.d/seleniumserver') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 755 }
  end

  %w[server_stdout.log server_stderr.log].each do |file|
    describe file("/opt/selenium/log/#{file}") do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'selenium' }
      it { is_expected.to be_grouped_into 'selenium' }
      it { is_expected.to be_mode 644}
    end
  end

  describe service('seleniumserver') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe process('java') do
    its(:args) { is_expected.to match /-Dwebdriver.enable.native.events=1/ }
    it { is_expected.to be_running }
  end

  skip('daemon is very slow to start listening') do
    describe port(4444) do
      it { is_expected.to be_listening.with('tcp') }
    end
  end
end
