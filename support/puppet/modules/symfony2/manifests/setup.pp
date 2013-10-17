class symfony2::setup {

    # Install some default packages
    $default_packages = [ "mc", "strace", "sysstat", ]
    package { $default_packages :
        ensure => present,
    }

    package { "git-core" :
        name => "git",
        ensure => present,
    }
}
