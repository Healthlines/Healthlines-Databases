USE [master]
GO
/****** Object:  Database [Questionnaire]    Script Date: 11/09/2016 21:38:30 ******/
CREATE DATABASE [Questionnaire]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Questionnaire', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Questionnaire.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Questionnaire_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Questionnaire_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Questionnaire] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Questionnaire].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Questionnaire] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Questionnaire] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Questionnaire] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Questionnaire] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Questionnaire] SET ARITHABORT OFF 
GO
ALTER DATABASE [Questionnaire] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Questionnaire] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Questionnaire] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Questionnaire] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Questionnaire] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Questionnaire] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Questionnaire] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Questionnaire] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Questionnaire] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Questionnaire] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Questionnaire] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Questionnaire] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Questionnaire] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Questionnaire] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Questionnaire] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Questionnaire] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Questionnaire] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Questionnaire] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Questionnaire] SET  MULTI_USER 
GO
ALTER DATABASE [Questionnaire] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Questionnaire] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Questionnaire] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Questionnaire] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Questionnaire] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Questionnaire] SET QUERY_STORE = OFF
GO
USE [Questionnaire]
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
USE [Questionnaire]
GO
/****** Object:  User [healthlines]    Script Date: 11/09/2016 21:38:31 ******/
CREATE USER [healthlines] FOR LOGIN [healthlines] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [healthlines]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [healthlines]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [healthlines]
GO
/****** Object:  Table [dbo].[AnswerOptions]    Script Date: 11/09/2016 21:38:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AnswerOptions](
	[AnswerOptionID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionID] [int] NOT NULL,
	[Label] [varchar](max) NOT NULL,
	[Order] [int] NOT NULL,
	[Type] [varchar](500) NOT NULL,
	[DefaultValue] [varchar](max) NOT NULL,
	[Required] [int] NULL,
	[RouteQuestionID] [int] NULL,
	[RouteConditionID] [int] NULL,
 CONSTRAINT [PK_AnswerOptions] PRIMARY KEY CLUSTERED 
(
	[AnswerOptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Answers]    Script Date: 11/09/2016 21:38:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Answers](
	[AnswerID] [int] IDENTITY(1,1) NOT NULL,
	[AnswerSetID] [int] NOT NULL,
	[QuestionID] [int] NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[OperatorID] [nvarchar](max) NOT NULL,
	[Type] [nvarchar](500) NOT NULL,
	[Page] [int] NOT NULL,
 CONSTRAINT [PK_Answers] PRIMARY KEY CLUSTERED 
(
	[AnswerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AnswerSets]    Script Date: 11/09/2016 21:38:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AnswerSets](
	[AnswerSetID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionnaireID] [int] NOT NULL,
	[OperatorID] [varchar](max) NOT NULL,
	[ParticipantID] [varchar](max) NOT NULL,
	[CurrentQuestionID] [int] NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[Completed] [bit] NOT NULL,
 CONSTRAINT [PK_AnswerSets] PRIMARY KEY CLUSTERED 
(
	[AnswerSetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Conditions]    Script Date: 11/09/2016 21:38:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conditions](
	[ConditionID] [int] IDENTITY(1,1) NOT NULL,
	[Label] [nchar](50) NOT NULL,
	[OperatorType] [varchar](50) NOT NULL,
	[ValueType] [varchar](50) NOT NULL,
	[Value1] [varchar](max) NOT NULL,
	[Value2] [varchar](max) NULL,
 CONSTRAINT [PK_Conditions] PRIMARY KEY CLUSTERED 
(
	[ConditionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QuestionnaireQuestionSets]    Script Date: 11/09/2016 21:38:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionnaireQuestionSets](
	[QuestionnaireQuestionSetsID] [int] IDENTITY(1,1) NOT NULL,
	[Order] [int] NOT NULL,
	[QuestionnaireID] [int] NOT NULL,
	[QuestionSetID] [int] NOT NULL,
 CONSTRAINT [PK_QuestionnaireQuestionSets] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireQuestionSetsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Questionnaires]    Script Date: 11/09/2016 21:38:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questionnaires](
	[QuestionnaireID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[CreatedBy] [nvarchar](250) NOT NULL,
	[CreationDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Questionnaires] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Questions]    Script Date: 11/09/2016 21:38:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questions](
	[QuestionID] [int] IDENTITY(1,1) NOT NULL,
	[Explanation] [nvarchar](max) NOT NULL,
	[QuestionText] [nvarchar](max) NOT NULL,
	[QuestionGroup] [nvarchar](max) NOT NULL,
	[Required] [bit] NOT NULL,
	[Label] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Questions] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QuestionSetQuestions]    Script Date: 11/09/2016 21:38:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionSetQuestions](
	[QuestionSetQuestionID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionSetID] [int] NOT NULL,
	[QuestionID] [int] NOT NULL,
	[Page] [int] NOT NULL,
	[Order] [int] NOT NULL,
 CONSTRAINT [PK_QuestionSetQuestions] PRIMARY KEY CLUSTERED 
(
	[QuestionSetQuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QuestionSets]    Script Date: 11/09/2016 21:38:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionSets](
	[QuestionSetID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[CreatedBy] [nvarchar](max) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_QuestionSets] PRIMARY KEY CLUSTERED 
(
	[QuestionSetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[AnswerOptions]  WITH CHECK ADD  CONSTRAINT [FK_AnswerOptions_Conditions] FOREIGN KEY([RouteConditionID])
REFERENCES [dbo].[Conditions] ([ConditionID])
GO
ALTER TABLE [dbo].[AnswerOptions] CHECK CONSTRAINT [FK_AnswerOptions_Conditions]
GO
ALTER TABLE [dbo].[AnswerOptions]  WITH CHECK ADD  CONSTRAINT [FK_AnswerOptions_Questions] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Questions] ([QuestionID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AnswerOptions] CHECK CONSTRAINT [FK_AnswerOptions_Questions]
GO
ALTER TABLE [dbo].[Answers]  WITH CHECK ADD  CONSTRAINT [FK_Answer_AnswerSets] FOREIGN KEY([AnswerSetID])
REFERENCES [dbo].[AnswerSets] ([AnswerSetID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Answers] CHECK CONSTRAINT [FK_Answer_AnswerSets]
GO
ALTER TABLE [dbo].[Answers]  WITH CHECK ADD  CONSTRAINT [FK_Answer_Questions] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Questions] ([QuestionID])
GO
ALTER TABLE [dbo].[Answers] CHECK CONSTRAINT [FK_Answer_Questions]
GO
ALTER TABLE [dbo].[AnswerSets]  WITH CHECK ADD  CONSTRAINT [FK_AnswerSets_Questions] FOREIGN KEY([CurrentQuestionID])
REFERENCES [dbo].[Questions] ([QuestionID])
GO
ALTER TABLE [dbo].[AnswerSets] CHECK CONSTRAINT [FK_AnswerSets_Questions]
GO
ALTER TABLE [dbo].[AnswerSets]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnaireAnswerSet] FOREIGN KEY([QuestionnaireID])
REFERENCES [dbo].[Questionnaires] ([QuestionnaireID])
GO
ALTER TABLE [dbo].[AnswerSets] CHECK CONSTRAINT [FK_QuestionnaireAnswerSet]
GO
ALTER TABLE [dbo].[QuestionnaireQuestionSets]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnaireQuestionnaireQuestionSets] FOREIGN KEY([QuestionnaireID])
REFERENCES [dbo].[Questionnaires] ([QuestionnaireID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[QuestionnaireQuestionSets] CHECK CONSTRAINT [FK_QuestionnaireQuestionnaireQuestionSets]
GO
ALTER TABLE [dbo].[QuestionnaireQuestionSets]  WITH CHECK ADD  CONSTRAINT [FK_QuestionSetQuestionnaireQuestionSets] FOREIGN KEY([QuestionSetID])
REFERENCES [dbo].[QuestionSets] ([QuestionSetID])
GO
ALTER TABLE [dbo].[QuestionnaireQuestionSets] CHECK CONSTRAINT [FK_QuestionSetQuestionnaireQuestionSets]
GO
ALTER TABLE [dbo].[QuestionSetQuestions]  WITH CHECK ADD  CONSTRAINT [FK_QuestionSetQuestions_Questions] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Questions] ([QuestionID])
GO
ALTER TABLE [dbo].[QuestionSetQuestions] CHECK CONSTRAINT [FK_QuestionSetQuestions_Questions]
GO
ALTER TABLE [dbo].[QuestionSetQuestions]  WITH CHECK ADD  CONSTRAINT [FK_QuestionSetQuestionSetQuestion] FOREIGN KEY([QuestionSetID])
REFERENCES [dbo].[QuestionSets] ([QuestionSetID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[QuestionSetQuestions] CHECK CONSTRAINT [FK_QuestionSetQuestionSetQuestion]
GO
USE [master]
GO
ALTER DATABASE [Questionnaire] SET  READ_WRITE 
GO
