Configuration SQLInstall
{
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PackagePath = "../resources/"
    )

    Node $AllNodes.where{ $_.Role.Contains("SqlServer") }.NodeName
    {
        Log ParamLog
        {
            Message = "Running SQLInstall. PackagePath = $PackagePath"
        }

        #
        # Ensure that .NET framework features are installed (pre-reqs for SQL)
        #
        WindowsFeature NetFramework35Core
        {
            Name = "NET-Framework-Core"
            Ensure = "Present"
        }

        WindowsFeature NetFramework45Core
        {
            Name = "NET-Framework-45-Core"
            Ensure = "Present"
        }

        # copy the sqlserver iso
        File SQLServerIso
        {
            SourcePath = "$PackagePath\en_sql_server_2014_enterprise_edition_with_service_pack_1_x64_dvd_6669618.iso"
            DestinationPath = "c:\temp\SQLServer.iso"
            Type = "File"
            Ensure = "Present"
            Credential = $Credential
        }

        # copy the ini file to the temp folder
        File SQLServerIniFile
        {
            SourcePath = "$PackagePath\ConfigurationFile.ini"
            DestinationPath = "c:\temp"
            Type = "File"
            Ensure = "Present"
            Credential = $Credential
            DependsOn = "[File]SQLServerIso"
        }

        #
        # Install SqlServer using ini file
        #
        Script InstallSQLServer
        {
            GetScript = 
            {
                $sqlInstances = gwmi win32_service -computerName localhost | ? { $_.Name -match "mssql*" -and $_.PathName -match "sqlservr.exe" } | % { $_.Caption }
                $res = $sqlInstances -ne $null -and $sqlInstances -gt 0
                $vals = @{ 
                    Installed = $res; 
                    InstanceCount = $sqlInstances.count 
                }
                $vals
            }
            SetScript = 
            {
                # mount the iso
                $setupDriveLetter = (Mount-DiskImage -ImagePath c:\temp\SQLServer.iso -PassThru | Get-Volume).DriveLetter + ":"
                if ($setupDriveLetter -eq $null) {
                    throw "Could not mount SQL install iso"
                }
                Write-Verbose "Drive letter for iso is: $setupDriveLetter"
                
                # run the installer using the ini file
                $cmd = "$setupDriveLetter\Setup.exe /ConfigurationFile=c:\temp\ConfigurationFile.ini /SQLSVCPASSWORD=P2ssw0rd /AGTSVCPASSWORD=P2ssw0rd /SAPWD=P2ssw0rd"
                Write-Verbose "Running SQL Install - check %programfiles%\Microsoft SQL Server\120\Setup Bootstrap\Log\ for logs..."
                Invoke-Expression $cmd | Write-Verbose
            }
            TestScript =
            {
                $sqlInstances = gwmi win32_service -computerName localhost | ? { $_.Name -match "mssql*" -and $_.PathName -match "sqlservr.exe" } | % { $_.Caption }
                $res = $sqlInstances -ne $null -and $sqlInstances -gt 0
                if ($res) {
                    Write-Verbose "SQL Server is already installed"
                } else {
                    Write-Verbose "SQL Server is not installed"
                }
                $res
            }
        }
    }
}

# command for RM
#SQLInstall -ConfigurationData $configData -PackagePath "\\rmserver\Assets"

# test from command line
SQLInstall -ConfigurationData configData.psd1 -PackagePath "\\rmserver\Assets"
Start-DscConfiguration -Path .\SQLInstall -Verbose -Wait -Force
