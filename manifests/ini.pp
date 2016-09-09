# = Define: php::ini
#
# With this you can alter/add a php ini file for a specific sapi target
# or for both cli and apache2 (default for Ubuntu|Debian|Mint|SLES|OpenSuSE)
#
# == Parameters
# [*value*]
#   String. Optional. Default: ''
#   The value to be added to the ini file
#
# [*template*]
#   String. Optional. Default: 'extra-ini.erb'
#   Template to use
#
# [*target*]
#   String. Optional. Default: 'extra.ini'
#   The configuration filename
#
# [*sapi_target*]
#   String. Optional. Default: 'all'
#   The target sapi for the configuration file.
#   Bu default it will try to apply the configuration to both cli and http
#
define php::ini (
  $value        = '',
  $template     = 'php/extra-ini.erb',
  $target       = 'extra.ini',
  $sapi_target  = 'all',
  $service      = $php::service,
  $config_dir   = $php::config_dir,
  $package      = $php::package
) {

  include php

  $realservice_autorestart = $::php::realservice_autorestart

  $http_sapi = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint|SLES|OpenSuSE)/ => '/apache2/',
    default                                 => '/',
  }

  case $::osfamily {
    'RedHat' : {
      file { "${config_dir}/${target}":
        ensure  => 'present',
        content => template($template),
        require => Package[$php::package],
        notify  => $realservice_autorestart,
      }
    }
    default : {
      if ($sapi_target == 'all') {

        file { "${config_dir}${http_sapi}conf.d/${target}":
          ensure  => 'present',
          content => template($template),
          require => Package[$package],
          before  => File["${config_dir}/cli/conf.d/${target}"],
          notify  => $realservice_autorestart,
        }

        file { "${config_dir}/cli/conf.d/${target}":
          ensure  => 'present',
          content => template($template),
          require => Package[$package],
        }

      }else{
        file { "${config_dir}/${sapi_target}/conf.d/${target}":
          ensure  => 'present',
          content => template($template),
          require => Package[$package],
          notify  => $realservice_autorestart,
        }

      }
    }
  }

}
