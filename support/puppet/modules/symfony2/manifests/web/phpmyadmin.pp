class symfony2::web::phpmyadmin {

    # Install PHPMyAdmin
    package { "phpmyadmin" :
        ensure  => present
    }

    file { '/etc/apache2/conf.d/phpmyadmin.conf':
       ensure => 'link',
       target => '/etc/phpmyadmin/apache.conf',
       require => Package["phpmyadmin"],
       notify  => Service['apache'],
    }
}
