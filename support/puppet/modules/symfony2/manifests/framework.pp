class symfony2::framework {
    # Composer download
    exec { "composer_download" :
        command => "php -r \"eval('?>'.file_get_contents('https://getcomposer.org/installer'));\"",
        cwd     => "/vagrant/",
        require => [ Class["symfony2::web::php"], Package["git"] ],
        creates => "/vagrant/composer.phar",
        before  => Exec["composer_install"]
    }

    # Composer install
    exec { "composer_install" :
        command => "su vagrant -c '/vagrant/composer.phar install'",
        cwd     => "/vagrant/",
        require => [ Class["symfony2::web::php"], Package["git"] ],
    }

    # Setup parameters.yml if it does not exist yet
    # TODO parameters.yml auto set db info
    file { "parameters.yml" :
        path => "/vagrant/app/config/parameters.yml",
        source => '/vagrant/app/config/parameters.yml.dist',
        replace => "no",                                            # Don't update when file is present
        before  => Exec["composer_install"],
    }
}
