class symfony2::web($host, $port = 80, $phpmyadmin = false, $xdebug = false, $dev = false) {

    # Make sure we have run initial setup first!
    Class['symfony2::setup'] -> Class['symfony2::web']

    # Include the apache webserver
    include apache

    # Install mod rewrite
    apache::module { 'rewrite': }

    # Configure apache virtual host
    apache::vhost { "symfony2_vhost":
        name => $host,
        docroot   => "/vagrant/web",
        port      => $port,
        directory => "/vagrant/",
        directory_options => '+FollowSymLinks',
        directory_allow_override => 'ALL'
    }

    # Install PHP
    class { "symfony2::web::php" :
        dev => $dev
    }

    # Install xdebug if needed
    if ($xdebug == true) or ($dev == true) {
        class { "symfony2::web::xdebug" : }
    }

    # Do we need phpmyadmin?
    if $phpmyadmin == true {
        class { "symfony2::web::phpmyadmin" : }
    }

    # Change user / group
    exec { "UsergroupChange" :
        command => "sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=vagrant/ ; s/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars",
        onlyif  => "grep -c 'APACHE_RUN_USER=www-data' /etc/apache2/envvars",
        require => Package["apache"],
        notify  => Service['apache'],
    }

    file { "/var/lock/apache2" :
        owner  => "vagrant",
        group  => "root",
        mode   => 0755,
        require => Package["apache"],
        notify  => Service['apache'],
    }

    file { "/etc/apache2/sites-enabled/000-default" :
        ensure => absent,
        require => Package["apache"],
        notify  => Service['apache'],
    }
}
