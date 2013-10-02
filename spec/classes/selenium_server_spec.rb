require 'spec_helper'

describe 'selenium::server', :type => :class do

  shared_examples 'server' do |user, group|
    it do
      should contain_class('selenium::server')
      should contain_class('selenium::install')
      should contain_file('/etc/init.d/seleniumstandalone')
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

    context 'install_root => /foo/selenium' do
      let(:params) {{ :install_root => '/foo/selenium' }}

      it_behaves_like 'server', 'selenium', 'selenium'

      it do
        should contain_file('/foo/selenium').with({
          'ensure' => 'directory',
          'owner'  => 'selenium',
          'group'  => 'selenium',
        })
      end
    end

    context 'install_root => []' do
      let(:params) {{ :install_root => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::server')
        }.to raise_error
      end
    end

    context 'options => -foo' do
      let(:params) {{ :options => '-foo' }}

      it_behaves_like 'server', 'selenium', 'selenium'
    end

    context 'options => []' do
      let(:params) {{ :options => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::server')
        }.to raise_error
      end
    end

    context 'java => /opt/java' do
      let(:params) {{ :java => '/opt/java' }}

      it_behaves_like 'server', 'selenium', 'selenium'
    end

    context 'java => []' do
      let(:params) {{ :java => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::server')
        }.to raise_error
      end
    end
  end

end
