IF NOT EXISTS(SELECT
TOP 1 name from sys.schemas where name ='stg')
BEGIN
EXEC('CREATE SCHEMA stg')
END


--drop table stg.MailDetailATPReport
CREATE TABLE [stg].[MailDetailATPReport] 
  ( 
 [PSComputerName]			NVARCHAR(255)
,[RunspaceId]				NVARCHAR(255)
,[PSShowComputerName]		NVARCHAR(255)
,[Organization]				NVARCHAR(255)
,[Date]						NVARCHAR(255)
,[MessageId]				NVARCHAR(255)
,[Domain]					NVARCHAR(255)
,[Subject]					NVARCHAR(255)
,[MessageSize]				NVARCHAR(255)
,[Direction]				NVARCHAR(255)
,[SenderAddress]			NVARCHAR(255)
,[RecipientAddress]			NVARCHAR(255)
,[FileName]					NVARCHAR(255)
,[MalwareName]				NVARCHAR(255)
,[EventType]				NVARCHAR(255)
,[Action]					NVARCHAR(255)
,[MessageTraceId]			NVARCHAR(255)
,[FileHash]					NVARCHAR(255)
,[StartDate]				NVARCHAR(255)
,[EndDate]					NVARCHAR(255)
,[Index]					nvarchar(255)
) ON [PRIMARY]


CREATE TABLE [dbo].[MailDetailATPReport] 
  ( 
 [PSComputerName]			NVARCHAR(255)
,[RunspaceId]				NVARCHAR(255)
,[PSShowComputerName]		NVARCHAR(255)
,[Organization]				NVARCHAR(255)
,[Date]						DATETIME
,[MessageId]				NVARCHAR(255)
,[Domain]					NVARCHAR(255)
,[Subject]					NVARCHAR(255)
,[MessageSize]				NVARCHAR(255)
,[Direction]				NVARCHAR(255)
,[SenderAddress]			NVARCHAR(255)
,[RecipientAddress]			NVARCHAR(255)
,[FileName]					NVARCHAR(255)
,[MalwareName]				NVARCHAR(255)
,[EventType]				NVARCHAR(255)
,[Action]					NVARCHAR(255)
,[MessageTraceId]			NVARCHAR(255)
,[FileHash]					NVARCHAR(255)
,[StartDate]				NVARCHAR(255)
,[EndDate]					NVARCHAR(255)
,[Index]					nvarchar(255)
) ON [PRIMARY]


CREATE TABLE [stg].[UserDetails]
(
 [ObjectType]						NVARCHAR(255)
,[AccountEnabled]					NVARCHAR(255)
,[AgeGroup]							NVARCHAR(255)
,[City]								NVARCHAR(255)
,[CompanyName]						NVARCHAR(255)
,[Country]							NVARCHAR(255)
,[CreationType]						NVARCHAR(255)
,[Department]						NVARCHAR(255)
,[DirSyncEnabled]					NVARCHAR(255)
,[DisplayName]						NVARCHAR(255)
,[GivenName]						NVARCHAR(255)
,[IsCompromised]					NVARCHAR(255)
,[ImmutableId]						NVARCHAR(255)
,[JobTitle]							NVARCHAR(255)
,[LastDirSyncTime]					NVARCHAR(255)
,[LegalAgeGroupClassification]		NVARCHAR(255)
,[Mail]								NVARCHAR(255)
,[MailNickName]						NVARCHAR(255)
,[OnPremisesSecurityIdentifier]		NVARCHAR(255)
,[State]							NVARCHAR(255)
,[StreetAddress]					NVARCHAR(255)
,[Surname]							NVARCHAR(255)
,[UsageLocation]					NVARCHAR(255)
,[UserPrincipalName]				NVARCHAR(255)
,[UserState]						NVARCHAR(255)
,[UserStateChangedOn]				NVARCHAR(255)
,[UserType]							NVARCHAR(255)
)



CREATE TABLE [dbo].[UserDetails]
(
 ObjectType						NVARCHAR(255)
,AccountEnabled					NVARCHAR(255)
,AgeGroup						NVARCHAR(255)
,City							NVARCHAR(255)
,CompanyName					NVARCHAR(255)
,Country						NVARCHAR(255)
,CreationType					NVARCHAR(255)
,Department						NVARCHAR(255)
,DirSyncEnabled					NVARCHAR(255)
,DisplayName					NVARCHAR(255)
,GivenName						NVARCHAR(255)
,IsCompromised					NVARCHAR(255)
,ImmutableId					NVARCHAR(255)
,JobTitle						NVARCHAR(255)
,LastDirSyncTime				NVARCHAR(255)
,LegalAgeGroupClassification	NVARCHAR(255)
,Mail							NVARCHAR(255)
,MailNickName					NVARCHAR(255)
,OnPremisesSecurityIdentifier	NVARCHAR(255)
,State							NVARCHAR(255)
,StreetAddress					NVARCHAR(255)
,Surname						NVARCHAR(255)
,UsageLocation					NVARCHAR(255)
,UserPrincipalName				NVARCHAR(255)
,UserState						NVARCHAR(255)
,UserStateChangedOn				NVARCHAR(255)
,UserType						NVARCHAR(255)

)