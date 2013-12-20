require 'spec_helper'

describe 'selenium::params', :type => :class do

  context 'for osfamily RedHat' do
    let(:facts) {{ :osfamily => 'RedHat' }}

    it { should contain_class('selenium::params') }
  end

  context 'unsupported osfamily' do
    let :facts do 
      {
        :osfamily        => 'Debian',
        :operatingsystem => 'Debian',
      }
    end
  
    it 'should fail' do
      expect { should contain_class('selenium::params') }.
        to raise_error(Puppet::Error, /not supported on Debian/)
    end
  end

end
