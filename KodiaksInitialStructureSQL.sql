CREATE SCHEMA [Sec]
GO
CREATE SCHEMA [App]
GO
CREATE SCHEMA [Fina]
GO
CREATE SCHEMA [Stats]
GO
CREATE TABLE [App].[Roles](
	RoleId INT IDENTITY(1,1),
	RoleDescription VARCHAR(60) NOT NULL UNIQUE,
	CONSTRAINT PK_App_Roles_Id PRIMARY KEY (RoleId)
)
GO
SET IDENTITY_INSERT [App].[Roles] ON; 
INSERT INTO [App].[Roles]
	(RoleId,RoleDescription)
VALUES
	(1,'SuperAdmin'),
	(2,'Admin'),
	(3,'User')
SET IDENTITY_INSERT [App].[Roles] OFF; 
GO
CREATE TABLE [App].[MenuItems](
	MenuItemId INT IDENTITY(1,1),
	Title VARCHAR(50) NOT NULL UNIQUE,
	IconSource VARCHAR(100) NULL,
	TargetPage VARCHAR(150) NOT NULL UNIQUE, 
	CONSTRAINT PK_App_MenuItems_Id PRIMARY KEY (MenuItemId)
)
GO
SET IDENTITY_INSERT [App].[MenuItems] ON; 
INSERT INTO [App].[MenuItems]
	(MenuItemId,Title,IconSource,TargetPage)
VALUES
	(1,'Inicio', 'icon_about.png', 'KodiaksApp.Detail'),
	(2,'Usuarios', 'icon_feed.png', 'KodiaksApp.Views.vwUsuarios')
SET IDENTITY_INSERT [App].[MenuItems] OFF;
GO
CREATE TABLE [App].[AssignRoleMenu](
	RoleId INT NOT NULL,	
	MenuItemId INT NOT NULL,
	CONSTRAINT UK_App_AssignRoleMenu_RolMenu UNIQUE (RoleId,MenuItemId),
	CONSTRAINT FK_App_AssignRoleMenu_RolId FOREIGN KEY (RoleId) REFERENCES [App].[Roles](RoleId),
	CONSTRAINT FK_App_AssignRoleMenu_MenuItemId FOREIGN KEY (MenuItemId) REFERENCES [App].[MenuItems](MenuItemId)
)
GO
INSERT INTO [App].[AssignRoleMenu]
	(RoleId,MenuItemId)
VALUES
	(1,1),
	(1,2),
	(3,1)
GO
CREATE TABLE [Sec].[Users](
	UserId BIGINT IDENTITY(1,1),
	UserName VARCHAR(50) NOT NULL UNIQUE,
	[Password] VARCHAR(MAX) NOT NULL,
	[PasswordSalt] VARCHAR(MAX) NOT NULL,
	RoleId INT NOT NULL,
	CanEdit BIT NOT NULL DEFAULT(0),
	SavePasswords BIT NOT NULL DEFAULT(0),
	IsActive BIT NOT NULL DEFAULT(1),
	CreatedDate DATETIME NOT NULL DEFAULT (GETUTCDATE()),
	CONSTRAINT PK_Sec_Users_Id PRIMARY KEY (UserId),
	CONSTRAINT FK_Sec_Users_RolId FOREIGN KEY (RoleId) REFERENCES [App].[Roles](RoleId)
)
GO
CREATE TABLE [Sec].[PasswordsHistory](
	HistoryId BIGINT IDENTITY(1,1),
	UserId BIGINT NOT NULL,
	[Password] VARCHAR(MAX) NOT NULL,
	CONSTRAINT PK_Sec_PasswordsHistory_Id PRIMARY KEY (HistoryId),
	CONSTRAINT FK_Sec_PasswordsHistory_UserId FOREIGN KEY (UserId) REFERENCES [Sec].[Users](UserId)
)
GO
CREATE TABLE [Fina].[PaymentMethods](
	MethodId INT IDENTITY(1,1),
	MethodDesc VARCHAR(50) NOT NULL,
	CONSTRAINT PK_dbo_PaymentMethods_Id PRIMARY KEY (MethodId)
)
GO
INSERT INTO [Fina].[PaymentMethods]
	(MethodDesc)
VALUES
	('Transferencia'),
	('Efectivo')
GO
CREATE TABLE [Fina].[Members](
	MemberId BIGINT IDENTITY(1,1),
	UserId BIGINT NOT NULL,
	FullName VARCHAR(150),
	NickName VARCHAR(50),
	PhotoUrl VARCHAR(MAX),
	Birthday DATE NOT NULL,
	Email VARCHAR(50) UNIQUE,
	CellPhoneNumber VARCHAR(15) UNIQUE,
	CONSTRAINT PK_dbo_Members_Id PRIMARY KEY (MemberId),
	CONSTRAINT UK_dbo_Members_MemberIdUserId UNIQUE (MemberId,UserId),
	CONSTRAINT FK_dbo_Members_UserId FOREIGN KEY (UserId) REFERENCES [Sec].[Users](UserId)
)
GO
CREATE TABLE [Fina].[Concepts](
	ConceptId INT IDENTITY(1,1),
	ConceptDesc VARCHAR(50) NOT NULL,
	CONSTRAINT PK_dbo_Concepts_Id PRIMARY KEY (ConceptId)
)
GO
INSERT INTO [Fina].[Concepts]
	(ConceptDesc)
VALUES
	('Inscripción'),
	('Ampayeo'),
	('Uniformes'),
	('Hidratación'),
	('Ajuste')
GO
CREATE TABLE [Fina].[Payments](
	PaymentId BIGINT IDENTITY(1,1),
	MemberId BIGINT NOT NULL,
    PaymentDate DATETIME NOT NULL,
	ConceptId INT NOT NULL,
    MethodId INT NOT NULL,
	Amount DECIMAL(16,2) NOT NULL,
	AdditionalComment VARCHAR(200),
    EvidenceUrl VARCHAR(MAX),
	CONSTRAINT PK_dbo_Payments_Id PRIMARY KEY (PaymentId),
	CONSTRAINT FK_dbo_Payments_MethodId FOREIGN KEY (MethodId) REFERENCES [dbo].[PaymentMethods](MethodId),
	CONSTRAINT FK_dbo_Payments_MemberId FOREIGN KEY (MemberId) REFERENCES [dbo].[Members](MemberId),
	CONSTRAINT FK_dbo_Payments_ConceptId FOREIGN KEY (ConceptId) REFERENCES [dbo].[Concepts](ConceptId)
)
GO
CREATE TABLE [Fina].[Bills](
	BillId BIGINT IDENTITY(1,1),
	MemberId BIGINT NOT NULL,
    PaymentDate DATETIME NOT NULL,
	ConceptId INT NOT NULL,
    MethodId INT NOT NULL,
	Amount DECIMAL(16,2) NOT NULL,
    EvidenceUrl VARCHAR(MAX),
	CONSTRAINT PK_dbo_Payments_Id PRIMARY KEY (BillId),
	CONSTRAINT FK_dbo_Payments_MethodId FOREIGN KEY (MethodId) REFERENCES [dbo].[PaymentMethods](MethodId),
	CONSTRAINT FK_dbo_Payments_MemberId FOREIGN KEY (MemberId) REFERENCES [dbo].[Members](MemberId),
	CONSTRAINT FK_dbo_Payments_ConceptId FOREIGN KEY (ConceptId) REFERENCES [dbo].[Concepts](ConceptId)
)
GO