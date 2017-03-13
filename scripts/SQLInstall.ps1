$configfile = "ConfigurationFile.ini"
$command = "C:\HashiCorp\Vagrant\vagrant\scripts\resources\setup.exe /ConfigurationFile=$($configfile)"
Invoke-Expression -Command $command 
