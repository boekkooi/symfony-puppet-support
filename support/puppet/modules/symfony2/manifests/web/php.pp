class symfony2::web::php($dev = false)  {

    package { [ "libapache2-mod-php5", "php5-cli" ] :
        ensure => installed,
    }

    # Install PHP modules
    package { "php-apc" :
        require => Package['php5-cli']
    }
    package { "php5-mysql" :
        require => Package['php5-cli']
    }
    package { "php5-intl" :
        require => Package['php5-cli']
    }

    # Set developer options?
    if $dev == true {
        # Set development values to our php.ini and xdebug.ini
        augeas { 'set-apache-php-ini-values':
            incl => '/etc/php5/apache2/php.ini',
            lens    => 'Php.lns',
            changes => [
                'set PHP/error_reporting "E_ALL | E_STRICT"',
                'set PHP/display_errors On',
                'set PHP/display_startup_errors On',
                'set PHP/html_errors On',
                'set Date/date.timezone Europe/Amsterdam',
                'set PHP/short_open_tag Off'
            ],
            require => Package['libapache2-mod-php5'],
            notify  => Service['apache'],
        }

        augeas { 'set-php-ini-values':
            incl => '/etc/php5/cli/php.ini',
            lens    => 'Php.lns',
            changes => [
                'set PHP/error_reporting "E_ALL | E_STRICT"',
                'set PHP/display_errors On',
                'set PHP/display_startup_errors On',
                'set PHP/html_errors On',
                'set Date/date.timezone Europe/Amsterdam',
                'set PHP/short_open_tag Off'
            ],
            require => Package['php5-cli'],
            notify  => Service['apache'],
        }
    }
}
