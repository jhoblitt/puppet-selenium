require 'spec_helper'

describe 'selenium::install' do
  let(:title) { 'redhat' }
  let(:facts) {{ :osfamily=> 'RedHat' }}

  it do
    should include_class('wget')
    should contain_class('selenium::install').with_version('2.35.0')
    should contain_file('/opt/selenium').with_ensure('directory')
    should contain_wget__fetch('selenium-server-standalone')
  end

end
