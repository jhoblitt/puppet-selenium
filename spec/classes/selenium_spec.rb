require 'spec_helper'

describe 'module_skel', :type => :class do

  describe 'for osfamily RedHat' do
    it { should contain_class('module_skel') }
  end

end
