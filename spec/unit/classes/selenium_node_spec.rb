require 'spec_helper'

describe 'selenium::node', :type => :class do

  shared_examples 'node_with_initd' do |params|
    p = {
      :display => ':0',
      :options => '-Dwebdriver.enable.native.events=1 -role node',
      :hub     => 'http://localhost:4444/grid/register',
    }

    p.merge!(params) if params

    it do
      should contain_class('selenium')
      should contain_selenium__config('node').with({
        'options' => "#{p[:options]} -hub #{p[:hub]}",
        'initsystem' => "init.d",
      })
      should contain_class('selenium::node')
    end
  end

  shared_examples 'node_with_systemd' do |params|
    p = {
        :display => ':0',
        :options => '-Dwebdriver.enable.native.events=1 -role node',
        :hub     => 'http://localhost:4444/grid/register',
    }

    p.merge!(params) if params

    it do
      should contain_class('selenium')
      should contain_selenium__config('node').with({
                                                       'options' => "#{p[:options]} -hub #{p[:hub]}",
                                                       'initsystem' => "systemd",
                                                   })
      should contain_class('selenium::node')
    end
  end

  context 'for osfamily RedHat 6' do
    let(:facts) {{ :osfamily => 'RedHat', :operatingsystemmajrelease => 6 }}

    context 'no params' do
      it_behaves_like 'node_with_initd', {}
    end

    context 'display => :42' do
      p = { :display => ':42' }
      let(:params) { p }

      it_behaves_like 'node_with_initd', p
    end

    context 'display => :42' do
      let(:params) {{ :display => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::node')
        }.to raise_error
      end
    end

    context 'options => -foo' do
      p = { :options => '-foo' }
      let(:params) { p }

      it_behaves_like 'node_with_initd', p
    end

    context 'options => []' do
      let(:params) {{ :options => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::node')
        }.to raise_error
      end
    end

    context 'hub => http://foo' do
      p = { :hub => 'http://foo' }
      let(:params) { p }

      it_behaves_like 'node_with_initd', p
    end

    context 'hub => []' do
      let(:params) {{ :hub => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::node')
        }.to raise_error
      end
    end
  end

  context 'for osfamily RedHat 7' do
    let(:facts) {{ :osfamily => 'RedHat', :operatingsystemmajrelease => 7 }}

    context 'no params' do
      it_behaves_like 'node_with_systemd', {}
    end

    context 'display => :42' do
      p = { :display => ':42' }
      let(:params) { p }

      it_behaves_like 'node_with_systemd', p
    end

    context 'display => :42' do
      let(:params) {{ :display => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::node')
        }.to raise_error
      end
    end

    context 'options => -foo' do
      p = { :options => '-foo' }
      let(:params) { p }

      it_behaves_like 'node_with_systemd', p
    end

    context 'options => []' do
      let(:params) {{ :options => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::node')
        }.to raise_error
      end
    end

    context 'hub => http://foo' do
      p = { :hub => 'http://foo' }
      let(:params) { p }

      it_behaves_like 'node_with_systemd', p
    end

    context 'hub => []' do
      let(:params) {{ :hub => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::node')
        }.to raise_error
      end
    end
  end
end
