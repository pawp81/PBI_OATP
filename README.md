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
    - c. For testing the connectivity, you can run the following command in “Microsoft Exchange Online PowerShell Module”
*Connect-EXOPSSession*

Note: this will give a popup for authenticating to Exchange Online PowerShell.

### Installing PowerShell Packages
4.	Install Azure AD PowerShell module. PowerShell module is needed to pull out Department information about the recipients from Azure AD.
*Install-Module -Name AzureAD* 
5.	If you are using Windows authentication, please follow below steps
*Install-Module -Name CredentialManager*
Add Credentials
6.	Create a generic credential (if not already done)
    - a.	Open Credential Manager
    - b.	Under Windows Credential click on add a generic credential and fill following
      - Internet or network address: OATP
      - UserName: Exchange Online admin account
      - Password: password of Exchange Online admin account.
Note: In the PowerShell script, it is currently hardcoded as “OATP”. If you want to change the name. Please update the PowerShell script accordingly 
