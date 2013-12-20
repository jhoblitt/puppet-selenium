require 'spec_helper_system'

describe 'selenium class' do
  describe 'running puppet code' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
        include java
        Class['java'] -> Class['selenium']

        class { 'selenium': }
      EOS

      # Run it twice and test for idempotency
      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
        r.refresh
        r.exit_code.should be_zero
      end
    end
  end

  %w[/opt/selenium /opt/selenium/jars /opt/selenium/log].each do |file|
    describe file(file) do
      it { should be_directory }
      it { should be_owned_by 'selenium' }
      it { should be_grouped_into 'selenium' }
      it { should be_mode 755 }
    end
  end

  describe file('/var/log/selenium') do
    it { should be_linked_to '/opt/selenium/log' }
  end

  describe file('/opt/selenium/jars/selenium-server-standalone-2.39.0.jar') do
    it { should be_file }
    it { should be_owned_by 'selenium' }
    it { should be_grouped_into 'selenium' }
    it { should be_mode 644 }
  end

  describe file('/etc/logrotate.d/selenium') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 444 }
  end
end
