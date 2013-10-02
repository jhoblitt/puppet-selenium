require 'spec_helper'

describe 'selenium::config', :type => :class do

  context 'for osfamily RedHat' do
    let(:facts) {{ :osfamily => 'RedHat' }}

    context 'no params' do
      let :pre_condition do
        "class { 'selenium::server': }"
      end

      it do
        should contain_class('selenium::config')
        should contain_file('/etc/init.d/selenium').with({
          'ensure' => 'file',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0755',
        }).
          with_content(/SLNM_DISPLAY=':0'/).
          with_content(/SLNM_USER='selenium'/).
          with_content(/SLNM_INSTALL_PATH='\/opt\/selenium'/).
          with_content(/SLNM_JAR_NAME='selenium-server-standalone-2.35.0.jar'/).
          with_content(/SLNM_OPTIONS='-Dwebdriver.enable.native.events=1'/)
      end
    end
  end

end
