# -*- mode: ruby -*-
# vi: set ft=ruby :

  Vagrant.configure("2") do |config|
    config.vm.define "vagrant-windows-2012-r2"
    config.vm.box = "kensykora/windows_2012_r2_standard"
    config.vm.communicator = "winrm"

    # Admin user name and password
    config.winrm.username = "vagrant"
    config.winrm.password = "vagrant"

    config.vm.guest = :windows
    config.windows.halt_timeout = 15

    config.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    config.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true

    config.vm.provider :virtualbox do |v, override|
        #v.gui = true
        v.customize ["modifyvm", :id, "--memory", 2048]
        v.customize ["modifyvm", :id, "--cpus", 2]
        v.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
    config.vm.provision :shell, path: "scripts/installatieIIS.ps1"
        config.vm.provision :shell, path: "scripts/Chocolatey.ps1"
    config.vm.provision :shell, path: "InstalleerMySQL.ps1"

        config.vm.provision :shell, path: "scripts/configureerMySQL.ps1"

    config.vm.provision :shell, path: "scripts/veranderKeyboard.ps1"

end

 
