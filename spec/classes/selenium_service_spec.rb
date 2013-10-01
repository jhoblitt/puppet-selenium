require 'spec_helper'

describe 'selenium::service' do
  let(:title) { 'redhat' }
  let(:facts) {{ :osfamily=> 'RedHat' }}

  it do
    should contain_service('selenium').with({
      :ensure     => 'running',
      :hasstatus  => 'true',
      :hasrestart => 'true',
      :enable     => 'true',
    })
  end

end
