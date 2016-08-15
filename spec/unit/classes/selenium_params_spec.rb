require 'spec_helper'

describe 'selenium::params', :type => :class do

  context 'for osfamily RedHat 6 ' do
    let(:facts) {{ :osfamily => 'RedHat', :operatingsystemmajrelease => 6 }}

    it {
      should contain_class('selenium::params')
    }
  end

  context 'for osfamily RedHat 7' do
    let(:facts) {{ :osfamily => 'RedHat', :operatingsystemmajrelease => 7 }}

    it {
      should contain_class('selenium::params')
    }

  end

  context 'for osfamily Debian' do
    let(:facts) {{ :osfamily => 'Debian' }}

    it {
      should contain_class('selenium::params')
    }
  end

  context 'unsupported osfamily' do
    let :facts do
      {
        :osfamily        => 'Suse',
        :operatingsystem => 'SuSE',
      }
    end

    it 'should fail' do
      expect { should contain_class('selenium::params') }.
        to raise_error(Puppet::Error, /not supported on SuSE/)
    end
  end

end
