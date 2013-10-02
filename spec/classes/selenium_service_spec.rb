require 'spec_helper'

describe 'selenium::service', :type => :class do

  context 'for osfamily RedHat' do
    let(:facts) {{ :osfamily => 'RedHat' }}

    it do
      should contain_service('selenium').with({
        :ensure     => 'running',
        :hasstatus  => 'true',
        :hasrestart => 'true',
        :enable     => 'true',
      })
    end
  end

end
