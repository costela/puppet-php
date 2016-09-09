require 'spec_helper'

describe 'php::ini' do

  let(:title) { 'php::ini' }
  let(:node) { 'rspec.example42.com' }

  context 'Test with restart' do
    context 'On a Debian OS' do
      let :facts do
        {
          :operatingsystem => 'Debian',
          :osfamily        => 'Debian',
        }
      end

      let :pre_condition do
        [
          'service { "apache2": }',
          'class { "php": }',
        ]
      end

      context 'with sapi_target all' do
        let :params do
          {
            :name        => 'dynatrace',
            :target      => 'dynatrace.ini',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/php5/apache2/conf.d/dynatrace.ini') }
        it { is_expected.to contain_file('/etc/php5/cli/conf.d/dynatrace.ini') }

        it { should contain_file('/etc/php5/apache2/conf.d/dynatrace.ini').that_notifies('Service[apache2]') }
      end

      context 'with sapi_target customsapi' do
        let :params do
          {
            :name        => 'dynatrace',
            :target      => 'dynatrace.ini',
            :sapi_target => 'customsapi',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/php5/customsapi/conf.d/dynatrace.ini') }

        it { should contain_file('/etc/php5/customsapi/conf.d/dynatrace.ini').that_notifies('Service[apache2]') }
      end
    end

    context 'On a RedHat OS' do
      let :facts do
        {
          :operatingsystem => 'Redhat',
          :osfamily        => 'RedHat',
        }
      end

      let :pre_condition do
        [
          'service { "httpd": }',
          'class { "php": }',
        ]
      end

      context 'with defaults' do
        let :params do
          {
            :name        => 'dynatrace',
            :target      => 'dynatrace.ini',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/php.d/dynatrace.ini') }

        it { should contain_file('/etc/php.d/dynatrace.ini').that_notifies('Service[httpd]') }
      end

    end
  end

  context 'Test without restart' do
    context 'On a Debian OS' do
      let :facts do
        {
          :operatingsystem => 'Debian',
          :osfamily        => 'Debian',
        }
      end

      let :pre_condition do
        [
          'service { "apache2": }',
          'class { "php": service_autorestart => false, }',
        ]
      end

      context 'with sapi_target all' do
        let :params do
          {
            :name        => 'dynatrace',
            :target      => 'dynatrace.ini',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/php5/apache2/conf.d/dynatrace.ini') }
        it { is_expected.to contain_file('/etc/php5/cli/conf.d/dynatrace.ini') }

        it { should_not contain_file('/etc/php5/apache2/conf.d/dynatrace.ini').that_notifies('Service[apache2]') }
      end

      context 'with sapi_target customsapi' do
        let :params do
          {
            :name        => 'dynatrace',
            :target      => 'dynatrace.ini',
            :sapi_target => 'customsapi',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/php5/customsapi/conf.d/dynatrace.ini') }

        it { should_not contain_file('/etc/php5/customsapi/conf.d/dynatrace.ini').that_notifies('Service[apache2]') }

      end
    end

    context 'On a RedHat OS' do
      let :facts do
        {
          :operatingsystem => 'Redhat',
          :osfamily        => 'RedHat',
        }
      end

      let :pre_condition do
        [
          'service { "httpd": }',
          'class { "php": service_autorestart => false, }',
        ]
      end

      context 'with defaults' do
        let :params do
          {
            :name        => 'dynatrace',
            :target      => 'dynatrace.ini',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/php.d/dynatrace.ini') }

        it { should_not contain_file('/etc/php.d/dynatrace.ini').that_notifies('Service[httpd]') }
      end

    end
  end

end
