
CREATE PROCEDURE [dbo].[ATPCleanUp]
AS 
SELECT REPLACE([PSComputerName],'"','') AS [PSComputerName]
      ,REPLACE([RunspaceId],'"','')				   AS [RunspaceId]
      ,REPLACE([PSShowComputerName],'"','')		   AS [PSShowComputerName]
      ,REPLACE([Organization],'"','')			   AS [Organization]
      ,REPLACE([Date],'"','')					   AS [Date]
      ,REPLACE([MessageId],'"','')				   AS [MessageId]
      ,REPLACE([Domain],'"','')					   AS [Domain]
      ,REPLACE([Subject],'"','')				   AS [Subject]
      ,REPLACE([MessageSize],'"','')			   AS [MessageSize]
      ,REPLACE([Direction],'"','')				   AS [Direction]
      ,REPLACE([SenderAddress],'"','')			   AS [SenderAddress]
      ,REPLACE([RecipientAddress],'"','')		   AS [RecipientAddress]
      ,REPLACE([FileName],'"','')				   AS [FileName]
      ,REPLACE([MalwareName],'"','')			   AS [MalwareName]
      ,REPLACE([EventType],'"','')				   AS [EventType]
      ,REPLACE([Action],'"','')					   AS [Action]
      ,REPLACE([MessageTraceId],'"','')			   AS [MessageTraceId]
      ,REPLACE([FileHash],'"','')				   AS [FileHash]
      ,REPLACE([StartDate],'"','')				   AS [StartDate]
      ,REPLACE([EndDate],'"','')				   AS [EndDate]
      ,REPLACE([Index],'"','')					   AS [Index]
	  INTO #ProcessedATPTable
  FROM [stg].[MailDetailATPReport]
 
 INSERT INTO dbo.[MailDetailATPReport] WITH (TABLOCK)

 (
  [PSComputerName]
 ,[RunspaceId]
 ,[PSShowComputerName]
 ,[Organization]
 ,[Date]
 ,[MessageId]
 ,[Domain]
 ,[Subject]
 ,[MessageSize]
 ,[Direction]
 ,[SenderAddress]
 ,[RecipientAddress]
 ,[FileName]
 ,[MalwareName]
 ,[EventType]
 ,[Action]
 ,[MessageTraceId]
 ,[FileHash]
 ,[StartDate]
 ,[EndDate]
 ,[Index]
 
 
 )

 SELECT
	 [PSComputerName]
	,[RunspaceId]
	,[PSShowComputerName]
	,[Organization]
	,TRY_CAST([Date] AS datetime) AS [Date]
	,[MessageId]
	,[Domain]
	,[Subject]
	,[MessageSize]
	,[Direction]
	,[SenderAddress]
	,[RecipientAddress]
	,[FileName]
	,[MalwareName]
	,[EventType]
	,[Action]
	,[MessageTraceId]
	,[FileHash]
	,[StartDate]
	,[EndDate]
	,[Index]
	FROM #ProcessedATPTable WITH (NOLOCK)


--Truncate table 	
	TRUNCATE TABLE [stg].[MailDetailATPReport]
GO


