require 'spec_helper_system'

describe 'selenium::hub class' do
  describe 'running puppet code' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
        include java
        Class['java'] -> Class['selenium::hub']

        class { 'selenium::hub': }
      EOS

      # Run it twice and test for idempotency
      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
        r.refresh
        r.exit_code.should be_zero
      end
    end
  end

  describe file('/etc/init.d/seleniumhub') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  %w[hub_stdout.log hub_stderr.log].each do |file|
    describe file("/opt/selenium/log/#{file}") do
      it { should be_file }
      it { should be_owned_by 'selenium' }
      it { should be_grouped_into 'selenium' }
      it { should be_mode 644}
    end
  end

  describe service('seleniumhub') do
    it { should be_running }
    it { should be_enabled }
  end

  describe port(4444) do
    it { should be_listening.with('tcp') }
  end
end
