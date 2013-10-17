Vagrant::configure("2") do |config|
    # Use a standard box
    config.vm.box = 'ubuntu-precise-64'
    config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

    # Define our virtual machine settings
    config.vm.define :symfony2 do |symfony2|

        symfony2.vm.hostname = "<name>.dev"
        symfony2.vm.network :private_network, ip: "192.168.10.x"
        symfony2.vm.synced_folder ".", "/vagrant"

        # Customize our virtualbox provider.
        symfony2.vm.provider :virtualbox do |vbox|
            vbox.customize [
                "modifyvm", :id, "--name", "<name>", "--memory", 512, "--natdnshostresolver1", "on"
            ]
        end

        # Setup puppet modules using librarian-puppet
        symfony2.vm.provision :shell, :path => "support/puppet/librarian.sh"

        # Provision through puppet
        symfony2.vm.provision :puppet do |puppet|
            puppet.manifests_path = "support/puppet/manifests"
            puppet.manifest_file = "symfony2.pp"
#            puppet.options = [
#                '--verbose',
#                '--debug'
#            ]
        end
    end
end
