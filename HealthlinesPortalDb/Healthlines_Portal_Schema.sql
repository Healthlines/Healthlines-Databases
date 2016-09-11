USE [master]
GO
/****** Object:  Database [Healthlines_Portal]    Script Date: 11/09/2016 21:31:07 ******/
CREATE DATABASE [Healthlines_Portal]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HealthLines_Portal', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Healthlines_Portal.mdf' , SIZE = 4480KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'HealthLines_Portal_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Healthlines_Portal.ldf' , SIZE = 10424KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Healthlines_Portal] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Healthlines_Portal].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [Healthlines_Portal] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET ARITHABORT OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Healthlines_Portal] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Healthlines_Portal] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Healthlines_Portal] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Healthlines_Portal] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Healthlines_Portal] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET RECOVERY FULL 
GO
ALTER DATABASE [Healthlines_Portal] SET  MULTI_USER 
GO
ALTER DATABASE [Healthlines_Portal] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Healthlines_Portal] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Healthlines_Portal] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Healthlines_Portal] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Healthlines_Portal] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Healthlines_Portal] SET QUERY_STORE = OFF
GO
USE [Healthlines_Portal]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [Healthlines_Portal]
GO
/****** Object:  User [WeatherWatch]    Script Date: 11/09/2016 21:31:07 ******/
CREATE USER [WeatherWatch] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [PatientSatisfactionSurvey]    Script Date: 11/09/2016 21:31:07 ******/
CREATE USER [PatientSatisfactionSurvey] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [Healthlines_Reporting_Read]    Script Date: 11/09/2016 21:31:07 ******/
CREATE USER [Healthlines_Reporting_Read] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [Healthlines_PRD_CADS]    Script Date: 11/09/2016 21:31:07 ******/
CREATE USER [Healthlines_PRD_CADS] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [healthlines]    Script Date: 11/09/2016 21:31:07 ******/
CREATE USER [healthlines] FOR LOGIN [healthlines] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [Healthlines_Reporting_Read]
GO
ALTER ROLE [db_owner] ADD MEMBER [Healthlines_PRD_CADS]
GO
ALTER ROLE [db_owner] ADD MEMBER [healthlines]
GO
ALTER ROLE [db_datareader] ADD MEMBER [healthlines]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [healthlines]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCallOutcome]    Script Date: 11/09/2016 21:31:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetCallOutcome](@pOutcomeId UNIQUEIDENTIFIER)
RETURNS VARCHAR(100)
AS
BEGIN
DECLARE @OutcomeReason VARCHAR(100)
SELECT 
		@OutcomeReason=Reason
FROM
		CallOutcomeReason
WHERE 
		OutcomeId=@pOutcomeId
RETURN @OutcomeReason		
END

GO
/****** Object:  UserDefinedFunction [dbo].[GetPatientName]    Script Date: 11/09/2016 21:31:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetPatientName](@pPatientId UNIQUEIDENTIFIER)
RETURNS VARCHAR(100)
AS
BEGIN
DECLARE @PatientName VARCHAR(100)
SELECT 
		@PatientName=Firstname + '  ' + Lastname 
FROM
		PATIENT
WHERE 
		PatientId=@pPatientId
RETURN @PatientName		
END

GO
/****** Object:  Table [dbo].[ReadingExpected]    Script Date: 11/09/2016 21:31:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReadingExpected](
	[ReadingExpectedId] [int] IDENTITY(1,1) NOT NULL,
	[ExpectedDate] [datetime] NOT NULL,
	[PatientId] [nvarchar](200) NOT NULL,
	[StudyId] [nvarchar](100) NOT NULL,
	[ReadingTypeId] [int] NOT NULL,
	[ReadingGiven] [bit] NOT NULL,
 CONSTRAINT [PK_ReadingExpected] PRIMARY KEY CLUSTERED 
(
	[ReadingExpectedId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[GetPatientsWithOverdueReadings]    Script Date: 11/09/2016 21:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[GetPatientsWithOverdueReadings]
AS
SELECT     pa.email AS PatientEmail
FROM         Healthlines_Duke_PRD.dbo.tblParticipants AS pa INNER JOIN
                      dbo.ReadingExpected AS re ON re.PatientId = CAST(pa.participantID AS nvarchar(200))
WHERE     (re.ReadingGiven = 0) AND (re.ReadingTypeId = 4)
GROUP BY pa.participantID, pa.email
HAVING      (MAX(re.ExpectedDate) < DATEADD(dd, - 2, GETDATE())) AND (DATEADD(dd, 10, MAX(re.ExpectedDate)) > GETDATE())

GO
/****** Object:  Table [dbo].[Patient]    Script Date: 11/09/2016 21:31:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patient](
	[PatientId] [uniqueidentifier] NOT NULL,
	[Firstname] [nvarchar](50) NOT NULL,
	[Lastname] [nvarchar](50) NOT NULL,
	[Telephone1] [nvarchar](50) NULL,
	[Telephone2] [nvarchar](50) NULL,
	[Telephone3] [nvarchar](50) NULL,
	[PreferredContactNumber] [nvarchar](200) NULL,
	[CallReferenceId] [nvarchar](50) NULL,
	[DateAdded] [datetime] NOT NULL,
	[NHSContactedDate] [datetime] NULL,
	[Title] [nvarchar](10) NOT NULL,
	[CallAttempt] [int] NOT NULL,
	[LockedTo] [nvarchar](100) NULL,
	[IsLocked] [bit] NOT NULL,
	[LanguageId] [uniqueidentifier] NULL,
	[DOB] [datetime] NULL,
	[GpPractice] [nvarchar](50) NULL,
	[GpPracticeName] [nvarchar](50) NULL,
	[GpPracticePCT] [nvarchar](50) NULL,
	[GpPracticeTelephone] [nvarchar](50) NULL,
	[GpPracticeEmail] [nvarchar](50) NULL,
	[ReasonFor] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Address2] [nvarchar](100) NULL,
	[Address3] [nvarchar](100) NULL,
	[County] [nvarchar](100) NULL,
	[PostCode] [nvarchar](50) NULL,
	[EmailAddress] [nvarchar](250) NULL,
	[ScheduleNotes] [nvarchar](2500) NULL,
	[BaselineGAD7] [decimal](5, 2) NULL,
	[BaselinePHQ9] [decimal](5, 2) NULL,
	[OnAntidepressants] [bit] NULL,
	[NHSNumber] [nvarchar](250) NULL,
	[Gender] [nvarchar](10) NULL,
	[Ethnicity] [nvarchar](100) NULL,
	[Status] [int] NOT NULL,
	[StudyTrialID] [varchar](50) NULL,
	[StudyArm] [varchar](50) NULL,
	[StudyReferralDate] [datetime] NULL,
	[StudyConsentedDate] [datetime] NULL,
	[Education] [varchar](500) NULL,
 CONSTRAINT [PK_Patient] PRIMARY KEY CLUSTERED 
(
	[PatientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Callback]    Script Date: 11/09/2016 21:32:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Callback](
	[CallbackId] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[PatientId] [nvarchar](200) NOT NULL,
	[StudyID] [nvarchar](100) NULL,
	[CallbackStartTime] [datetime] NOT NULL,
	[CallbackScheduledBy] [nvarchar](100) NOT NULL,
	[CallbackDate] [datetime] NOT NULL,
	[CallbackEndTime] [datetime] NULL,
	[CallbackScheduledDate] [datetime] NOT NULL,
	[LockedTo] [nvarchar](50) NULL,
	[LockedDate] [datetime] NULL,
	[Completed] [bit] NOT NULL,
	[CallOutcome] [nvarchar](100) NULL,
	[Type] [int] NOT NULL,
 CONSTRAINT [PK_Callback] PRIMARY KEY CLUSTERED 
(
	[CallbackId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[GetPatientsWithCallbacksInThreeDays]    Script Date: 11/09/2016 21:32:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[GetPatientsWithCallbacksInThreeDays]
AS
SELECT        dbo.Patient.EmailAddress AS EmailAddress, dbo.Patient.Firstname AS FirstName, dbo.Callback.CallbackDate, CONVERT(VARCHAR(25), 
                         dbo.Callback.CallbackStartTime, 100) AS CallbackStartTime, CONVERT(VARCHAR(25), dbo.Callback.CallbackEndTime, 100) AS CallbackEndTime
FROM            dbo.Callback INNER JOIN
                         dbo.Patient ON CONVERT(NVarchar(50), dbo.Callback.PatientId) = CONVERT(NVarchar(50), dbo.Patient.PatientId)
WHERE        (CONVERT(VARCHAR(10), dbo.Callback.CallbackDate, 101) = DATEADD(dd, 3, CONVERT(VARCHAR(10), GETDATE(), 101))) AND (CallOutcome IS NULL OR
                         LEN(CallOutcome) = 0) AND dbo.Patient.Status in (1, 5)
UNION
SELECT        Healthlines_Duke_PRD.dbo.tblParticipants.email COLLATE SQL_Latin1_General_CP1_CI_AS AS EmailAddress, 
                         Healthlines_Duke_PRD.dbo.tblParticipants.sName COLLATE SQL_Latin1_General_CP1_CI_AS AS FirstName, dbo.Callback.CallbackDate, CONVERT(VARCHAR(25), 
                         dbo.Callback.CallbackStartTime, 100) AS CallbackStartTime, CONVERT(VARCHAR(25), dbo.Callback.CallbackEndTime, 100) AS CallbackEndTime
FROM            dbo.Callback INNER JOIN
                         Healthlines_Duke_PRD.dbo.tblParticipants ON CONVERT(NVarchar(50), dbo.Callback.PatientId) = CONVERT(NVarchar(50), 
                         Healthlines_Duke_PRD.dbo.tblParticipants.participantID)
WHERE        (CONVERT(VARCHAR(10), dbo.Callback.CallbackDate, 101) = DATEADD(dd, 3, CONVERT(VARCHAR(10), GETDATE(), 101))) AND (CallOutcome IS NULL OR
                         LEN(CallOutcome) = 0) AND Healthlines_Duke_PRD.dbo.tblParticipants.status in (1, 2, 4)

GO
/****** Object:  Table [dbo].[CallEvents]    Script Date: 11/09/2016 21:32:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CallEvents](
	[EventID] [int] IDENTITY(1,1) NOT NULL,
	[CallbackID] [uniqueidentifier] NOT NULL,
	[PatientId] [nvarchar](200) NOT NULL,
	[StudyID] [nvarchar](100) NOT NULL,
	[UserID] [nvarchar](250) NOT NULL,
	[Date] [datetime] NOT NULL,
	[EventCode] [nvarchar](25) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_PatientHistory] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[vw_Depression]    Script Date: 11/09/2016 21:32:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_Depression] AS

SELECT     patients.PatientId AS patients_PatientId, patients.Firstname AS patients_Firstname, patients.Lastname AS patients_Lastname, 
                      patients.Telephone1 AS patients_Telephone1, patients.Telephone2 AS patients_Telephone2, patients.Telephone3 AS patients_Telephone3, 
                      patients.PreferredContactNumber AS patients_PreferredContactNumber, patients.CallReferenceId AS patients_CallReferenceId, 
                      patients.DateAdded AS patients_DateAdded, patients.NHSContactedDate AS patients_NHSContactedDate, patients.Title AS patients_Title, 
                      patients.CallAttempt AS patients_CallAttempt, patients.LockedTo AS patients_LockedTo, patients.IsLocked AS patients_IsLocked, 
                      patients.LanguageId AS patients_LanguageId, patients.DOB AS patients_DOB, patients.GpPractice AS patients_GpPractice, 
                      patients.GpPracticeName AS patients_GpPracticeName, patients.GpPracticePCT AS patients_GpPracticePCT, 
                      patients.GpPracticeTelephone AS patients_GpPracticeTelephone, patients.GpPracticeEmail AS patients_GpPracticeEmail, patients.ReasonFor AS patients_ReasonFor, 
                      patients.Address AS patients_Address, patients.Address2 AS patients_Address2, patients.Address3 AS patients_Address3, patients.County AS patients_County, 
                      patients.PostCode AS patients_PostCode, patients.EmailAddress AS patients_EmailAddress, patients.ScheduleNotes AS patients_ScheduleNotes, 
                      patients.BaselineGAD7 AS patients_BaselineGAD7, patients.BaselinePHQ9 AS patients_BaselinePHQ9, patients.OnAntidepressants AS patients_OnAntidepressants, 
                      patients.NHSNumber AS patients_NHSNumber, patients.Gender AS patients_Gender, patients.Ethnicity AS patients_Ethnicity, patients.Status AS patients_Status, 
                      patients.StudyTrialID AS patients_StudyTrialID, patients.StudyArm AS patients_StudyArm, patients.StudyReferralDate AS patients_StudyReferralDate, 
                      patients.StudyConsentedDate AS patients_StudyConsentedDate, patients.Education AS patients_Education, callback.CallbackId AS callback_CallbackId, 
                      callback.PatientId AS callback_PatientId, callback.StudyID AS callback_StudyID, callback.CallbackStartTime AS callback_CallbackStartTime, 
                      callback.CallbackScheduledBy AS callback_CallbackScheduledBy, callback.CallbackDate AS callback_CallbackDate, 
                      callback.CallbackEndTime AS callback_CallbackEndTime, callback.CallbackScheduledDate AS callback_CallbackScheduledDate, 
                      callback.LockedTo AS callback_LockedTo, callback.LockedDate AS callback_LockedDate, callback.Completed AS callback_Completed, 
                      callback.CallOutcome AS callback_CallOutcome, callback.Type AS callback_Type, callevents.EventID AS callevents_EventID, 
                      callevents.CallbackID AS callevents_CallbackID, callevents.PatientId AS callevents_PatientId, callevents.StudyID AS callevents_StudyID, 
                      callevents.UserID AS callevents_UserID, callevents.Date AS callevents_Date, callevents.EventCode AS callevents_EventCode, 
                      callevents.Message AS callevents_Message, answerSets.PatientId AS answerSets_PatientId, answerSets.StartDay AS answerSets_StartDay, 
                      answerSets.EndDay AS answerSets_EndDay, answerSets.StartDate AS answerSets_StartDate, answerSets.EndDate AS answerSets_EndDate, 
                      answerSets.AnswerSetID AS answerSets_AnswerSetId, answerSets.QuestionnaireID AS answerSets_QuestionnaireID, 
                      answerSets.Completed AS answerSets_Completed, answers.AnswerID AS answers_AnswerID, answers.AnswerSetID AS answers_AnswerSetID, 
                      answers.QuestionID AS answers_QuestionID, answers.Value AS answers_Value, answers.Date AS answers_Date, answers.OperatorID AS answers_OperatorID, 
                      answers.Type AS answers_Type, answers.Page AS answers_Page, answers.[Order] AS answers_Order, 
                      questionnaires.QuestionnaireID AS questionnaires_QuestionnaireID, questionnaires.Name AS questionnaires_Name, 
                      questionnaires.CreatedBy AS questionnaires_CreatedBy, questionnaires.CreationDate AS questionnaires_CreationDate
FROM         Healthlines_Portal.dbo.Patient AS patients INNER JOIN
                      Healthlines_Portal.dbo.Callback AS callback ON patients.PatientId = CONVERT(UNIQUEIDENTIFIER, callback.PatientId) AND 
                      callback.StudyID = 'Depression' INNER JOIN
                      Healthlines_Portal.dbo.CallEvents AS callevents ON callevents.CallbackID = callback.CallbackId AND callevents.Date =
                          (SELECT     TOP (1) Date
                            FROM          Healthlines_Portal.dbo.CallEvents
                            WHERE      (CallbackID = callback.CallbackId) AND (PatientId = patients.PatientId) AND (EventCode = 'RecordLocked')
                            ORDER BY Date DESC) LEFT OUTER JOIN
                          (SELECT     CONVERT(UNIQUEIDENTIFIER, RIGHT(ParticipantID, 36)) AS PatientId, DATEADD(dd, 0, DATEDIFF(dd, 0, StartDate)) AS StartDay, DATEADD(SECOND, 
                                                   86399, DATEDIFF(dd, 0, EndDate)) AS EndDay, StartDate, EndDate, AnswerSetID, QuestionnaireID, Completed
                            FROM          Healthlines_Questionnaire.dbo.AnswerSets AS AnswerSets_1) AS answerSets ON answerSets.PatientId = patients.PatientId AND 
                      answerSets.StartDate =
                          (SELECT     TOP (1) StartDate
                            FROM          Healthlines_Questionnaire.dbo.AnswerSets
                            WHERE      (CONVERT(UNIQUEIDENTIFIER, RIGHT(answerSets.ParticipantID, 36)) = patients.PatientId) AND (StartDate BETWEEN DATEADD(MINUTE, - 100, 
                                                   callevents.Date) AND DATEADD(MINUTE, 100, callevents.Date))
                            ORDER BY Completed DESC, callevents.Date DESC) LEFT OUTER JOIN
                      Healthlines_Questionnaire.dbo.Answers AS answers ON answers.AnswerSetID = answerSets.AnswerSetID LEFT OUTER JOIN
                      Healthlines_Questionnaire.dbo.Questionnaires AS questionnaires ON answerSets.QuestionnaireID = questionnaires.QuestionnaireID





GO
/****** Object:  Table [dbo].[CallbackPatientComments]    Script Date: 11/09/2016 21:32:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CallbackPatientComments](
	[CommentID] [int] IDENTITY(1,1) NOT NULL,
	[PatientId] [nvarchar](100) NOT NULL,
	[StudyID] [nvarchar](100) NULL,
	[Comments] [nvarchar](max) NULL,
	[CommentsDate] [datetime] NOT NULL,
	[CommentsEnteredBy] [nvarchar](100) NOT NULL,
	[CallbackID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_CallBackComments] PRIMARY KEY CLUSTERED 
(
	[CommentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CallOutcomeReason]    Script Date: 11/09/2016 21:32:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CallOutcomeReason](
	[OutcomeId] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[Reason] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_CallOutcomeReason] PRIMARY KEY CLUSTERED 
(
	[OutcomeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContentSectionStatus]    Script Date: 11/09/2016 21:32:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContentSectionStatus](
	[ContentSectionStatusId] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[StudyId] [nvarchar](100) NULL,
	[SectionName] [nvarchar](100) NOT NULL,
	[LastUpdated] [datetime] NULL,
	[DateAffected] [datetime] NULL,
	[Status] [bit] NULL,
 CONSTRAINT [PK_ContentSectionStatus] PRIMARY KEY CLUSTERED 
(
	[ContentSectionStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ELMAH_Error]    Script Date: 11/09/2016 21:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ELMAH_Error](
	[ErrorId] [uniqueidentifier] NOT NULL,
	[Application] [nvarchar](60) NOT NULL,
	[Host] [nvarchar](50) NOT NULL,
	[Type] [nvarchar](100) NOT NULL,
	[Source] [nvarchar](60) NOT NULL,
	[Message] [nvarchar](500) NOT NULL,
	[User] [nvarchar](50) NOT NULL,
	[StatusCode] [int] NOT NULL,
	[TimeUtc] [datetime] NOT NULL,
	[Sequence] [int] IDENTITY(1,1) NOT NULL,
	[AllXml] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ELMAH_Error] PRIMARY KEY NONCLUSTERED 
(
	[ErrorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FileData]    Script Date: 11/09/2016 21:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileData](
	[FileID] [int] NOT NULL,
	[Data] [varbinary](max) NOT NULL,
 CONSTRAINT [PK_FileData] PRIMARY KEY CLUSTERED 
(
	[FileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Files]    Script Date: 11/09/2016 21:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Files](
	[FileID] [int] IDENTITY(1,1) NOT NULL,
	[StudyID] [varchar](100) NOT NULL,
	[PatientID] [varchar](200) NOT NULL,
	[Filename] [varchar](50) NOT NULL,
	[Extension] [varchar](10) NOT NULL,
	[FileLength] [bigint] NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Files] PRIMARY KEY CLUSTERED 
(
	[FileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GpPracticeAddress]    Script Date: 11/09/2016 21:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GpPracticeAddress](
	[GpPracticeAddressId] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[PatientID] [nvarchar](200) NOT NULL,
	[StudyID] [nvarchar](50) NOT NULL,
	[GpPracticeAddress1] [nvarchar](100) NULL,
	[GpPracticeAddress2] [nvarchar](100) NULL,
	[GpPracticeAddress3] [nvarchar](100) NULL,
	[GpPostCode] [nvarchar](100) NULL,
	[GpPractice] [nvarchar](100) NULL,
 CONSTRAINT [PK_GpPracticeAddress_1] PRIMARY KEY CLUSTERED 
(
	[GpPracticeAddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Language]    Script Date: 11/09/2016 21:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Language](
	[LanguageId] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[LanguageName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
(
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PageVisitedLog]    Script Date: 11/09/2016 21:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PageVisitedLog](
	[PageVisitedLogId] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](256) NULL,
	[PageURL] [varchar](max) NULL,
	[IPAddress] [varchar](50) NULL,
	[DateVisited] [datetime] NULL,
 CONSTRAINT [PK_PageVisitedLog] PRIMARY KEY CLUSTERED 
(
	[PageVisitedLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PasswordResetRequest]    Script Date: 11/09/2016 21:32:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PasswordResetRequest](
	[PasswordResetRequestId] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[DateOfRequest] [datetime] NOT NULL,
 CONSTRAINT [PK_PasswordResetRequest] PRIMARY KEY CLUSTERED 
(
	[PasswordResetRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PatientEvents]    Script Date: 11/09/2016 21:32:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientEvents](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StudyID] [nvarchar](100) NOT NULL,
	[PatientID] [nvarchar](200) NOT NULL,
	[EventCode] [int] NOT NULL,
	[EventDate] [datetime] NOT NULL,
	[EventUser] [varchar](255) NOT NULL,
	[Value] [varchar](max) NULL,
	[Value2] [varchar](max) NULL,
	[Details] [varchar](max) NULL,
 CONSTRAINT [PK_PatientEvents] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PatientMedications]    Script Date: 11/09/2016 21:32:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientMedications](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[StudyID] [nvarchar](100) NOT NULL,
	[PatientID] [nvarchar](100) NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[Dose] [nvarchar](50) NOT NULL,
	[Frequency] [varchar](50) NOT NULL,
 CONSTRAINT [PK_PatientMedications] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QuestionnaireActionLetters]    Script Date: 11/09/2016 21:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionnaireActionLetters](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StudyID] [nvarchar](100) NOT NULL,
	[PatientID] [nvarchar](200) NOT NULL,
	[ResultsSetID] [varchar](50) NOT NULL,
	[LetterID] [varchar](50) NOT NULL,
	[Recipient] [varchar](50) NOT NULL,
	[ProcessedDate] [datetime] NULL,
	[ProcessedBy] [nvarchar](250) NULL,
	[FileID] [int] NULL,
 CONSTRAINT [PK_QuestionnaireActionLetters] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Reading]    Script Date: 11/09/2016 21:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reading](
	[ReadingId] [int] IDENTITY(1,1) NOT NULL,
	[PatientId] [nvarchar](200) NOT NULL,
	[StudyId] [nvarchar](100) NOT NULL,
	[ReadingEntered] [nvarchar](50) NOT NULL,
	[ReadingTypeId] [int] NOT NULL,
	[SubmittedBy] [nvarchar](50) NULL,
	[DateOfReading] [datetime] NOT NULL,
	[Valid] [bit] NOT NULL,
	[DateSubmitted] [datetime] NOT NULL,
 CONSTRAINT [PK_Reading] PRIMARY KEY CLUSTERED 
(
	[ReadingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ReadingTarget]    Script Date: 11/09/2016 21:32:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReadingTarget](
	[ReadingTargetId] [int] IDENTITY(1,1) NOT NULL,
	[Target] [nvarchar](25) NOT NULL,
	[ReadingTypeId] [int] NOT NULL,
	[PatientId] [nvarchar](200) NOT NULL,
	[StudyId] [nvarchar](100) NOT NULL,
	[SubmittedBy] [nvarchar](50) NULL,
	[DateEntered] [datetime] NOT NULL,
	[Valid] [bit] NOT NULL,
 CONSTRAINT [PK_ReadingTarget] PRIMARY KEY CLUSTERED 
(
	[ReadingTargetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StudyType]    Script Date: 11/09/2016 21:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudyType](
	[StudyTypeId] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[StudyType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_StudyType] PRIMARY KEY CLUSTERED 
(
	[StudyTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ELMAH_Error_App_Time_Seq]    Script Date: 11/09/2016 21:32:15 ******/
CREATE NONCLUSTERED INDEX [IX_ELMAH_Error_App_Time_Seq] ON [dbo].[ELMAH_Error]
(
	[Application] ASC,
	[TimeUtc] DESC,
	[Sequence] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Callback] ADD  CONSTRAINT [DF_Callback_CallbackId]  DEFAULT (newid()) FOR [CallbackId]
GO
ALTER TABLE [dbo].[Callback] ADD  CONSTRAINT [DF_Callback_Completed]  DEFAULT ((0)) FOR [Completed]
GO
ALTER TABLE [dbo].[CallbackPatientComments] ADD  CONSTRAINT [DF_PatientComments_CommentsDate]  DEFAULT (getdate()) FOR [CommentsDate]
GO
ALTER TABLE [dbo].[CallOutcomeReason] ADD  CONSTRAINT [DF_OutcomeReason_OutcomeId]  DEFAULT (newid()) FOR [OutcomeId]
GO
ALTER TABLE [dbo].[ContentSectionStatus] ADD  CONSTRAINT [DF_ContentSectionStatus_ContentSectionStatusId]  DEFAULT (newid()) FOR [ContentSectionStatusId]
GO
ALTER TABLE [dbo].[ELMAH_Error] ADD  CONSTRAINT [DF_ELMAH_Error_ErrorId]  DEFAULT (newid()) FOR [ErrorId]
GO
ALTER TABLE [dbo].[Files] ADD  CONSTRAINT [DF_Files_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[GpPracticeAddress] ADD  CONSTRAINT [DF_GpPracticeAddress_GpPracticeAddressId]  DEFAULT (newid()) FOR [GpPracticeAddressId]
GO
ALTER TABLE [dbo].[Language] ADD  CONSTRAINT [DF_Language_LanguageId]  DEFAULT (newid()) FOR [LanguageId]
GO
ALTER TABLE [dbo].[PasswordResetRequest] ADD  CONSTRAINT [DF_PasswordResetRequest_PasswordResetRequestId]  DEFAULT (newid()) FOR [PasswordResetRequestId]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_PatientId]  DEFAULT (newid()) FOR [PatientId]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_CallAttempt]  DEFAULT ((0)) FOR [CallAttempt]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_IsLocked]  DEFAULT ((0)) FOR [IsLocked]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Reading] ADD  CONSTRAINT [DF_Reading_Valid]  DEFAULT ((1)) FOR [Valid]
GO
ALTER TABLE [dbo].[Reading] ADD  CONSTRAINT [DF_Reading_DateSubmitted]  DEFAULT (getdate()) FOR [DateSubmitted]
GO
ALTER TABLE [dbo].[ReadingExpected] ADD  CONSTRAINT [DF_ReadingExpected_ReadingGiven]  DEFAULT ((0)) FOR [ReadingGiven]
GO
ALTER TABLE [dbo].[ReadingTarget] ADD  CONSTRAINT [DF_ReadingTarget_Valid]  DEFAULT ((1)) FOR [Valid]
GO
ALTER TABLE [dbo].[StudyType] ADD  CONSTRAINT [DF_Study_StudyTypeId]  DEFAULT (newid()) FOR [StudyTypeId]
GO
ALTER TABLE [dbo].[CallbackPatientComments]  WITH CHECK ADD  CONSTRAINT [FK_CallbackPatientComments_Callback] FOREIGN KEY([CallbackID])
REFERENCES [dbo].[Callback] ([CallbackId])
GO
ALTER TABLE [dbo].[CallbackPatientComments] CHECK CONSTRAINT [FK_CallbackPatientComments_Callback]
GO
ALTER TABLE [dbo].[FileData]  WITH CHECK ADD  CONSTRAINT [FK_FileData_Files] FOREIGN KEY([FileID])
REFERENCES [dbo].[Files] ([FileID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FileData] CHECK CONSTRAINT [FK_FileData_Files]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK_Patient_Language] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[Language] ([LanguageId])
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [FK_Patient_Language]
GO
ALTER TABLE [dbo].[QuestionnaireActionLetters]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnaireActionLetters_Files] FOREIGN KEY([FileID])
REFERENCES [dbo].[Files] ([FileID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[QuestionnaireActionLetters] CHECK CONSTRAINT [FK_QuestionnaireActionLetters_Files]
GO
/****** Object:  StoredProcedure [dbo].[ELMAH_GetErrorsXml]    Script Date: 11/09/2016 21:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ELMAH_GetErrorsXml]
(
    @Application NVARCHAR(60),
    @PageIndex INT = 0,
    @PageSize INT = 15,
    @TotalCount INT OUTPUT
)
AS 

    SET NOCOUNT ON

    DECLARE @FirstTimeUTC DATETIME
    DECLARE @FirstSequence INT
    DECLARE @StartRow INT
    DECLARE @StartRowIndex INT

    SELECT 
        @TotalCount = COUNT(1) 
    FROM 
        [ELMAH_Error]
    WHERE 
        [Application] = @Application

    -- Get the ID of the first error for the requested page

    SET @StartRowIndex = @PageIndex * @PageSize + 1

    IF @StartRowIndex <= @TotalCount
    BEGIN

        SET ROWCOUNT @StartRowIndex

        SELECT  
            @FirstTimeUTC = [TimeUtc],
            @FirstSequence = [Sequence]
        FROM 
            [ELMAH_Error]
        WHERE   
            [Application] = @Application
        ORDER BY 
            [TimeUtc] DESC, 
            [Sequence] DESC

    END
    ELSE
    BEGIN

        SET @PageSize = 0

    END

    -- Now set the row count to the requested page size and get
    -- all records below it for the pertaining application.

    SET ROWCOUNT @PageSize

    SELECT 
        errorId     = [ErrorId], 
        application = [Application],
        host        = [Host], 
        type        = [Type],
        source      = [Source],
        message     = [Message],
        [user]      = [User],
        statusCode  = [StatusCode], 
        time        = CONVERT(VARCHAR(50), [TimeUtc], 126) + 'Z'
    FROM 
        [ELMAH_Error] error
    WHERE
        [Application] = @Application
    AND
        [TimeUtc] <= @FirstTimeUTC
    AND 
        [Sequence] <= @FirstSequence
    ORDER BY
        [TimeUtc] DESC, 
        [Sequence] DESC
    FOR
        XML AUTO

GO
/****** Object:  StoredProcedure [dbo].[ELMAH_GetErrorXml]    Script Date: 11/09/2016 21:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ELMAH_GetErrorXml]
(
    @Application NVARCHAR(60),
    @ErrorId UNIQUEIDENTIFIER
)
AS

    SET NOCOUNT ON

    SELECT 
        [AllXml]
    FROM 
        [ELMAH_Error]
    WHERE
        [ErrorId] = @ErrorId
    AND
        [Application] = @Application

GO
/****** Object:  StoredProcedure [dbo].[ELMAH_LogError]    Script Date: 11/09/2016 21:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ELMAH_LogError]
(
    @ErrorId UNIQUEIDENTIFIER,
    @Application NVARCHAR(60),
    @Host NVARCHAR(30),
    @Type NVARCHAR(100),
    @Source NVARCHAR(60),
    @Message NVARCHAR(500),
    @User NVARCHAR(50),
    @AllXml NVARCHAR(MAX),
    @StatusCode INT,
    @TimeUtc DATETIME
)
AS

    SET NOCOUNT ON

    INSERT
    INTO
        [ELMAH_Error]
        (
            [ErrorId],
            [Application],
            [Host],
            [Type],
            [Source],
            [Message],
            [User],
            [AllXml],
            [StatusCode],
            [TimeUtc]
        )
    VALUES
        (
            @ErrorId,
            @Application,
            @Host,
            @Type,
            @Source,
            @Message,
            @User,
            @AllXml,
            @StatusCode,
            @TimeUtc
        )

GO
/****** Object:  StoredProcedure [dbo].[GetAllCallOutcomeReasons]    Script Date: 11/09/2016 21:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllCallOutcomeReasons]
AS
BEGIN
     SELECT Reason FROM dbo.CallOutcomeReason
END

GO
/****** Object:  StoredProcedure [dbo].[GetAllOutBoundCallsBetweenTwoDates]    Script Date: 11/09/2016 21:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROCEDURE [dbo].[GetAllOutBoundCallsBetweenTwoDates]
@pStartDate DATETIME,
@pEndDate DATETIME,
@pCallHandlerName NVARCHAR(100)
AS
BEGIN
SELECT      
      [DateOfQuestionaire]
      ,dbo.GetPatientName([PatientId]) [Name]
      ,dbo.GetCallOutCome([OutcomeId]) [CallOutCome]     
      ,[SurveySavedBy] [CallHandlerName]
  FROM [WeatherWatch].[dbo].[Questionaire]
  WHERE DateofQuestionaire Between @pStartDate AND @pEndDate AND SurveySavedBy=@pCallHandlerName
  
  ORDER BY [Name]
  END

GO
/****** Object:  StoredProcedure [dbo].[GetCallHandlerNames]    Script Date: 11/09/2016 21:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- stored Procedure gives all callhandler Names, This  will be used in Reports for passing CallHandlerNames in the Reports
CREATE PROCEDURE [dbo].[GetCallHandlerNames]
AS
BEGIN
      SELECT 
				Distinct SurveySavedBy 
	  FROM
	           Questionaire
	  ORDER BY SurveySavedBy ASC
END

GO
/****** Object:  StoredProcedure [dbo].[GetNumberOfPatientsContactedBetweenTwoDates]    Script Date: 11/09/2016 21:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetNumberOfPatientsContactedBetweenTwoDates]
@pStartDate DATETIME,
@pEndDate DATETIME
AS
;
With LatestQuestionaitre_CTE (RowNo,[QuestionaireId]
       ,[DateOfQuestionaire]
      ,Name   
      ,CallOutcome
      ,[HelpImproveOurService]
      ,[SurveySavedBy]
      ,[ContactedByGP]
      ,[FluJabReceived]
      ,[HasRescuePack]
      ,[HomeWarmEnough]
      ,[KeepingWarmOutdoors]
      ,[KnowWhereForHelp]
      ,[HaveNecessaryMedication]
      ,[KeepingActive]
      ,[AnyFallsInPastWeek]
      ,[AreYouEatingWell]
      ,[AnyHospitalAdmission]
      ,[AnyGPVisit]
      ,[AnyHealthConcerns]) AS
(
SELECT ROW_NUMBER() OVER (PARTITION BY PatientId Order by DateOfQuestionaire DESC) AS 'RowNo'
	,[QuestionaireId]
      ,[DateOfQuestionaire]
      ,dbo.GetPatientName([PatientId]) as Name     
      ,dbo.GetCallOutcome([OutcomeId]) as CallOutcome
      ,[HelpImproveOurService]
      ,[SurveySavedBy]
      ,[ContactedByGP]
      ,[FluJabReceived]
      ,[HasRescuePack]
      ,[HomeWarmEnough]
      ,[KeepingWarmOutdoors]
      ,[KnowWhereForHelp]
      ,[HaveNecessaryMedication]
      ,[KeepingActive]
      ,[AnyFallsInPastWeek]
      ,[AreYouEatingWell]
      ,[AnyHospitalAdmission]
      ,[AnyGPVisit]
      ,[AnyHealthConcerns]
FROM 
	 [WeatherWatch].[dbo].[Questionaire] 
WHERE
[DateOfQuestionaire] BETWEEN @pStartDate AND @pEndDate -- Need Records between these two user provided dates
)
SELECT *  FROM LatestQuestionaitre_CTE where rowno=1 --We need individual Patients, so ordering by will give the latest record
Order By Name --Orders By Name

GO
/****** Object:  StoredProcedure [dbo].[GetPatientsContactNotPossible]    Script Date: 11/09/2016 21:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetPatientsContactNotPossible]
@pStartDate DATETIME,
@pEndDate DATETIME
AS
;
With LatestQuestionaitre_CTE (RowNo,[QuestionaireId]
       ,[DateOfQuestionaire]
      ,Name   
      ,CallOutcome
      ,[HelpImproveOurService]
      ,[SurveySavedBy]
      ,[ContactedByGP]
      ,[FluJabReceived]
      ,[HasRescuePack]
      ,[HomeWarmEnough]
      ,[KeepingWarmOutdoors]
      ,[KnowWhereForHelp]
      ,[HaveNecessaryMedication]
      ,[KeepingActive]
      ,[AnyFallsInPastWeek]
      ,[AreYouEatingWell]
      ,[AnyHospitalAdmission]
      ,[AnyGPVisit]
      ,[AnyHealthConcerns]) AS
(
SELECT ROW_NUMBER() OVER (PARTITION BY PatientId Order by DateOfQuestionaire DESC) AS 'RowNo'
	,[QuestionaireId]
      ,[DateOfQuestionaire]
      ,dbo.GetPatientName([PatientId]) as Name     
      ,dbo.GetCallOutcome([OutcomeId]) as CallOutcome
      ,[HelpImproveOurService]
      ,[SurveySavedBy]
      ,[ContactedByGP]
      ,[FluJabReceived]
      ,[HasRescuePack]
      ,[HomeWarmEnough]
      ,[KeepingWarmOutdoors]
      ,[KnowWhereForHelp]
      ,[HaveNecessaryMedication]
      ,[KeepingActive]
      ,[AnyFallsInPastWeek]
      ,[AreYouEatingWell]
      ,[AnyHospitalAdmission]
      ,[AnyGPVisit]
      ,[AnyHealthConcerns]
FROM 
	 [WeatherWatch].[dbo].[Questionaire] 
WHERE 
(dbo.GetCallOutcome([OutcomeId]) LIKE '%No answer 3rd attempt (closed contact)%'
) 
AND
([DateOfQuestionaire] BETWEEN @pStartDate AND @pEndDate)

 
)
SELECT * FROM LatestQuestionaitre_CTE WHERE ROWNO=1
ORDER BY Name

GO
/****** Object:  StoredProcedure [dbo].[GetPatientsDeclinedService]    Script Date: 11/09/2016 21:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetPatientsDeclinedService]
@pStartDate DATETIME,
@pEndDate DATETIME
AS
;
With LatestQuestionaitre_CTE (RowNo,[QuestionaireId]
       ,[DateOfQuestionaire]
      ,Name   
      ,CallOutcome
      ,[HelpImproveOurService]
      ,[SurveySavedBy]
      ,[ContactedByGP]
      ,[FluJabReceived]
      ,[HasRescuePack]
      ,[HomeWarmEnough]
      ,[KeepingWarmOutdoors]
      ,[KnowWhereForHelp]
      ,[HaveNecessaryMedication]
      ,[KeepingActive]
      ,[AnyFallsInPastWeek]
      ,[AreYouEatingWell]
      ,[AnyHospitalAdmission]
      ,[AnyGPVisit]
      ,[AnyHealthConcerns]) AS
(
SELECT ROW_NUMBER() OVER (PARTITION BY PatientId Order by DateOfQuestionaire DESC) AS 'RowNo'
	,[QuestionaireId]
      ,[DateOfQuestionaire]
      ,dbo.GetPatientName([PatientId]) as Name     
      ,dbo.GetCallOutcome([OutcomeId]) as CallOutcome
      ,[HelpImproveOurService]
      ,[SurveySavedBy]
      ,[ContactedByGP]
      ,[FluJabReceived]
      ,[HasRescuePack]
      ,[HomeWarmEnough]
      ,[KeepingWarmOutdoors]
      ,[KnowWhereForHelp]
      ,[HaveNecessaryMedication]
      ,[KeepingActive]
      ,[AnyFallsInPastWeek]
      ,[AreYouEatingWell]
      ,[AnyHospitalAdmission]
      ,[AnyGPVisit]
      ,[AnyHealthConcerns]
FROM 
	 [WeatherWatch].[dbo].[Questionaire] 
WHERE 
(dbo.GetCallOutcome([OutcomeId]) LIKE '%withdraw%'
) 
AND
([DateOfQuestionaire] BETWEEN @pStartDate AND @pEndDate)

 
)
SELECT * FROM LatestQuestionaitre_CTE WHERE ROWNO=1
ORDER BY Name

GO
/****** Object:  StoredProcedure [dbo].[PercentageofPatientsWithVariousCallOutcomeReasons]    Script Date: 11/09/2016 21:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PercentageofPatientsWithVariousCallOutcomeReasons]
@pStartDate DATETIME, -- Start Date Parameter
@pEndDate DATETIME,--End Date Parameter
@pCallOutcomeReason VARCHAR(100)--CallOutcome Reasons Paramter, it will be drop down
AS
;
DECLARE @TotalCount Decimal(18,3);--Variable conatins the total no of record, Will be used to calculate % at the end in this SP

DECLARE @TEMP AS TABLE --Declare Temp Table to hold the data
(
	RowNo INT,
	[QuestionaireId] UNIQUEIDENTIFIER
	,[DateOfQuestionaire] DATETIME
	,Name   VARCHAR(100)
	,Reason Varchar(100)
)
INSERT INTO @TEMP --Insert Values into the Temp Table	

SELECT  -- Get the latest records based on dateadded
       ROW_NUMBER() OVER (PARTITION BY PatientId Order by DateOfQuestionaire DESC) AS 'RowNo'
	  ,[QuestionaireId]
	  ,[DateOfQuestionaire]
	  ,dbo.GetPatientName([PatientId]) as Name   
	  ,dbo.GetCallOutcome([OutComeId]) as Reason
FROM 
      [WeatherWatch].[dbo].[Questionaire] 
WHERE
	  [DateOfQuestionaire] BETWEEN @pStartDate AND @pEndDate -- Need Records between these two user provided dates
      SET @TotalCount=(SELECT count(1) TotalRecords FROM @Temp where ROWNO=1);--rowno=1 will eliminate the duplicate records and gets latest record for patient. Set the Value in @TotalCount

--Other Common Table Expression Based on Table Variable @Temp.      
With PatientsBeenReferedToCommunityService_CTE 
        (
			 RowNo
			,[QuestionaireId]
			,[DateOfQuestionaire]
			,Name   
			,CallOutcome
        ) 
        AS
		(
			SELECT 
				    ROW_NUMBER() OVER (PARTITION BY Name Order by DateOfQuestionaire DESC) AS 'RowNo'
				   ,[QuestionaireId]
				   ,[DateOfQuestionaire]
				   ,Name     
				   ,Reason
		    FROM 
					@Temp
		    WHERE
		            RowNo=1 AND
					Reason=@pCallOutcomeReason AND -- Reason comes from call handler
					[DateOfQuestionaire] BETWEEN @pStartDate AND @pEndDate -- Need Records between these two user provided dates
		)
	--This is Query Which Will Generate the % and number of records
	SELECT 
				@TotalCount [AllRecords],-- No Of Records
				(SELECT COUNT(*) FROM  PatientsBeenReferedToCommunityService_CTE where rowno=1) [CallOutcomeReason], '[Percentage]'=
				CASE -- Checking for Number of records
				     WHEN @TotalCount=0	THEN  0.000--When equal to zero then percentage should be equal to 0
				     ELSE --Calculate the appropriate percentage.
				     (CONVERT(DECIMAL(18,3), ((SELECT COUNT(*) FROM  PatientsBeenReferedToCommunityService_CTE where rowno=1) / @TotalCount))) 
				     END

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active = 1, Withdrawn=2,  Refused=3,  Complete=4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Patient', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[42] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 5
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'GetPatientsWithCallbacksInThreeDays'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'GetPatientsWithCallbacksInThreeDays'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "re"
            Begin Extent = 
               Top = 35
               Left = 312
               Bottom = 223
               Right = 502
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pa"
            Begin Extent = 
               Top = 34
               Left = 21
               Bottom = 234
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'GetPatientsWithOverdueReadings'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'GetPatientsWithOverdueReadings'
GO
USE [master]
GO
ALTER DATABASE [Healthlines_Portal] SET  READ_WRITE 
GO
