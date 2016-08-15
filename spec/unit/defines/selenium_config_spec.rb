require 'spec_helper'

describe 'selenium::config', :type => :define do
  shared_examples 'config' do |params|
    let :pre_condition do
      "include selenium"
    end

    p = {
      :display      => ':0',
      :user         => 'selenium',
      :install_root => '/opt/selenium',
      :jar_name     => "selenium-server-standalone-#{DEFAULT_VERSION}.jar",
      :options      => '-Dwebdriver.enable.native.events=1',
      :java         => 'java',
      :initsystem   => 'init.d',

    }

    p.merge!(params) if params

    it do
      should contain_file("selenium#{title}").with({
        'ensure' => 'file',
        'path'   => "/etc/init.d/selenium#{title}",
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
      }).
        with_content(/# selenium#{title} Selenium server init script/).
        with_content(/SLNM_DISPLAY='#{p[:display]}'/).
        with_content(/SLNM_USER='#{p[:user]}'/).
        with_content(/SLNM_INSTALL_ROOT='#{p[:install_root]}'/).
        with_content(/SLNM_JAR_NAME='#{p[:jar_name]}'/).
        with_content(/SLNM_OPTIONS='#{p[:options]}'/).
        with_content(/SLNM_JAVA='#{p[:java]}'/).
        with_content(/SLNM_LOG_NAME='#{title}'/).
        with_content(/prog='selenium#{title}'/).
        with_content(/SLNM_EXEC_COMMAND='-jar #{p[:install_root]}\/jars\/#{p[:jar_name]}'/)
      should contain_service("selenium#{title}").with({
        :ensure     => 'running',
        :hasstatus  => 'true',
        :hasrestart => 'true',
        :enable     => 'true',
      })
    end
  end

  shared_examples 'config_with_systemd_classpath' do |params|
    let :pre_condition do
      "include selenium"
    end

    p = {
        :display      => ':0',
        :user         => 'seleniums',
        :install_root => '/opt/selenium',
        :jar_name     => "selenium-server-standalone-#{DEFAULT_VERSION}.jar",
        :options      => '-Dwebdriver.enable.native.events=1',
        :java         => 'java',
        :initsystem   => 'systemd',
    }

    p.merge!(params) if params

    it do
      should contain_file("selenium#{title}").with({
                                                          'ensure' => 'file',
                                                          'path'   => "/usr/lib/systemd/system/selenium#{title}.service",
                                                          'owner'  => 'root',
                                                          'group'  => 'root',
                                                          'mode'   => '0755',
                                                      })
          should contain_service("selenium#{title}").with({
                                                              :ensure     => 'running',
                                                              :hasstatus  => 'true',
                                                              :hasrestart => 'true',
                                                              :enable     => 'true',
                                                          })
    end
  end

  shared_examples 'config_with_systemd' do |params|
    let :pre_condition do
      "include selenium"
    end

    p = {
        :display      => ':0',
        :user         => 'seleniums',
        :install_root => '/opt/selenium',
        :jar_name     => "selenium-server-standalone-#{DEFAULT_VERSION}.jar",
        :options      => '-Dwebdriver.enable.native.events=1',
        :java         => 'java',
        :initsystem   => 'systemd',
    }

    p.merge!(params) if params

    it do
      should contain_file("selenium#{title}").with({
                                                       'ensure' => 'file',
                                                       'path'   => "/usr/lib/systemd/system/selenium#{title}.service",
                                                       'owner'  => 'root',
                                                       'group'  => 'root',
                                                       'mode'   => '0755',
                                                   })
      should contain_service("selenium#{title}").with({
                                                          :ensure     => 'running',
                                                          :hasstatus  => 'true',
                                                          :hasrestart => 'true',
                                                          :enable     => 'true',
                                                      })
    end
  end

  shared_examples 'config_with_classpath' do |params|
    let :pre_condition do
      "include selenium"
    end

    p = {
      :display      => ':0',
      :user         => 'selenium',
      :install_root => '/opt/selenium',
      :jar_name     => "selenium-server-standalone-#{DEFAULT_VERSION}.jar",
      :options      => '-Dwebdriver.enable.native.events=1',
      :java         => 'java',
      :classpath    => ['/my/custom/jarfile.jar'],
      :initsystem   => 'init.d'
    }

    p.merge!(params) if params

    it do
      should contain_file("selenium#{title}").with({
        'ensure' => 'file',
        'path'   => "/etc/init.d/selenium#{title}",
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
      }).
        with_content(/# selenium#{title} Selenium server init script/).
        with_content(/SLNM_DISPLAY='#{p[:display]}'/).
        with_content(/SLNM_USER='#{p[:user]}'/).
        with_content(/SLNM_INSTALL_ROOT='#{p[:install_root]}'/).
        with_content(/SLNM_JAR_NAME='#{p[:jar_name]}'/).
        with_content(/SLNM_OPTIONS='#{p[:options]}'/).
        with_content(/SLNM_JAVA='#{p[:java]}'/).
        with_content(/SLNM_LOG_NAME='#{title}'/).
        with_content(/prog='selenium#{title}'/).
        with_content(/SLNM_EXEC_COMMAND='-cp #{p[:install_root]}\/jars\/#{p[:jar_name]}:#{p[:classpath].join(":")} org.openqa.grid.selenium.GridLauncher'/)
      should contain_service("selenium#{title}").with({
        :ensure     => 'running',
        :hasstatus  => 'true',
        :hasrestart => 'true',
        :enable     => 'true',
      })
    end
  end

  context 'for osfamily RedHat 7' do
    let(:facts) {{ :osfamily => 'RedHat', :operatingsystemmajrelease => 7 }}

    context "server" do
      let(:title) { 'server' }

      context 'no params' do
        it_behaves_like 'config_with_systemd', {}
      end

      context 'all params' do
        params = {
            :display      => 'X:0',
            :user         => 'Xselenium',
            :install_root => 'X/opt/selenium',
            :jar_name     => 'Xselenium-server-standalone-x.xx.x.jar',
            :options      => 'X-Dwebdriver.enable.native.events=1',
            :java         => 'Xjava',
            :initsystem   => 'systemd',
        }

        let(:params) { params }

        it_behaves_like 'config_with_systemd', params
      end

      context 'all params with custom classpath' do
        params = {
            :display      => 'X:0',
            :user         => 'Xselenium',
            :install_root => 'X/opt/selenium',
            :jar_name     => 'Xselenium-server-standalone-x.xx.x.jar',
            :options      => 'X-Dwebdriver.enable.native.events=1',
            :java         => 'Xjava',
            :classpath    => ['X/my/custom/jarfile.jar'],
            :initsystem   => 'systemd',
        }

        let(:params) { params }

        it_behaves_like 'config_with_systemd_classpath', params
      end
    end

    context "hub" do
      let(:title) { 'hub' }

      context 'no params' do
        it_behaves_like 'config_with_systemd', {}
      end

      context 'all params' do
        params = {
            :display      => 'X:0',
            :user         => 'Xselenium',
            :install_root => 'X/opt/selenium',
            :jar_name     => 'Xselenium-server-standalone-x.xx.x.jar',
            :options      => 'X-Dwebdriver.enable.native.events=1',
            :java         => 'Xjava',
            :initsystem   => 'systemd',
        }

        let(:params) { params }

        it_behaves_like 'config_with_systemd', params
      end

      context 'all params with custom classpath' do
        params = {
            :display      => 'X:0',
            :user         => 'Xselenium',
            :install_root => 'X/opt/selenium',
            :jar_name     => 'Xselenium-server-standalone-x.xx.x.jar',
            :options      => 'X-Dwebdriver.enable.native.events=1',
            :java         => 'Xjava',
            :classpath    => ['X/my/custom/jarfile.jar'],
            :initsystem   => 'systemd',
        }

        let(:params) { params }

        it_behaves_like 'config_with_systemd_classpath', params
      end
    end
  end

  context 'for osfamily RedHat 6' do
    let(:facts) {{ :osfamily => 'RedHat', :operatingsystemmajrelease => 6 }}

    context "server" do
      let(:title) { 'server' }

      context 'no params' do
        it_behaves_like 'config', {}
      end

      context 'all params' do
        params = {
          :display      => 'X:0',
          :user         => 'Xselenium',
          :install_root => 'X/opt/selenium',
          :jar_name     => 'Xselenium-server-standalone-x.xx.x.jar',
          :options      => 'X-Dwebdriver.enable.native.events=1',
          :java         => 'Xjava',
        }

        let(:params) { params }

        it_behaves_like 'config', params
      end

      context 'all params with custom classpath' do
        params = {
          :display      => 'X:0',
          :user         => 'Xselenium',
          :install_root => 'X/opt/selenium',
          :jar_name     => 'Xselenium-server-standalone-x.xx.x.jar',
          :options      => 'X-Dwebdriver.enable.native.events=1',
          :java         => 'Xjava',
          :classpath    => ['X/my/custom/jarfile.jar'],
        }

        let(:params) { params }

        it_behaves_like 'config_with_classpath', params
      end
    end

    context "hub" do
      let(:title) { 'hub' }

      context 'no params' do
        it_behaves_like 'config', {}
      end

      context 'all params' do
        params = {
          :display      => 'X:0',
          :user         => 'Xselenium',
          :install_root => 'X/opt/selenium',
          :jar_name     => 'Xselenium-server-standalone-x.xx.x.jar',
          :options      => 'X-Dwebdriver.enable.native.events=1',
          :java         => 'Xjava',
        }

        let(:params) { params }

        it_behaves_like 'config', params
      end

      context 'all params with custom classpath' do
        params = {
          :display      => 'X:0',
          :user         => 'Xselenium',
          :install_root => 'X/opt/selenium',
          :jar_name     => 'Xselenium-server-standalone-x.xx.x.jar',
          :options      => 'X-Dwebdriver.enable.native.events=1',
          :java         => 'Xjava',
          :classpath    => ['X/my/custom/jarfile.jar'],
        }

        let(:params) { params }

        it_behaves_like 'config_with_classpath', params
      end
    end
  end

  context 'for osfamily Debian' do
    let(:title) { 'server' }
    let(:facts) {{ :osfamily => 'Debian', :operatingsystemmajrelease => 8 }}
    let :pre_condition do
      "include selenium"
    end

    it { should contain_package('daemon').with_ensure('present') }
  end

end
