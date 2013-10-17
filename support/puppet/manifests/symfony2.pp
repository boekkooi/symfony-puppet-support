# Include augeas
include augeas

# Set default path for Exec calls
Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}

# Setup Symfony
node default {
    # Setup Symfony2
    class { "symfony2" :
        host => '<name>.dev',

        dbname => 'symfony2',
        dbuser => 'symfony2',
        dbpass => 'secret',

        dev => true,
        phpmyadmin => true
    }

    # Setup NodeJs and install npm packages
    class { 'nodejs':
        version => '0.10.*',
        manage_repo => true
    } ->
    package { 'less':
        ensure   => '1.4.1',
        provider => 'npm',
    } ->
    package { 'handlebars':
        ensure   => '1.0.12',
        provider => 'npm',
    } ->
    package { 'uglify-js':
        ensure   => '2.4.0',
        provider => 'npm',
    } ->
    package { 'uglifycss':
        ensure   => '0.0.5',
        provider => 'npm',
    }

    # Install capifony for deployment
    package { 'curl':
        ensure   => installed
    }
    package { 'capifony':
        ensure   => 'latest',
        provider => 'gem',
    }
}
