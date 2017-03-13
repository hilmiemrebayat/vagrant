Invoke-WebRequest -Uri "https://www.microsoft.com/en-us/download/confirmation.aspx?id=42299" -OutFile "C:\Users\Vagrant\Destkop\sql.exe"
Invoke-WebRequest -Uri "https://goo.gl/0YZqxF" -OutFile "C:\Users\Vagrant\Destkop\sql.exe"
$configfile = "C:\Users\Vagrant\Destkop\ConfigurationFile.ini"
$command = "C:\Users\Vagrant\Destkop\sql.exe /ConfigurationFile=$($configfile)"
Invoke-Expression -Command $command 
