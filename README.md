# Power BI EOP/Office 365 ATP reporting
Use Power BI to generate reports on Exchange Online Protection and Office 365 Advanced Threat Protection threats detection. This repository provides Power BI templates, PowerShell scripts and SQL scripts for EOP and Office 365 ATP threats reporting.

## Architecture
The solution consists of PowerShell script that is run periodically to collect phish and malware detection information and user details information. The script can save this data either to .csv files or to SQL database (Azure SQL or local SQL server).
Solution includes also Power BI templates. Power BI template can pull out the data from data source into the Power BI model and populate pre-defined visuals with the data. Model then can be saved and published to the web to share it with broader audience.
The data presented in the dashboards will include threats detected during inbound, outbound and intra-org mail flow. Threats detections included in the dashboard are:
•	phish messages 
•	malware in attachments
•	blocked clicks by ATP Safe Links
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
*Connect-EXOPSSession*

Note: this will give a popup for authenticating to Exchange Online PowerShell.

### Installing PowerShell Packages
3.	Install Azure AD PowerShell module. PowerShell module is needed to pull out Department information about the recipients from Azure AD.
*Install-Module -Name AzureAD* 
4.	If you are using Windows authentication, please follow below steps
*Install-Module -Name CredentialManager*
### Add Credentials
5.	Create a generic credential (if not already done)
    - a.	Open Credential Manager
    ![CredMan](/images/CredMan.png)
    - b.	Under Windows Credential click on add a generic credential and fill following
    ![CredMan_OATP](/images/CredMan_OATP.png)
      - Internet or network address: OATP
      - UserName: Exchange Online admin account
      - Password: password of Exchange Online admin account.

Note: In the PowerShell script, it is currently hardcoded as “OATP”. If you want to change the name. Please update the PowerShell script accordingly 
7.	If you are using Azure SQL server to store the data, create a generic credential for username and password as follows
    ![CredMan_AzureSQLCreds](/images/CredMan_AzureSQLCreds.png)
    -   Internet or network address: AzureSQLCreds
    -	UserName: SQL admin account
    -	Password: password of SQL admin account.

Note: In the PowerShell, it is currently hardcoded as “AzureSQLCreds”. If you want to change the name. Please update the PowerShell script accordingly.

## Power BI Pre-requisites
1.	Download and install Power BI Desktop from https://powerbi.microsoft.com/en-us/desktop/
## Create SQL Tables and Stored Procedures (if you are using SQL Storage)
1.	Create required tables and stored procedures
    - a.	Connect to the SQL Server. This can be done via SQL Server Management Studio 18
    ![MSSMS18](/images/MSSMS18.png)
    - b.	Connect to the server
    ![SQLServer](/images/SQLServer.png)
    - c.	Provide SQL server name in “Server name” field to connect.
    - d.	From SQL Admin get credential to connect to the server. If it is Azure SQL Server, authentication needs to be changed to 
SQL Server authentication or active directory authentication. More information is available here: https://docs.microsoft.com/en-us/azure/sql-database/sql-database-connect-query-ssms
    - e.	Once the connection is established, right click on the database in the object explorer and click on New Query
    ![NewQuery](/images/NewQuery.png)
    - f.	Create tables
            - i.	Switch the connection to the database that will store reporting data.
    ![EOPATPReporting](/images/EOPATPReporting.png)
            - ii.	Copy the content from CreateTable_script.sql and paste it in the SQL Query window
            - iii.	Click on Execute or press F5
            - iv.	This will create the required tables
