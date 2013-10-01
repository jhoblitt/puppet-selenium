require 'spec_helper'

describe 'selenium::config' do
  let(:title) { 'redhat' }
  let(:facts) {{ :osfamily=> 'RedHat' }}

  it do
    should contain_file('/etc/init.d/selenium').with({
      'ensure' => 'file',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0755',
    }).with_content(/selenium-server-standalone/)
  end

end
