Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?LinkID=799012" -OutFile "C:\Users\vagrant\Desktop\setup.exe"
Invoke-WebRequest -Uri "https://goo.gl/9994dA" -OutFile "C:\Users\Vagrant\Desktop\SQLConfigurationFile.ini"
$configfile = "C:\Users\Vagrant\Desktop\SQLConfigurationFile.ini"
$command = "C:\Users\Vagrant\Desktop\setup.exe /ConfigurationFile=$($configfile)"
Invoke-Expression -Command $command 
