class symfony2::create_db (
        $dbhost = "localhost",
        $dbname = "symfony2",
        $dbuser = "symfony2",
        $dbpass = "secret"
    ) {

    # Symfony2 must be initialized properly
    Class["symfony2::framework"] -> Class["symfony2::create_db"]
    Class["symfony2::mysql"] -> Class["symfony2::create_db"]

    # We don't need to have the MySQL server running on the system in order
    # to create our database just make sure we have a client
    package { "mysql-client" :
        ensure => installed,
    }

    # create our initial db
    exec { 'create_db':
        unless => "/usr/bin/mysql -h ${dbhost} -u${dbuser} -p${dbpass} ${dbname} -e \"show tables\"",
        command => "/usr/bin/mysql -u root -e \"create database ${dbname}; GRANT ALL ON ${dbname}.* to ${dbuser}@localhost identified by '${dbpass}';GRANT FILE ON *.* to ${dbuser}@localhost identified by '${dbpass}';\"",
        require => Package["mysql-client"],
    }

    # Initialize schema
    exec { "init_db" :
        command => "/usr/bin/php /vagrant/app/console doctrine:schema:create || true",
        creates => "/tmp/.sf2seeded",
        require => Exec["create_db"],
    }
}
