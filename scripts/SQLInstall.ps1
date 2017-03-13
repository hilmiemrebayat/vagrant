$configfile = "ConfigurationFile.ini"
$command = "resources\setup.exe /ConfigurationFile=$($configfile)"
Invoke-Expression -Command $comand 
