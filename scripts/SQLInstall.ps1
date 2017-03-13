Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?LinkID=799012" -OutFile "C:\Users\vagrant\Desktop\setup.exe"
Invoke-WebRequest -Uri "https://goo.gl/0YZqxF" -OutFile "C:\Users\Vagrant\Desktop\ConfigurationFile.ini"
$configfile = "C:\Users\Vagrant\Desktop\ConfigurationFile.ini"
$command = "C:\Users\Vagrant\Desktop\setup.exe /ConfigurationFile=$($configfile)"
Invoke-Expression -Command $command 
