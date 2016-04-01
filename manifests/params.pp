# Class: php::params
#
# This class defines default parameters used by the main module class php
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to php class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class php::params {

  $package_devel = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint)/ => 'php5-dev',
    /(?i:SLES|OpenSuSe)/      => 'php5-devel',
    /(?i:Solaris)/            => $::operatingsystemmajrelease ? {
      '10'                    => 'CSWphp5-dev',
      '11'                    => undef,
    },
    default                   => 'php-devel',
  }

  $package_pear = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint)/ => 'php-pear',
    /(?i:SLES|OpenSuSe)/      => 'php5-pear',
    /(?i:Solaris)/            => undef,
    default                   => 'php-pear',
  }

  ### Application related parameters
  $module_prefix = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint|SLES|OpenSuSE)/ => 'php5-',
    /(?i:Solaris)/                          => $::operatingsystemmajrelease ? {
      '10'                                  => 'CSWphp5-',
      '11'                                  => 'web/php-53/extension/php-',
    },
    default                                 => 'php-',
  }

  $pear_module_prefix = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint)/             => 'php-',
    /(?i:SLES|OpenSuSe)/                  => 'php5-pear-',
    /(?i:CentOS|RedHat|Scientific|Linux)/ => 'php-pear-',
    /(?i:Solaris)/                        => undef,
    default                               => 'pear-',
  }

  $package = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint)/ => 'php5',
    /(?i:SLES|OpenSuSE)/      => [ 'php5','apache2-mod_php5'],
    /(?i:Solaris)/            => $::operatingsystemmajrelease ? {
      '10'                    => ['CSWphp5', 'CSWap2-modphp5'],
      '11'                    => ['web/php-53', 'web/server/apache-22/module/apache-php53'],
    },
    default                   => 'php',
  }

  # Here it's not the php service script name but
  # web service name like apache2, nginx, etc.
  $service = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint|SLES|OpenSuSE)/ => 'apache2',
    /(?i:Solaris)/                          => $::operatingsystemmajrelease ? {
      '10'                                  => 'svc:/network/cswapache2:default',
      '11'                                  => 'svc:/network/http:apache22',
    },
    default                                 => 'httpd',
  }

  $config_dir = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint|SLES|OpenSuSE)/ => '/etc/php5',
    /(?i:Solaris)/                          => $::operatingsystemmajrelease ? {
      '10'                                  => '/etc/opt/csw/php5',
      '11'                                  => '/etc/php/5.3',
    },
    default                                 => '/etc/php.d',
  }

  $config_file = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint|SLES|OpenSuSE)/ => '/etc/php5/apache2/php.ini',
    /(?i:Solaris)/                          => $::operatingsystemmajrelease ? {
      '10'                                  => '/etc/opt/csw/php5/php.ini',
      '11'                                  => '/etc/php/5.3/php.ini',
    },
    default                                 => '/etc/php.ini',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $data_dir = $::operatingsystem ? {
    default => '',
  }

  $log_dir = $::operatingsystem ? {
    default => '',
  }

  $log_file = $::operatingsystem ? {
    default => '',
  }

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $augeas = false
  $template = ''
  $options = ''
  $version = 'present'
  $service_autorestart = true
  $absent = false
  $install_options = []

  ### General module variables that can have a site or per module default
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false

}
