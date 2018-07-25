Vagrant.configure(2) do |config|
    config.vm.box = "skyzyx/centos7"
    config.vm.hostname = "dev-env"
    config.vm.define "dev-env"
    config.vm.box_check_update = false
    #enable this to sync the current dir with the VM
    #config.vm.synced_folder '.', './vagrant', disabled: true
    config.vm.provision "shell", path: "centos-fusion-install.sh"
    config.vm.provider 'vmware_fusion' do |vmw| #, override|
        vmw.vmx['memsize'] = 8192
        vmw.vmx['numvcpus'] = 3
        vmw.gui = true
    end # vmware_fusion
    config.vm.provider 'virtualbox' do |vb, override|
        override.vm.provision "shell", path: "centos-vbox-install.sh"
        vb.memory = 4096
        vb.cpus = 2
        vb.customize ["modifyvm", :id, "--vram", "128", "--clipboard", "bidirectional"]
        vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
        vb.gui = true
    end # vbox
end # configure

