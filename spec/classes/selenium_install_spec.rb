require 'spec_helper'

describe 'selenium::install' do
  let(:title) { 'redhat' }
  let(:facts) {{ :osfamily=> 'RedHat' }}

  context 'no params' do
    let :pre_condition do
      'include selenium::server'
    end

    it do
      should include_class('wget')
      should contain_class('selenium::install').with_version('2.35.0')
      should contain_file('/opt/selenium').with({
        'ensure' => 'directory',
        'owner'  => 'selenium',
        'group'  => 'selenium',
      })
      should contain_file('/opt/selenium/jars').with({
        'ensure' => 'directory',
        'owner'  => 'selenium',
        'group'  => 'selenium',
      })
      should contain_file('/opt/selenium/log').with({
        'ensure' => 'directory',
        'owner'  => 'selenium',
        'group'  => 'selenium',
      })
      should contain_file('/var/log/selenium').with({
        'ensure' => 'link',
        'owner'  => 'root',
        'group'  => 'root',
      })
      should contain_wget__fetch('selenium-server-standalone').with({
        'source' => 'https://selenium.googlecode.com/files/selenium-server-standalone-2.35.0.jar',
        'destination' => '/opt/selenium/jars/selenium-server-standalone-2.35.0.jar',
        'timeout'     => '90',
        'execuser'    => 'selenium',
      })
    end
  end

end
