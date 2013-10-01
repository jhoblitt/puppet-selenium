require 'spec_helper'

describe 'selenium::server', :type => :class do

  describe 'for osfamily RedHat' do
    let :facts do
      {
        :osfamily => 'RedHat',
      }
    end

    it { should contain_class('selenium::server') }
  end

end
