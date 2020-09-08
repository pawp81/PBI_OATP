param (
	[string]$csvDirPath, # Folder where the ATP csv files will be stored
	[string]$userFilePath,  # Office 365 User details file name
	[switch]$MFA, #is the account MFA enabled? if yes. Set to True. Should not be used together with $Cert
	[switch]$InsertToSQL  ,# Set to true if data will be inserted into SQL Database
	[switch]$IsAzureSQLServer, # Set to true if SQL Server is Azure SQL Server
	[string]$ServerName, #ServerName
	[string]$Database, #Database
	[switch]$NoAAD, #Option to skip to download user details
	[string]$Cert, #Certificate thumbprint. When set username and password will not be used for authentication instead. Should not be used together with $MFA
	[string]$Tenantname, #Tenant name. For example contoso.onmicrosoft.com
	[string]$AppID # Azure AD app application ID
    )
 
Write-Host "Following are the details provided:"
Write-Host " csvDirPath            :"   $csvDirPath
Write-Host " userFilePath          :"   $userFilePath
Write-Host " MFA                   :"   $MFA
Write-Host " ServerName            :"   $ServerName
Write-Host " Database              :"   $Database
Write-Host " InsertToSQL           :"   $InsertToSQL  
Write-Host " IsAzureSQLServer      :"   $IsAzureSQLServer 
Write-Host " NoAAD                 :" $NoAAD
Write-Host " Cert              	   :" $Cert
Write-Host " Tenantname            :" $tenantname
Write-Host " AppID                 :" $AppID
try        
{          

#Initialization
 $reportStartDate
 $cloudCreds
 $AzureUserCreds
 $credentials
 $lastModifiedFileName
 $fileIteratorConstant
 $SQLMaxDate
    
#Create error log folder

$logDirectory = $PSScriptRoot + "\Log"
New-Item -ItemType Directory -Force -Path $logDirectory
    
    if(!(Get-Command "Connect-AzureAD" -ErrorAction:SilentlyContinue)){
        Write-Host "Installing AzureAD"
        Install-Module -Name AzureAD
        Write-Host "Installed AzureAD"
    }
	
	if($MFA)
    {
     Write-Host "Authorzing via MFA"
     If(!(Get-Command "Connect-EXOPSSession" -ErrorAction:SilentlyContinue)) {

            # Change back path after completion
            $CurrentPath = Get-Location

            Write-Host "$(Get-Date) Not ran from an EXO PowerShell Module window - attempt to autoload starting"
            # Attempt to load automatically
            $modules = @(Get-ChildItem -Path "$($env:LOCALAPPDATA)\Apps\2.0" -Filter "Microsoft.Exchange.Management.ExoPowershellModule.manifest" -Recurse )
            $moduleName =  Join-Path $modules[0].Directory.FullName "Microsoft.Exchange.Management.ExoPowershellModule.dll"
            Import-Module -FullyQualifiedName $moduleName -Force
            
            If(!(Get-Command "Connect-EXOPSSession" -ErrorAction:SilentlyContinue)) {
                Write-Error "Run from a Exchange Online MFA Enabled PowerShell window to auto connect. Attempt to automatically load failed. http://aka.ms/exopspreview"
                Exit
            }            
            # Change back path
            Set-Location $CurrentPath
            } 
        Write-Host "$(Get-Date) Connecting to Exchange Online.."
        Connect-EXOPSSession -PSSessionOption $ProxySetting -WarningAction:SilentlyContinue | Out-Null
        
        if($NoAAD -eq $null -or $NoAAD -eq $false)
        {
 
        Write-Host "Connecting to Azure Active Directory"
        
        Connect-AzureAD
		Write-Host "Fetching data from Azure Active Directory. It can take a while depending on the size of your organization"
        $result = Get-AzureADUser -All $true | Select-Object ObjectType,AccountEnabled,AgeGroup,City,CompanyName,Country,CreationType,Department,DirSyncEnabled,DisplayName,GivenName,IsCompromised,ImmutableId,JobTitle,LastDirSyncTime,LegalAgeGroupClassification,Mail,MailNickName,OnPremisesSecurityIdentifier,State,StreetAddress,Surname,UsageLocation,UserPrincipalName,UserState,UserStateChangedOn,UserType
        $result | Export-Csv  $userFilePath -Delimiter `t
        
        Write-Host "UserDetails Import Successful"
        }
    }
    else
    {
		if($Cert)
		{
			write-host "Authentication with certificate to Exchange Online and Azure AD"
			Connect-ExchangeOnline -CertificateThumbprint $cert -AppId $AppID -ShowBanner:$false -Organization $tenantname
			
			if($NoAAD -eq $null -or $NoAAD -eq $false)
			{
				Connect-AzureAD -CertificateThumbprint $cert -ApplicationId $AppID -TenantId wdgcxp.onmicrosoft.com
				$result = Get-AzureADUser -All $true | Select-Object ObjectType,AccountEnabled,AgeGroup,City,CompanyName,Country,CreationType,Department,DirSyncEnabled,DisplayName,GivenName,IsCompromised,ImmutableId,JobTitle,LastDirSyncTime,LegalAgeGroupClassification,Mail,MailNickName,OnPremisesSecurityIdentifier,State,StreetAddress,Surname,UsageLocation,UserPrincipalName,UserState,UserStateChangedOn,UserType
				$result | Export-Csv $userFilePath -Delimiter `t
				Write-Host "UserDetails Import Successful"
			}
			else
			{
				Write-Host "Skipping user import based on user input NoAAD:"  $NoAAD 
			}
		
		}
		else
		{
			Write-Host "Initialzing PSSession"
			$ExchangeURI = "https://ps.protection.outlook.com/powershell-liveid/"
			$cloudCreds  = Get-StoredCredential -Target OATP -ErrorAction Stop
			$Session= New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $ExchangeURI -Credential $cloudCreds -Authentication Basic -AllowRedirection -ErrorAction Stop  
			Import-PSSession -Session $Session -ErrorAction Stop -AllowClobber -DisableNameChecking
			if($NoAAD -eq $null -or $NoAAD -eq $false)
			{
				Connect-AzureAD -Credential $cloudCreds
				$result = Get-AzureADUser -All $true | Select-Object ObjectType,AccountEnabled,AgeGroup,City,CompanyName,Country,CreationType,Department,DirSyncEnabled,DisplayName,GivenName,IsCompromised,ImmutableId,JobTitle,LastDirSyncTime,LegalAgeGroupClassification,Mail,MailNickName,OnPremisesSecurityIdentifier,State,StreetAddress,Surname,UsageLocation,UserPrincipalName,UserState,UserStateChangedOn,UserType
				$result | Export-Csv $userFilePath -Delimiter `t
				Write-Host "UserDetails Import Successful"
			}
			else
			{
				Write-Host "Skipping user import based on user input NoAAD:"  $NoAAD 
			}
		}
	}
if($InsertToSQL)
{
    if(($NoAAD -eq $null -or $NoAAD -eq $false))
    {
    Write-Host "SQL Database insert selected"

    if($isazuresqlserver)
    {
        Write-Host "Getting Azure SQL Details"
        $AzureUserCreds = Get-StoredCredential -Target AzureSQLCreds -ErrorAction Stop

        if ($AzureUserCreds -eq $null){
            Write-Host "Could retrieve credentials. Please make sure SQL creds are added to credential manager"
        }
        $credentials = New-Object System.Net.NetworkCredential($AzureUserCreds.UserName, $AzureUserCreds.Password, "AzureSQL")
      
        bcp stg.userdetails in $userFilePath -S $ServerName -d $Database -U $credentials.UserName -P $credentials.Password -F 3 -t '\t' -r '\n' -q -c  # move it windows credential
        sqlcmd -S $Servername  -U $credentials.UserName -P  $credentials.Password -d $Database -Q "exec [dbo].[cleanupuserdetails]" # test this again
    }
    else
    {
       Write-Host "Inserting data into "+ $Database
       bcp stg.userdetails in $userFilePath -S $ServerName -d $Database -F 3 -t '\t' -r '\n' -q -c -T
       Write-Host "Running Clean up"
       sqlcmd -S $servername -d $database -Q "exec [dbo].[cleanupuserdetails]"
       Write-Host "Clean up completed"
    }
    }
    else{
         Write-Host "Skipping user import based on input NoAAD:"  $NoAAD 
    }
}
else
{
     Write-Host "Skipping SQL import of user details based on input InsertToSQL:"  $InsertToSQL 
    
}

Write-Host "Fetching ATP Details"

try
  {
    if($InsertToSQL -eq $true)
    {

    Write-Host "Fetching Last pulled date"

    if($IsAzureSQLServer -eq $true)
            {
             
             $SQLMaxDate =  sqlcmd -S $ServerName -d $Database -U $credentials.UserName -P $credentials.Password -I -Q "SELECT MAX(date) AS Date from dbo.MailDetailATPReport WITH (NOLOCK)"
      
            }
            else
            {
             
              $SQLMaxDate = sqlcmd -S $ServerName -d $Database -I -Q "SELECT MAX(date) AS Date from dbo.MailDetailATPReport WITH (NOLOCK)"
            }
        if($SQLMaxDate[2].Contains("NULL")){
        
        	$days=read-host "How many days back would like to start the report for"
			[datetime] $reportStartDate=(get-date).adddays(-$days)
        
        }
        else 
        {
            [datetime] $reportStartDate = $SQLMaxDate[2];
        
        }
    }
    else{
 
     Write-Host "Skipping SQL import of ATP details based on input InsertToSQL:"  $InsertToSQL 
    
     if(Get-ChildItem $csvDirPath\*.csv)
		{
            $lastModifiedFileName = (Get-ChildItem $csvDirPath\*.csv -ErrorAction Stop | sort lastwritetime)[-1].Name
		    $reportStartDate = (Import-Csv $csvDirPath\$lastModifiedFileName -ErrorAction Stop -Delimiter "`t")[-1].Date
            [datetime]$reportStartDate = [DateTime]::Parse($reportStartDate,[Globalization.CultureInfo](Get-Culture).Name)	
      	}
		else
		{
			$days=read-host "How many days back would like to start the report for"
			[datetime] $reportStartDate=(get-date).adddays(-$days)
		}
      
    }
     Write-Host "Pulling data from " $reportStartDate;
 }
catch
   {
       
       Write-Host "Error while fetching files"+ $_
       Remove-PSSession $Session
       Exit-PSSession
       Exit
   }

        $reportEndDate = Get-Date
        $reportFileDate = Get-Date -Format FileDate
        Write-Host "last modified date:" +$lastModifiedFileName 
        Write-Host "report file date: " + $reportFileDate 
        #Scenario to handle same day run
        if($lastModifiedFileName -ne $null -and $lastModifiedFileName.Split('_')[1] -eq $reportFileDate )
        {
            [int]$fileIteratorConstant = ($lastModifiedFileName.Split('_')[2]).split('.')[0];
        }
       
        for ($i = 1; $i -lt 1000; $i++)
        { 
        
            if($fileIteratorConstant -ne $null)
            {
                $fileIterator = $fileIteratorConstant + $i;
            }
            else
            {
                $fileIterator = $i;
            }


        $filepath =  $csvDirPath + "PhishingReport_" + $reportFileDate + "_" + $fileIterator+".csv"
       
        $result = Get-MailDetailAtpReport -StartDate $reportStartDate -EndDate $reportEndDate -Direction Inbound -PAGE $i -pagesize 5000
        
        if ($null -eq $result)
        {
            Exit
        }

  
        Write-Host "Writing files into" $filepath
        $result | Export-Csv -LiteralPath $filepath -NoTypeInformation -ErrorAction Stop -Force -Delimiter `t

        #Insert to SQL
        if($InsertToSQL -eq $true)
        { 
            Write-Host "Writing ATP  data into SQL"
            Write-Host "Server" : $ServerName
            Write-Host "Database" : $Database
            
      
            if($IsAzureSQLServer -eq $true)
            {
                bcp stg.MailDetailATPReport in $filepath -S $ServerName -d $Database -U $credentials.UserName -P $credentials.Password -F 2 -t '\t' -r '\n' -q -c
                sqlcmd -S $ServerName -d $Database -U $credentials.UserName -P $credentials.Password -I -Q "EXEC dbo.ATPCleanUp"
      
            }
            else
            {
                bcp stg.MailDetailATPReport in $filepath -S $ServerName -d $Database -F 2 -t '\t' -r '\n' -T -q -c
                sqlcmd -S $ServerName -d $Database -I -Q "EXEC dbo.ATPCleanUp"
            }
       
        }
        $LastRecordDate = (Import-Csv $filepath -ErrorAction SilentlyContinue -Delimiter "`t")[-1].date
        $FirstRecordDate = (Import-Csv $filepath -ErrorAction SilentlyContinue -Delimiter "`t")[0].date
    }
}

catch
{
    Write-Host "Error while executing" + $_

    [string] $errorFile = $logDirectory + "\LogFile_" + (Get-Date -Format FileDate) + ".txt"
      
    $_ | Out-File $errorFile
    Remove-PSSession $Session
    Exit-PSSession
    Exit
}

#Exit the session.
if($MFA) {
    # no action required
}
else
{
    Remove-PSSession $Session
    Exit-PSSession
}
