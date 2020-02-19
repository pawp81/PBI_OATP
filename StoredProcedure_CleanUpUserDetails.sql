

CREATE PROCEDURE [dbo].[CleanUpUserDetails]
AS 

TRUNCATE TABLE dbo.[UserDetails]

SELECT REPLACE([ObjectType],'"','')							AS [ObjectType]
      ,REPLACE([AccountEnabled],'"','')						AS [AccountEnabled]
      ,REPLACE([AgeGroup],'"','')							AS [AgeGroup]
      ,REPLACE([City],'"','')								AS [City]
      ,REPLACE([CompanyName],'"','')						AS [CompanyName]
      ,REPLACE([Country],'"','')							AS [Country]
      ,REPLACE([CreationType],'"','')						AS [CreationType]
      ,REPLACE([Department],'"','')							AS [Department]
      ,REPLACE([DirSyncEnabled],'"','')						AS [DirSyncEnabled]
      ,REPLACE([DisplayName],'"','')						AS [DisplayName]
      ,REPLACE([GivenName],'"','')							AS [GivenName]
      ,REPLACE([IsCompromised],'"','')						AS [IsCompromised]
      ,REPLACE([ImmutableId],'"','')						AS [ImmutableId]
      ,REPLACE([JobTitle],'"','')							AS [JobTitle]
      ,REPLACE([LastDirSyncTime],'"','')					AS [LastDirSyncTime]
      ,REPLACE([LegalAgeGroupClassification],'"','')		AS [LegalAgeGroupClassification]
      ,REPLACE([Mail],'"','')								AS [Mail]
      ,REPLACE([MailNickName],'"','')						AS [MailNickName]
      ,REPLACE([OnPremisesSecurityIdentifier],'"','')		AS [OnPremisesSecurityIdentifier]
      ,REPLACE([State],'"','')								AS [State]
      ,REPLACE([StreetAddress],'"','')						AS [StreetAddress]
      ,REPLACE([Surname],'"','')							AS [Surname]
      ,REPLACE([UsageLocation],'"','')						AS [UsageLocation]
      ,REPLACE([UserPrincipalName],'"','')					AS [UserPrincipalName]
      ,REPLACE([UserState],'"','')							AS [UserState]
      ,REPLACE([UserStateChangedOn],'"','')					AS [UserStateChangedOn]
      ,REPLACE([UserType],'"','')							AS [UserType]
	  INTO #ProcessedUsers
  FROM [stg].[UserDetails] WITH (NOLOCK)
 

 INSERT INTO [dbo].[UserDetails] WITH (TABLOCK)
 (
       [ObjectType]
      ,[AccountEnabled]
      ,[AgeGroup]
      ,[City]
      ,[CompanyName]
      ,[Country]
      ,[CreationType]
      ,[Department]
      ,[DirSyncEnabled]
      ,[DisplayName]
      ,[GivenName]
      ,[IsCompromised]
      ,[ImmutableId]
      ,[JobTitle]
      ,[LastDirSyncTime]
      ,[LegalAgeGroupClassification]
      ,[Mail]
      ,[MailNickName]
      ,[OnPremisesSecurityIdentifier]
      ,[State]
      ,[StreetAddress]
      ,[Surname]
      ,[UsageLocation]
      ,[UserPrincipalName]
      ,[UserState]
      ,[UserStateChangedOn]
      ,[UserType]
 
 )
 SELECT
	 [ObjectType]
      ,[AccountEnabled]
      ,[AgeGroup]
      ,[City]
      ,[CompanyName]
      ,[Country]
      ,[CreationType]
      ,[Department]
      ,[DirSyncEnabled]
      ,[DisplayName]
      ,[GivenName]
      ,[IsCompromised]
      ,[ImmutableId]
      ,[JobTitle]
      ,[LastDirSyncTime]
      ,[LegalAgeGroupClassification]
      ,[Mail]
      ,[MailNickName]
      ,[OnPremisesSecurityIdentifier]
      ,[State]
      ,[StreetAddress]
      ,[Surname]
      ,[UsageLocation]
      ,[UserPrincipalName]
      ,[UserState]
      ,[UserStateChangedOn]
      ,[UserType]
	FROM #ProcessedUsers

	--Truncate STG table 	
	TRUNCATE TABLE [stg].[UserDetails]

GO


