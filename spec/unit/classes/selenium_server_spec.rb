require 'spec_helper'

describe 'selenium::server', :type => :class do


  shared_examples 'server_with_initd' do |params|
    p = {
        :display => ':0',
        :options => '-Dwebdriver.enable.native.events=1',
    }

    p.merge!(params) if params
    p[:options] += ' -log /opt/selenium/log/seleniumserver.log'

    it do
      should contain_class('selenium')
      should contain_selenium__config('server').with({
                                                         'display' => p[:display],
                                                         'options' => p[:options],
                                                         'initsystem' => 'init.d',
                                                     })
      should contain_class('selenium::server')
    end
  end

  shared_examples 'server_with_systemd' do |params|
    p = {
      :display => ':0',
      :options => '-Dwebdriver.enable.native.events=1',
    }

    p.merge!(params) if params
    p[:options] += ' -log /opt/selenium/log/seleniumserver.log'


    it do
      should contain_class('selenium')
      should contain_selenium__config('server').with({
        'display' => p[:display],
        'options' => p[:options],
        'initsystem' => 'systemd',
      })
      should contain_class('selenium::server')
    end
  end

  context 'for osfamily RedHat 6' do
    let(:facts) {{ :osfamily => 'RedHat', :operatingsystemmajrelease => 6 }}

    context 'no params' do
      it_behaves_like 'server_with_initd', {}
    end

    context 'display => :42' do
      p = { :display => ':42' }
      let(:params) { p }

      it_behaves_like 'server_with_initd', p
    end

    context 'display => :42' do
      let(:params) {{ :display => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::server')
        }.to raise_error
      end
    end

    context 'options => -foo' do
      p = { :options => '-foo' }
      let(:params) { p }

      it_behaves_like 'server_with_initd', p
    end

    context 'options => []' do
      let(:params) {{ :options => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::server')
        }.to raise_error
      end
    end
  end

  context 'for osfamily RedHat 7' do
    let(:facts) {{ :osfamily => 'RedHat', :operatingsystemmajrelease => 7 }}

    context 'no params' do
      it_behaves_like 'server_with_systemd', {}
    end

    context 'display => :42' do
      p = { :display => ':42' }
      let(:params) { p }

      it_behaves_like 'server_with_systemd', p
    end

    context 'display => :42' do
      let(:params) {{ :display => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::server')
        }.to raise_error
      end
    end

    context 'options => -foo' do
      p = { :options => '-foo' }
      let(:params) { p }

      it_behaves_like 'server_with_systemd', p
    end

    context 'options => []' do
      let(:params) {{ :options => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::server')
        }.to raise_error
      end
    end
  end
end
