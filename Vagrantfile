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
    #Install IIS on Windows Server
    config.vm.provision :shell, path: "scripts/installatieIIS.ps1"
    
    #Install Chocolatey on Windows Server. You can install MySQL very easy With Chocolatey.
    #config.vm.provision :shell, path: "scripts/Chocolatey.ps1"
    
    #Download and install MySQL with Chocolatey on Windows Server
    #config.vm.provision :shell, path: "scripts/InstalleerMySQL.ps1"
    
    # Change keyboard settings on Windows Server
    config.vm.provision :shell, path: "scripts/toetsenbord-instellen.ps1"
    
    #METHOD 1: Download and install SQL Server on Windows Server (Doesn't work at the moment)
    config.vm.provision :shell, path: "scripts/installeerSQL.ps1"
    
    #METHODE 2: Download and install SQL Server on Windows Server (Doesn't work at the moment)
    #config.vm.provision :shell, path: "scripts/SQLInstall.ps1"

    #Configure MySQL (mysql_secure_installation) (Doesn't work at the moment)
    #config.vm.provision :shell, path: "scripts/configureerMySQL.bat"


end

 
