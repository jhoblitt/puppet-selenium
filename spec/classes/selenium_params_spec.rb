require 'spec_helper'

describe 'selenium::params', :type => :class do
  describe 'for osfamily RedHat' do
    let :facts do
      {
        :osfamily => 'RedHat',
      }
    end

    it { should include_class('selenium::params') }
  end

  describe 'unsupported osfamily' do
    let :facts do 
      {
        :osfamily        => 'Debian',
        :operatingsystem => 'Debian',
      }
    end
  
    it 'should fail' do
      expect { should include_class('selenium::params') }.
        to raise_error(Puppet::Error, /not supported on Debian/)
    end
  end

end
