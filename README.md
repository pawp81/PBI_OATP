# Power BI EOP/Office 365 ATP reporting
Use Power BI to generate reports on Exchange Online Protection and Office 365 Advanced Threat Protection threats detection. This repository provides Power BI templates, PowerShell scripts and SQL scripts for EOP and Office 365 ATP threats reporting.

The solution has benefits over native, in-product reports. For example, it provides more flexibility in customization of the dashboards. Customers can modify the Power BI template according to their desires. Moreover, additional filters based on users’ characteristics are available such department, city and country.

## Architecture
The solution consists of PowerShell script that can be run periodically to collect phish and malware detection information and user details information. The script can save this data either to .csv files or to SQL database (Azure SQL or local SQL server). The script leverages Exchange Online PowerShell cmdlet [Get-MailDetailTrafficReport](https://docs.microsoft.com/en-us/powershell/module/exchange/advanced-threat-protection/get-maildetailatpreport?view=exchange-ps).

Solution includes also Power BI templates. Power BI template can pull out the data from data source into the Power BI model and populate pre-defined visuals with the data. Model then can be saved and published to the web to share it with broader audience.
The data presented in the dashboards will include threats detected during inbound, outbound and intra-org mail flow. Threats detections included in the dashboard are:
-	phish messages 
-	malware in attachments
-	blocked clicks by ATP Safe Links

The report doesn’t include spam and bulk email detections.

## Pre-requisites:
### General
1.	Minimum permissions required in Exchange Online: Security Reader or View-Only Recipients or any custom role that has rights to execute Exchange Online PowerShell cmdlet Get-MailDetailATPReport. 
For the installation of PowerShell modules: Exchange Online, Azure AD and Credential Manager local administrator rights are requiring. Local administrator rights are not required to run the script.
2.	(Optional) If you are planning to use multi-factor authentication to Exchange Online download and install “Exchange Online PowerShell using multi-factor authentication module”
    - a.	Minimum requirements for Exchange Online PowerShell module are described [here](https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/connect-to-exchange-online-powershell/mfa-connect-to-exchange-online-powershell?view=exchange-ps).
    - b.	Please follow the steps from [this article](https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/connect-to-exchange-online-powershell/mfa-connect-to-exchange-online-powershell?view=exchange-ps) to, download install the PowerShell module. 
    ![EXO PS](/images/EXO_PS.png)
    - c. For testing the connectivity, you can run the following command in “Microsoft Exchange Online PowerShell Module”
```Connect-EXOPSSession```

Note: this will give a popup for authenticating to Exchange Online PowerShell.

### Installing PowerShell Packages
3.	Install Azure AD PowerShell module. PowerShell module is needed to pull out Department information about the recipients from Azure AD.
```Install-Module -Name AzureAD```
4.	If you are using Windows authentication, please follow below steps
```Install-Module -Name CredentialManager```
### Add Credentials
5.	Create a generic credential (if not already done)
    - a.	Open Credential Manager
      
      ![CredMan](/images/CredMan.png)
      
    - b.	Under Windows Credential click on add a generic credential and fill following
    ![CredMan_OATP](/images/CredMan_OATP2.png)
      - Internet or network address: OATP
      - UserName: Exchange Online admin account
      - Password: password of Exchange Online admin account.

Note: In the PowerShell script, it is currently hardcoded as “OATP”. If you want to change the name. Please update the PowerShell script accordingly.

7.	If you are using Azure SQL server to store the data, create a generic credential for username and password as follows:
    ![CredMan_AzureSQLCreds](/images/CredMan_AzureSQLCreds.png)
    
- Internet or network address: AzureSQLCreds
- UserName: SQL admin account
- Password: password of SQL admin account.

Note: In the PowerShell, it is currently hardcoded as “AzureSQLCreds”. If you want to change the name. Please update the PowerShell script accordingly.

## Power BI Pre-requisites
1.	Download and install Power BI Desktop from https://powerbi.microsoft.com/en-us/desktop/
## Create SQL Tables and Stored Procedures (ONLY APPLICABLE if you are using SQL Storage)
1.	Create required tables and stored procedures
    - a.	Connect to the SQL Server. This can be done via SQL Server Management Studio 18
    ![MSSMS18](/images/MSSMS18.png)
    - b.	Connect to the server
    ![SQLServer](/images/SQLServer.png)
    - c.	Provide SQL server name in "Server name" field to connect.
    - d.	From SQL Admin get credential to connect to the server. If it is Azure SQL Server, authentication needs to be changed to 
SQL Server authentication or active directory authentication. More information is available here: https://docs.microsoft.com/en-us/azure/sql-database/sql-database-connect-query-ssms
    - e.	Once the connection is established, right click on the database in the object explorer and click on New Query
    ![NewQuery](/images/NewQuery.png)
    - f.	Create tables
      - Switch the connection to the database that will store reporting data.
      
      ![EOPATPReporting](/images/EOPATPReporting.png)
      
      - Copy the content from CreateTable_script.sql and paste it in the SQL Query window
      - Click on Execute or press F5
      - This will create the required tables
      
      ![Tables](/images/tables.png)
  
      ![Tables2](/images/tables2.png)

    - g.	Creating Stored Procedures
      - Copy the script from StoredProcedure_ATPCleanUp.sql and execute it. This will create stored procedure dbo.ATPCleanUp
      - Copy the script from StoredProcedure_CleanUpUserDetails.sql and execute it. This will create stored procedure dbo.CleanUpUserDetails
      
      ![](/images/storedprocedures.png)
## Other SQL pre-requisites (ONLY APPLICABLE if you are using SQL Storage)
1. Download and install bcp command on the machine where the script will be executed. Reference: https://docs.microsoft.com/en-us/sql/tools/bcp-utility?view=sql-server-ver15
   
2. Install ODBC 17 https://www.microsoft.com/en-us/download/details.aspx?id=56567
   
3. Install Command Line Utilities 15 https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility?view=sql-server-ver15
   
   - *if you observe error message during Command Line Utilities installation: Setup is missing an installation prerequisite: -Microsoft ODBC Driver 17 for SQL Server. To continue, install Microsoft ODBC Driver 17 for SQL Server and then run the setup operation again
Exit the utils installation.* 
   - Install ODBC 13.1. Run the Command Line Utilities 15 installer again.
    

## Running the script:
1.	Before running the script for the first time right click on ps1 file. Open properties and unblock the file.
2.	Open PowerShell window and run the ATPReportingPS.ps1 PowerShell script with required parameters. Below is description of available parameters:
    - csvDirPath (mandatory): folder path where .csv files with threat detection information should be saved to by the script: Example: "c:\EOPATPReporting\csv\"
    - userFilePath (mandatory): path to the file where user details from Azure AD should be saved to Example: “c:\EOPATPReporting\userdetails.csv”
    - MFA: set this parameter to "true" if you are authenticating using multi factor authentication. Example: -MFA $true
    - ServerName: SQL server name 
    - Database: SQL Database name
    - IsAzureSQLServer: set to true if storage location is Azure SQL Server.
    - NoAAD (optional, not recommended for the 1st run) skip Azure AD part of the script that collects information about the users from Azure AD.

### example for CSV storage and no MFA

```.\ATPReportingPS.ps1 -csvDirPath "c:\EOPATPReporting\csv\" -userFilePath "c:\EOPATPReporting\userAzureADdetails.csv"```

### example for CSV storage and with MFA

```.\ATPReportingPS.ps1 -csvDirPath "c:\EOPATPReporting\csv\" -userFilePath "c:\EOPATPReporting\userAzureADdetails.csv" -MFA $true```

### example for Azure SQL storage and no MFA

```.\ATPReportingPS.ps1 -csvDirPath "c:\EOPATPReporting\csv\" -userFilePath "c:\EOPATPReporting\userAzureADdetails.csv" -ServerName "xxxxx.database.windows.net" -Database "EOPATPReporting" -InsertToSQL $true -IsAzureSQLServer $true```

*We are using SQL based authentication for Azure SQL login. Update the parameters accordingly if you want to update it to other logins*

### example for SQL storage and no MFA

```.\ATPReportingPS.ps1 -csvDirPath "c:\EOPATPReporting\csv\" -userFilePath "c:\EOPATPReporting\userAzureADdetails.csv" -ServerName "SQLSrv01.ad.local" -Database "EOPATPReporting" -InsertToSQL $true```

## Reporting
1.	For data storage in csv files, use **PBI - EOP ATP Reporting.pbit** Power BI template file.
a.	Once you double-click the file, you will have to provide following parameter values
    - Parameter1: Set it to "Sample File"
    - PhishingFileFolder: Folder name for ATP files (the same value as -csvDirPath)
    - UserDetailsFilePath: path to the file with user details (the same value as -userFilePath)
    
    ![](/images/PBI_CSV.png)
    
b.	Click Load

c.	Once the data is loaded, save the file as pbix file.

2. For SQL file, use **PBI - EOP ATP Reporting SQL.pbit** file
a.	Open the file and provide following details
    - ServerName: SQL server name
    - Database: name of the database on SQL server for EOP/ATP reporting
    ![](/images/PBI_SQL.png)
b.	Click Load.
c.	Connect to the database accordingly:
    - For on-premises – use Windows Authentication
    - For Azure SQL – use SQL Authentication

## Recommendations
For automated running of the script using Task Scheduler:
1.	Don’t use MFA mode because it will not allow the script to run without admin interaction.
2.	If you are using Azure SQL Server, use SQL based authentication.
3.  For all Power BI templates makes sure that regional settings configured in the Power BI desktop app are matching those configured on the machine where PowerShell script is executed. Otherwise following error might occur when importing data to the model.

![](/images/PBI_DataFormat.png)

Follow instructions from this article to change locale settings in Power BI desktop: 
https://docs.microsoft.com/en-us/power-bi/supported-languages-countries-regions#choose-the-locale-for-importing-data-into-power-bi-desktop


## Open Bugs:
1.	If you rerun the scripts on the same day, the csv files will be overwritten with latest data
We are working on the fix.

