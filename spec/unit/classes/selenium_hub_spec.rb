require 'spec_helper'

describe 'selenium::hub', :type => :class do

  shared_examples 'hub_with_initd' do |params|
    p = {
      :options => '-role hub'
    }

    p.merge!(params) if params

    it do
      should contain_class('selenium')
      should contain_selenium__config('hub').with({
        'options' => p[:options],
        'initsystem' => 'init.d'
      })
      should contain_class('selenium::hub')
    end
  end

  shared_examples 'hub_with_systemd' do |params|
    p = {
        :options => '-role hub'
    }

    p.merge!(params) if params

    it do
      should contain_class('selenium')
      should contain_selenium__config('hub').with({
                                                      'options' => p[:options],
                                                      'initsystem' => 'systemd'
                                                  })
      should contain_class('selenium::hub')
    end
  end

  context 'for osfamily RedHat 6' do
    let(:facts) {{ :osfamily => 'RedHat', :operatingsystemmajrelease => 6 }}

    context 'no params' do
      it_behaves_like 'hub_with_initd', {}
    end

    context 'options => -foo' do
      p = { :options => '-foo' }
      let(:params) { p }

      it_behaves_like 'hub_with_initd', p
    end

    context 'options => []' do
      let(:params) {{ :options => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::hub')
        }.to raise_error
      end
    end
  end

  context 'for osfamily RedHat 7' do
    let(:facts) {{ :osfamily => 'RedHat', :operatingsystemmajrelease => 7 }}

    context 'no params' do
      it_behaves_like 'hub_with_systemd', {}
    end

    context 'options => -foo' do
      p = { :options => '-foo' }
      let(:params) { p }

      it_behaves_like 'hub_with_systemd', p
    end

    context 'options => []' do
      let(:params) {{ :options => [] }}

      it 'should fail' do
        expect {
          should contain_class('selenium::hub')
        }.to raise_error
      end
    end
  end
end
