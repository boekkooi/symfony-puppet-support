class symfony2::web::xdebug {
    php::module { "xdebug" : }

    augeas { 'set-xdebug-ini-values':
        incl => '/etc/php5/conf.d/20-xdebug.ini',
        lens    => 'Php.lns',
        changes => [
            'set Xdebug/xdebug.max_nesting_level 500',
            'set Xdebug/xdebug.remote_enable On',
            'set Xdebug/xdebug.remote_connect_back On',
            'set Xdebug/xdebug.remote_port 9000',
            'set Xdebug/xdebug.remote_handler dbgp',
            'set Xdebug/xdebug.remote_autostart On'
        ],
        require => Php::Module["xdebug"],
        notify  => Service['apache'],
    }
}
