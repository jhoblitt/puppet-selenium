require 'spec_helper'

describe 'selenium::config', :type => :class do
  let(:title) { 'redhat' }
  let(:facts) {{ :osfamily=> 'RedHat' }}
  let :pre_condition do
    "class { 'selenium::server': display => 'foo' }"
  end

  context 'no params' do
    it do
      should contain_class('selenium::config')
      should contain_file('/etc/init.d/selenium').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
      }).
        with_content(/selenium-server-standalone/).
        with_content(/SLNM_INSTALL_PATH=\/opt\/selenium/)
        with_content(/SLNM_DISPLAY=:0/)
        with_content(/SLNM_USER=selenium/)
    end
  end

end
