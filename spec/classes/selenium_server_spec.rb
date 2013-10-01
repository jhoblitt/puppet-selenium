require 'spec_helper'

describe 'selenium::server', :type => :class do

  shared_examples 'server' do |user, group|
    it do
      should contain_class('selenium::server')
      should contain_class('selenium::install')
      should contain_class('selenium::config')
      should contain_class('selenium::service')
      should contain_user(user).with_gid(group)
      should contain_group(group)
    end
  end

  context 'for osfamily RedHat' do
    let(:facts) {{ :osfamily => 'RedHat' }}

    context 'no params' do
      it_behaves_like 'server', 'selenium', 'selenium'
    end

    context 'display => :42' do
      let(:params) {{ :display => ':42' }}

      it_behaves_like 'server', 'selenium', 'selenium'
    end

    context 'display => :42' do
      let(:params) {{ :display => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::server')
        }.to raise_error
      end
    end

    context 'user => foo' do
      let(:params) {{ :user => 'foo' }}

      it_behaves_like 'server', 'foo', 'selenium'
    end

    context 'user => []' do
      let(:params) {{ :user => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::server')
        }.to raise_error
      end
    end

    context 'group => foo' do
      let(:params) {{ :group => 'foo' }}

      it_behaves_like 'server', 'selenium', 'foo'
    end

    context 'group => []' do
      let(:params) {{ :group => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::server')
        }.to raise_error
      end
    end

    context 'install_path => /foo/selenium' do
      let(:params) {{ :install_path => '/foo/selenium' }}

      it_behaves_like 'server', 'selenium', 'selenium'

      it do
        should contain_file('/foo/selenium').with({
          'ensure' => 'directory',
          'owner'  => 'selenium',
          'group'  => 'selenium',
        })
      end
    end

    context 'install_path => []' do
      let(:params) {{ :install_path => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::server')
        }.to raise_error
      end
    end
  end

end
