USE [master]
GO
/****** Object:  Database [ErrorReports-test]    Script Date: 04/17/2006 22:42:53 ******/
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'ErrorReports-test')
BEGIN
CREATE DATABASE [ErrorReports-test] ON  PRIMARY 
( NAME = N'ErrorReports', FILENAME = N'D:\mssql\test\data\ErrorReports-test.mdf' , SIZE = 21504KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ErrorReports_log', FILENAME = N'D:\mssql\test\log\ErrorReports_log-test.ldf' , SIZE = 24384KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
END

GO
EXEC dbo.sp_dbcmptlevel @dbname=N'ErrorReports-test', @new_cmptlevel=90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ErrorReports-test].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ErrorReports-test] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ErrorReports-test] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ErrorReports-test] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ErrorReports-test] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ErrorReports-test] SET ARITHABORT OFF 
GO
ALTER DATABASE [ErrorReports-test] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [ErrorReports-test] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [ErrorReports-test] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ErrorReports-test] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ErrorReports-test] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ErrorReports-test] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ErrorReports-test] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ErrorReports-test] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ErrorReports-test] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ErrorReports-test] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ErrorReports-test] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ErrorReports-test] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ErrorReports-test] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ErrorReports-test] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ErrorReports-test] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ErrorReports-test] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ErrorReports-test] SET  READ_WRITE 
GO
ALTER DATABASE [ErrorReports-test] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ErrorReports-test] SET  MULTI_USER 
GO
ALTER DATABASE [ErrorReports-test] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ErrorReports-test] SET DB_CHAINING OFF 
USE [ErrorReports-test]
GO
/****** Object:  Table [dbo].[ReplyTemplates]    Script Date: 04/17/2006 22:42:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReplyTemplates]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReplyTemplates](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TemplateText] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ReplyTemplates] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[MailItems]    Script Date: 04/17/2006 22:42:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MailItems]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MailItems](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[SenderName] [nvarchar](max) NULL,
	[SenderEmail] [nvarchar](max) NOT NULL,
	[RecipientName] [nvarchar](max) NULL,
	[RecipientEmail] [nvarchar](max) NOT NULL,
	[OldErrorReportID] [nvarchar](250) NOT NULL,
	[ParentReply] [int] NULL,
	[Time] [datetime] NOT NULL,
	[MailID] [nvarchar](250) NULL,
	[ErrorReportID] [int] NULL,
	[Subject] [nvarchar](max) NULL,
	[RepliedTo] [bit] NOT NULL CONSTRAINT [DF_MailItems_RepliedTo]  DEFAULT ((0)),
 CONSTRAINT [PK_ErrorReplies] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ErrorReports]    Script Date: 04/17/2006 22:42:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ErrorReports]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ErrorReports](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ExceptionType] [nvarchar](max) NULL,
	[ExceptionMessage] [text] NULL,
	[StackTrace] [text] NULL,
	[MajorVersion] [int] NULL,
	[MinorVersion] [int] NULL,
	[PatchVersion] [int] NULL,
	[Revision] [int] NULL,
	[ErrorReportItemID] [nvarchar](250) NOT NULL,
	[MailItemID] [int] NULL,
 CONSTRAINT [PK_ErrorReports] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[StackTraceLines]    Script Date: 04/17/2006 22:42:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StackTraceLines]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StackTraceLines](
	[OldErrorReportItem] [nvarchar](250) NOT NULL,
	[MethodName] [nvarchar](max) NULL,
	[Parameters] [nvarchar](max) NULL,
	[Filename] [nvarchar](max) NULL,
	[LineNumber] [int] NULL,
	[SequenceNumber] [int] NOT NULL,
	[ErrorReportItem] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  StoredProcedure [dbo].[ImportErrorItem]    Script Date: 04/17/2006 22:42:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ImportErrorItem]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ImportErrorItem] 
	-- Add the parameters for the stored procedure here
	@InternetMailID nvarchar(250) = null, 
	@ReceivedTime DateTime = null,
	@SubmitterEmail nvarchar(max) = null,
	@SubmitterName nvarchar(max) = null,
	@Body Text = null,
	@Subject nvarchar(max) = null,
	@ExceptionType nvarchar(max) = null,
	@ExceptionMessage text = null,
	@StackTrace text = null,
	@MajorVersion int = null,
	@MinorVersion int = null,
	@PatchVersion int = null,
	@Revision int = null,
	@RepliedTo bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
		IF EXISTS (SELECT 1 FROM MailItems WHERE MailID=@InternetMailID)
		BEGIN
			DECLARE @mailID int;
			DECLARE @errorReportID int;
		
			INSERT INTO MailItems
					(Body, SenderName, SenderEmail, 
						RecipientName, RecipientEmail, [Time], MailID)
				VALUES(@Body, @SubmitterName, @SubmitterEmail, '''', '''', @ReceivedTime, @InternetMailID)

			SET @mailID = SCOPE_IDENTITY();
			INSERT INTO ErrorReports
					(ExceptionType, ExceptionMessage, StackTrace, MajorVersion, MinorVersion,
					 PatchVersion, Revision, MailItemID)
				VALUES(@ExceptionType, @ExceptionMessage, @StackTrace, @MajorVersion, 
					   @MinorVersion, @PatchVersion, @Revision, @mailID)

			SET @errorReportID = SCOPE_IDENTITY();

			UPDATE MailItems SET ErrorReportID = @errorReportID WHERE (ID=@mailID)

			
			SELECT @errorReportID
		END
		ELSE
		BEGIN
			SELECT 0
		END
	END TRY
	BEGIN CATCH
		IF (XACT_STATE())=-1 ROLLBACK TRANSACTION;
		SELECT 0
	END CATCH
END



' 
END
GO
/****** Object:  StoredProcedure [dbo].[ReplyToReport]    Script Date: 04/17/2006 22:42:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReplyToReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Arild Fines
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ReplyToReport] 
	-- Add the parameters for the stored procedure here
	@ReportId int, 
	@ReplyText nvarchar(MAX) ,	
	@SenderEmail nvarchar(MAX),
	@RecipientEmail nvarchar(MAX),
	@SenderName nvarchar(MAX) = NULL,
	@RecipientName nvarchar(MAX) = NULL, 
	@ParentReply int = NULL,
	@ReplyTime DateTime = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @ReplyTime IS NULL 
	BEGIN
		SET @ReplyTime = GetDate()
	END

	BEGIN TRANSACTION
		INSERT INTO MailItems (ErrorReportID, Body, SenderEmail, RecipientEmail,
			SenderName, RecipientName, ParentReply, [Time])
			VALUES (@ReportID, @ReplyText, @SenderEmail, @RecipientEmail,
			@SenderName, @RecipientName, @ParentReply, @ReplyTime)
		
	
		COMMIT TRANSACTION
		SELECT 1
END


' 
END
GO
/****** Object:  StoredProcedure [dbo].[InsertPotentialErrorReply]    Script Date: 04/17/2006 22:42:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InsertPotentialErrorReply]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




-- =============================================
-- Author:		Arild Fines
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[InsertPotentialErrorReply] 
	-- Add the parameters for the stored procedure here
	@InternetMailID nvarchar(250), 
	@ReceivedTime DateTime,
	@SenderEmail nvarchar(max),
	@SenderName nvarchar(max),
	@RecipientEmail nvarchar(max),
	@RecipientName nvarchar(max),
	@Body Text,
	@Subject nvarchar(max),
	@ReplyToID nvarchar(250)
AS
BEGIN
	BEGIN TRY
		IF EXISTS( SELECT 1 FROM MailItems WHERE MailID=@InternetMailId )
		BEGIN
			SELECT 2
			RETURN
		END

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;
		BEGIN TRANSACTION
		
		DECLARE @parentID int;
		DECLARE @errorReport int;
		SET @parentID = (SELECT ID FROM MailItems WHERE MailID=@ReplyToID)
		SET @errorReport = (SELECT ErrorReportID FROM MailItems WHERE MailID=@ReplyToID)
		IF @errorReport IS NOT NULL
		BEGIN
			INSERT INTO MailItems (ErrorReportID, Body, SenderEmail, RecipientEmail,
					SenderName, RecipientName, ParentReply, [Time], MailID)
				VALUES (@errorReport, @Body, @SenderEmail, @RecipientEmail,
					@SenderName, @RecipientName, @parentID, @ReceivedTime, @InternetMailID)
			SELECT 1
		END 
		ELSE
		BEGIN
			SELECT 0
		END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF (XACT_STATE())=-1 ROLLBACK TRANSACTION;
		SELECT ERROR_MESSAGE()
	END CATCH

END





' 
END
GO
/****** Object:  View [dbo].[ErrorReportItems]    Script Date: 04/17/2006 22:42:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ErrorReportItems]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[ErrorReportItems]
AS
SELECT     dbo.MailItems.Body, dbo.MailItems.SenderName, dbo.MailItems.SenderEmail, dbo.MailItems.RecipientName, dbo.MailItems.RecipientEmail, 
                      dbo.MailItems.ParentReply, dbo.MailItems.Time, dbo.MailItems.MailID, dbo.ErrorReports.ID, dbo.ErrorReports.ExceptionType, 
                      dbo.ErrorReports.ExceptionMessage, dbo.ErrorReports.StackTrace, dbo.ErrorReports.MajorVersion, dbo.ErrorReports.MinorVersion, 
                      dbo.ErrorReports.PatchVersion, dbo.ErrorReports.Revision, dbo.ErrorReports.ErrorReportItemID, dbo.ErrorReports.MailItemID, dbo.MailItems.Subject, 
                      dbo.MailItems.RepliedTo
FROM         dbo.ErrorReports INNER JOIN
                      dbo.MailItems ON dbo.ErrorReports.MailItemID = dbo.MailItems.ID
' 
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
         Begin Table = "ErrorReports"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 209
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MailItems"
            Begin Extent = 
               Top = 68
               Left = 364
               Bottom = 183
               Right = 529
            End
            DisplayFlags = 280
            TopColumn = 9
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 1500
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
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'ErrorReportItems'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'ErrorReportItems'

GO
USE [ErrorReports-test]
GO
USE [ErrorReports-test]
GO
USE [ErrorReports-test]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ErrorReplies_ErrorReplies]') AND parent_object_id = OBJECT_ID(N'[dbo].[MailItems]'))
ALTER TABLE [dbo].[MailItems]  WITH CHECK ADD  CONSTRAINT [FK_ErrorReplies_ErrorReplies] FOREIGN KEY([ParentReply])
REFERENCES [dbo].[MailItems] ([ID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MailItems_MailItems]') AND parent_object_id = OBJECT_ID(N'[dbo].[MailItems]'))
ALTER TABLE [dbo].[MailItems]  WITH CHECK ADD  CONSTRAINT [FK_MailItems_MailItems] FOREIGN KEY([ID])
REFERENCES [dbo].[MailItems] ([ID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ErrorReports_MailItems]') AND parent_object_id = OBJECT_ID(N'[dbo].[ErrorReports]'))
ALTER TABLE [dbo].[ErrorReports]  WITH CHECK ADD  CONSTRAINT [FK_ErrorReports_MailItems] FOREIGN KEY([MailItemID])
REFERENCES [dbo].[MailItems] ([ID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StackTraceLines_ErrorReports]') AND parent_object_id = OBJECT_ID(N'[dbo].[StackTraceLines]'))
ALTER TABLE [dbo].[StackTraceLines]  WITH CHECK ADD  CONSTRAINT [FK_StackTraceLines_ErrorReports] FOREIGN KEY([ErrorReportItem])
REFERENCES [dbo].[ErrorReports] ([ID])
