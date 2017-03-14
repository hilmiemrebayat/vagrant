#Download SQL Server 2016 from Microsoft website
Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?LinkID=799012" -OutFile "C:\Users\vagrant\Desktop\setup.exe"
#Downlaod SQL configuration file from google drive
Invoke-WebRequest -Uri "https://goo.gl/9994dA" -OutFile "C:\Users\Vagrant\Desktop\SQLConfigurationFile.ini"
#Set location of SQL configuration file
$configfile = "C:\Users\Vagrant\Desktop\SQLConfigurationFile.ini"
#Set location of SQL Server 2016
$command = "C:\Users\Vagrant\Desktop\setup.exe /ConfigurationFile=$($configfile)"
#Install SQL Server
Invoke-Expression -Command $command 
