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
	(2,'Usuarios', 'icon_feed.png', 'KodiaksApp.Views.vwUsuarios'),
	(3,'Finanzas', 'icon_feed.png', 'KodiaksApp.Views.vwFinanzas'),
	(4,'Roster', 'icon_feed.png', 'KodiaksApp.Views.vwRoster'),
	(5,'Juegos', 'icon_feed.png', 'KodiaksApp.Views.vwJuegos'),
	(6,'Asistencia', 'icon_feed.png', 'KodiaksApp.Views.vwAsistencia')
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
	IsVerified BIT NOT NULL DEFAULT(0),
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
CREATE TABLE [Stats].[BattingThrowingSides](
	BTSideId SMALLINT IDENTITY(1,1),
	KeyValue VARCHAR(5),
	BTSideDesc VARCHAR(50),
	CONSTRAINT PK_Stats_BattingThrowingSide_Id PRIMARY KEY (BTSideId)
)
GO
INSERT INTO [Stats].[BattingThrowingSides]
	(KeyValue,BTSideDesc)
VALUES
	('L/L', 'Left/Left'),
	('L/R', 'Left/Right'),
	('R/R', 'Right/Right'),
	('R/L', 'Right/Left')
GO
CREATE TABLE [App].[Members](
	MemberId BIGINT IDENTITY(1,1),
	UserId BIGINT NOT NULL,
	FullName VARCHAR(150),
	NickName VARCHAR(50),
	ShirtNumber INT NOT NULL,
	BTSideId SMALLINT NOT NULL,
	PhotoUrl VARCHAR(MAX),
	Birthday DATE NOT NULL,
	Email VARCHAR(50) UNIQUE,
	CellPhoneNumber VARCHAR(15) UNIQUE,
	CONSTRAINT PK_Fina_Members_Id PRIMARY KEY (MemberId),
	CONSTRAINT UK_Fina_Members_MemberIdUserId UNIQUE (MemberId,UserId),
	CONSTRAINT FK_Fina_Members_UserId FOREIGN KEY (UserId) REFERENCES [Sec].[Users](UserId),
	CONSTRAINT FK_Fina_Members_BTSideId FOREIGN KEY (BTSideId) REFERENCES [Stats].[BattingThrowingSides](BTSideId)
)
GO
CREATE TABLE [Stats].[Positions](
	PositionId SMALLINT IDENTITY(1,1),
	KeyValue VARCHAR(3),
	PositionDesc VARCHAR(50),
	CONSTRAINT PK_Stats_Positions_Id PRIMARY KEY (PositionId)
)
GO
INSERT INTO [Stats].[Positions]
	(KeyValue,PositionDesc)
VALUES
	('LF', 'Left Field'),
	('CF', 'Center Field'),
	('RF', 'Right Field'),
	('SHF', 'Short Hitter Field'),
	('3B', '3rd Base'),
	('SS', 'Shortstop'),
	('2B', '2nd Base'),
	('1B', '1st Base'),
	('P', 'Pitcher'),
	('C', 'Catcher')
GO
CREATE TABLE [Stats].[Roster](
	RosterId BIGINT IDENTITY(1,1),
	MemberId BIGINT NOT NULL,
	PositionId SMALLINT NOT NULL,
	CreatedDate DATETIME NOT NULL DEFAULT(GETUTCDATE()),
	CreatedBy BIGINT NOT NULL,
	CONSTRAINT PK_Stats_Roster_Id PRIMARY KEY (RosterId),
	CONSTRAINT UK_Stats_Roster_MemberIdUserId UNIQUE (MemberId,PositionId),
	CONSTRAINT FK_Stats_Roster_PositionId FOREIGN KEY (PositionId) REFERENCES [Stats].[Positions](PositionId),
	CONSTRAINT FK_Stats_Roster_UserId FOREIGN KEY (CreatedBy) REFERENCES [Sec].[Users](UserId)
)
GO
CREATE TABLE [Fina].[PaymentMethods](
	MethodId SMALLINT IDENTITY(1,1),
	MethodDesc VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Fina_PaymentMethods_Id PRIMARY KEY (MethodId)
)
GO
SET IDENTITY_INSERT [Fina].[PaymentMethods] ON; 
INSERT INTO [Fina].[PaymentMethods]
	(MethodId,MethodDesc)
VALUES
	(1,'Transferencia'),
	(2,'Efectivo')	
SET IDENTITY_INSERT [Fina].[PaymentMethods] OFF;
GO
CREATE TABLE [Fina].[ConceptTypes](
	ConceptTypeId SMALLINT IDENTITY(1,1),
	ConceptTypeKey VARCHAR(3) NOT NULL,
	ConceptTypeDesc VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Fina_ConceptTypes_Id PRIMARY KEY (ConceptTypeId),
	CONSTRAINT UQ_Fina_ConceptTypes_Desc UNIQUE (ConceptTypeDesc),
	CONSTRAINT UQ_Fina_ConceptTypes_Key UNIQUE (ConceptTypeKey)
)
GO
SET IDENTITY_INSERT [Fina].[ConceptTypes] ON;
INSERT INTO [Fina].[ConceptTypes]
	(ConceptTypeId,ConceptTypeKey,ConceptTypeDesc)
VALUES
	(1,'ING','Ingreso'),
	(2,'GTO','Gasto')
SET IDENTITY_INSERT [Fina].[ConceptTypes] OFF;
GO
CREATE TABLE [Fina].[Concepts](
	ConceptId SMALLINT IDENTITY(1,1),
	ConceptTypeId SMALLINT NOT NULL,
	ConceptKey VARCHAR(3) NOT NULL,
	ConceptDesc VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Fina_Concepts_Id PRIMARY KEY (ConceptId),
	CONSTRAINT UQ_Fina_Concepts_Type_Key UNIQUE (ConceptTypeId,ConceptKey),
	CONSTRAINT UQ_Fina_Concepts_Type_Desc UNIQUE (ConceptTypeId,ConceptDesc),
	CONSTRAINT FK_Fina_Concepts_ConceptTypeId FOREIGN KEY (ConceptTypeId) REFERENCES [Fina].[ConceptTypes](ConceptTypeId)
)
GO
INSERT INTO [Fina].[Concepts]
	(ConceptTypeId,ConceptKey,ConceptDesc)
VALUES
	(1,'INS','Inscripción'),
	(1,'AMP','Ampayeo'),
	(1,'UNI','Uniformes'),
	(1,'AJT','Ajuste'),
	(2,'HID','Hidratación'),
	(2,'INS','Inscripción'),
	(2,'AMP','Ampayeo'),
	(2,'UNI','Uniformes')
GO
CREATE TABLE [Fina].[Income](
	IncomeId BIGINT IDENTITY(1,1),
	MemberId BIGINT NOT NULL,
	ConceptId SMALLINT NOT NULL,
	MethodId SMALLINT NOT NULL,
    IncomeDate DATETIME NOT NULL,
	Amount DECIMAL(16,2) NOT NULL,
	AdditionalComment VARCHAR(200),
    EvidenceUrl VARCHAR(MAX),
	CreatedDate DATETIME NOT NULL DEFAULT(GETUTCDATE()),
	CreatedBy BIGINT NOT NULL,
	CONSTRAINT PK_Fina_Income_Id PRIMARY KEY (IncomeId),
	CONSTRAINT FK_Fina_Income_MemberId FOREIGN KEY (MemberId) REFERENCES [App].[Members](MemberId),
	CONSTRAINT FK_Fina_Income_ConceptId FOREIGN KEY (ConceptId) REFERENCES [Fina].[Concepts](ConceptId),
	CONSTRAINT FK_Fina_Income_MethodId FOREIGN KEY (MethodId) REFERENCES [Fina].[PaymentMethods](MethodId),
	CONSTRAINT FK_Fina_Income_UserId FOREIGN KEY (CreatedBy) REFERENCES [Sec].[Users](UserId)
)
GO
CREATE TABLE [Fina].[Bills](
	BillId BIGINT IDENTITY(1,1),
	MemberId BIGINT NOT NULL,
	ConceptId SMALLINT NOT NULL,
	MethodId SMALLINT NOT NULL,
    IncomeDate DATETIME NOT NULL,
	Amount DECIMAL(16,2) NOT NULL,
	AdditionalComment VARCHAR(200),
    EvidenceUrl VARCHAR(MAX),
	CreatedDate DATETIME NOT NULL DEFAULT(GETUTCDATE()),
	CreatedBy BIGINT NOT NULL,
	CONSTRAINT PK_Fina_Bills_Id PRIMARY KEY (BillId),
	CONSTRAINT FK_Fina_Bills_MemberId FOREIGN KEY (MemberId) REFERENCES [App].[Members](MemberId),
	CONSTRAINT FK_Fina_Bills_ConceptId FOREIGN KEY (ConceptId) REFERENCES [Fina].[Concepts](ConceptId),
	CONSTRAINT FK_Fina_Bills_MethodId FOREIGN KEY (MethodId) REFERENCES [Fina].[PaymentMethods](MethodId),
	CONSTRAINT FK_Fina_Bills_UserId FOREIGN KEY (CreatedBy) REFERENCES [Sec].[Users](UserId)
)
GO