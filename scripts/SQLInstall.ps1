Invoke-WebRequest -Uri "https://www.microsoft.com/en-us/download/confirmation.aspx?id=42299" -OutFile "C:\Users\vagrant\Desktop\setup.exe"
Invoke-WebRequest -Uri "https://goo.gl/0YZqxF" -OutFile "C:\Users\Vagrant\Destkop\ConfigurationFile.ini"
$configfile = "C:\Users\Vagrant\Desktop\ConfigurationFile.ini"
$command = "C:\Users\Vagrant\Desktop\setup.exe /ConfigurationFile=$($configfile)"
Invoke-Expression -Command $command 
