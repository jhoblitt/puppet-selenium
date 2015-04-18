require 'spec_helper_acceptance'

describe 'selenium class' do
  describe 'running puppet code' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
        include java
        Class['java'] -> Class['selenium']

        class { 'selenium':
          nocheckcertificate => true 
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  %w[/opt/selenium /opt/selenium/jars /opt/selenium/log].each do |file|
    describe file(file) do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'selenium' }
      it { is_expected.to be_grouped_into 'selenium' }
      it { is_expected.to be_mode 755 }
    end
  end

  describe file('/var/log/selenium') do
    it { is_expected.to be_linked_to '/opt/selenium/log' }
  end

  describe file("/opt/selenium/jars/selenium-server-standalone-#{DEFAULT_VERSION}.jar") do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'selenium' }
    it { is_expected.to be_grouped_into 'selenium' }
    it { is_expected.to be_mode 644 }
  end

  describe file('/etc/logrotate.d/selenium') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 444 }
  end
end
