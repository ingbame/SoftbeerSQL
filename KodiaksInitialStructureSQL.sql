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
	RoleDescription VARCHAR(60) NOT NULL,
	CONSTRAINT PK_App_Roles_Id PRIMARY KEY (RoleId),
	CONSTRAINT UQ_App_Roles_RoleDescription UNIQUE (RoleDescription)
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
	ItemKey VARCHAR(15) NOT NULL,
	IconSource VARCHAR(100) NULL
	CONSTRAINT PK_App_MenuItems_Id PRIMARY KEY (MenuItemId),
	CONSTRAINT UQ_App_MenuItems_ItemKey UNIQUE (ItemKey)
)
GO
SET IDENTITY_INSERT [App].[MenuItems] ON; 
INSERT INTO [App].[MenuItems]
	(MenuItemId,ItemKey,IconSource)
VALUES
	(1,'Home', 'fa-solid fa-house'),
	(2,'Roles', 'fa-solid fa-shield-halved'),
	(3,'Menu', 'fa-regular fa-sitemap'),
	(4,'Members', 'fa-regular fa-users'),
	(5,'Stats', 'fa-solid fa-baseball-bat-ball'),
	(6,'Positions', 'fa-regular fa-location-dot'),
	(7,'Roster', 'fa-regular fa-clipboard-user'),
	(8,'Concepts', 'fa-solid fa-file-invoice'),
	(9,'Movements', 'fa-solid fa-money-bill-transfer'),
	(10,'Dashboard', 'fa-solid fa-money-bill-trend-up')
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
CREATE CLUSTERED INDEX IX_App_AssignRoleMenu_RoleId_MenuItemId ON [App].[AssignRoleMenu](RoleId ASC, MenuItemId ASC)
GO
INSERT INTO [App].[AssignRoleMenu]
	(RoleId,MenuItemId)
VALUES
	(1,1),
	(1,2),
	(1,3),
	(1,4),
	(1,5),
	(1,6),
	(1,7),
	(1,8),
	(1,9),
	(1,10),
	(2,1),
	(2,4),
	(2,5),
	(2,6),
	(2,7),
	(2,9),
	(2,10),
	(3,1),
	(3,5),
	(3,7),
	(3,10)
GO
CREATE TABLE [Sec].[Users](
	UserId BIGINT IDENTITY(1,1),
	UserName VARCHAR(50) NOT NULL,
	[Password] VARCHAR(MAX) NOT NULL,
	[PasswordSalt] VARCHAR(MAX) NOT NULL,
	RoleId INT NOT NULL,
	CanEdit BIT NOT NULL DEFAULT(0),
	SavePasswords BIT NOT NULL DEFAULT(0),
	IsVerified BIT NOT NULL DEFAULT(0),
	IsActive BIT NOT NULL DEFAULT(1),
	CreatedDate DATETIME NOT NULL DEFAULT (GETUTCDATE()),
	CONSTRAINT PK_Sec_Users_Id PRIMARY KEY (UserId),
	CONSTRAINT PK_Sec_Users_UserName UNIQUE (UserName),
	CONSTRAINT FK_Sec_Users_RolId FOREIGN KEY (RoleId) REFERENCES [App].[Roles](RoleId)
)
GO
INSERT INTO [Sec].[Users]
	(UserName, [Password], [PasswordSalt], RoleId, CanEdit,	IsActive)
VALUES
	('8116836441','lwkTti5oNvMw9vm2uECxNNdHDC7PX5UQ81L88DTinh8=','0OkeXSNNyZqau6DFPuh9Cg==',1,1,1)
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
	PhotoUrl VARCHAR(MAX) NULL,
	Birthday DATE NULL,
	Email VARCHAR(50) NULL,
	CellPhoneNumber VARCHAR(15) NOT NULL,
	CONSTRAINT PK_Fina_Members_Id PRIMARY KEY (MemberId),
	CONSTRAINT UQ_Fina_Members_MemberIdUserId UNIQUE (MemberId,UserId),
	CONSTRAINT UQ_Fina_Members_CellPhoneNumber UNIQUE (CellPhoneNumber),
	CONSTRAINT FK_Fina_Members_UserId FOREIGN KEY (UserId) REFERENCES [Sec].[Users](UserId),
	CONSTRAINT FK_Fina_Members_BTSideId FOREIGN KEY (BTSideId) REFERENCES [Stats].[BattingThrowingSides](BTSideId)
)
GO
INSERT INTO [App].[Members] 
	(UserId, FullName, NickName, ShirtNumber, BTSideId, PhotoUrl, Birthday, Email, CellPhoneNumber)
VALUES 
	(1, 'Baruch Iván Medina Ramos', 'Baruch Medina', 26, 3, NULL, '1990-12-26', 'ingbame@gmail.com', '+528116836441')
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
	('P', 'Pitcher'),
	('C', 'Catcher'),
	('1B', '1st Base'),
	('2B', '2nd Base'),
	('SS', 'Shortstop'),
	('3B', '3rd Base'),
	('LF', 'Left Field'),
	('CF', 'Center Field'),
	('RF', 'Right Field'),
	('SHF', 'Short Hitter Field')
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
CREATE TABLE [Fina].[Concepts](
	ConceptId SMALLINT IDENTITY(1,1),
	ConceptKey VARCHAR(3) NOT NULL,
	ConceptDesc VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Fina_Concepts_Id PRIMARY KEY (ConceptId),
	CONSTRAINT UQ_Fina_Concepts_Type_Key UNIQUE (ConceptKey),
	CONSTRAINT UQ_Fina_Concepts_Type_Desc UNIQUE (ConceptDesc)
)
GO
INSERT INTO [Fina].[Concepts]
	(ConceptKey,ConceptDesc)
VALUES
	('INS','Inscripción'),
	('AMP','Ampayeo'),
	('UNI','Uniformes'),
	('AJT','Ajuste'),
	('HID','Hidratación')
GO
CREATE TABLE [Fina].[MovementTypes](
	MovementTypeId SMALLINT IDENTITY(1,1),
	MovementTypeKey VARCHAR(3) NOT NULL,
	MovementTypeDesc VARCHAR(50) NOT NULL,
	CONSTRAINT PK_MovementTypes_ConceptTypes_Id PRIMARY KEY (MovementTypeId),
	CONSTRAINT UQ_MovementTypes_ConceptTypes_Desc UNIQUE (MovementTypeKey),
	CONSTRAINT UQ_MovementTypes_ConceptTypes_Key UNIQUE (MovementTypeDesc)
)
GO
SET IDENTITY_INSERT [Fina].[MovementTypes] ON;
INSERT INTO [Fina].[MovementTypes]
	(MovementTypeId,MovementTypeKey,MovementTypeDesc)
VALUES
	(1,'ING','Ingreso'),
	(2,'GTO','Gasto')
SET IDENTITY_INSERT [Fina].[MovementTypes] OFF;
GO
CREATE TABLE [Fina].[Movements](
	MovementId BIGINT IDENTITY(1,1),
	MemberId BIGINT NOT NULL,
	MovementTypeId SMALLINT NOT NULL,
	ConceptId SMALLINT NOT NULL,
	MethodId SMALLINT NOT NULL,
    MovementDate DATE NOT NULL,
	Amount DECIMAL(16,2) NOT NULL,
	AdditionalComment VARCHAR(200),
    EvidenceUrl VARCHAR(MAX),
	CreatedDate DATETIME NOT NULL DEFAULT(GETUTCDATE()),
	CreatedBy BIGINT NOT NULL,
	CONSTRAINT PK_Fina_Movements_Id PRIMARY KEY (MovementId),
	CONSTRAINT FK_Fina_Movements_MemberId FOREIGN KEY (MemberId) REFERENCES [App].[Members](MemberId),
	CONSTRAINT FK_Fina_Movements_MovementTypeId FOREIGN KEY (MovementTypeId) REFERENCES [Fina].[MovementTypes](MovementTypeId),
	CONSTRAINT FK_Fina_Movements_ConceptId FOREIGN KEY (ConceptId) REFERENCES [Fina].[Concepts](ConceptId),
	CONSTRAINT FK_Fina_Movements_MethodId FOREIGN KEY (MethodId) REFERENCES [Fina].[PaymentMethods](MethodId),
	CONSTRAINT FK_Fina_Movements_UserId FOREIGN KEY (CreatedBy) REFERENCES [Sec].[Users](UserId)
)
GO
-- =============================================
-- Author:		Baruch Medina
-- Create date: 2022/08/30
-- Description:	Creación inicial de seleccion de los ingresos por id
-- =============================================
CREATE PROCEDURE [Fina].[SPSelMovements]
	@MovementId BIGINT = NULL,
	@Year INT = NULL,
	@Month INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		MOV.MovementId
		, MOV.MemberId
		, M.FullName
		, MOV.ConceptId
		, C.ConceptKey
		, C.ConceptDesc
		, MT.MovementTypeId
		, MT.MovementTypeKey
		, MT.MovementTypeDesc
		, MOV.MethodId
		, PM.MethodDesc
		, MOV.MovementDate
		, MOV.Amount
		, MOV.AdditionalComment
		, MOV.EvidenceUrl
		, CAST(CAST(MOV.CreatedDate AS DATETIMEOFFSET) AT TIME ZONE 'CENTRAL STANDARD TIME (MEXICO)' AS DATETIME) CreatedDate
		, MOV.CreatedBy CreatedById
		, MU.NickName CreatedBy
	FROM
		[Fina].[Movements] MOV
		INNER JOIN [App].Members M
			ON MOV.MemberId = M.MemberId
		INNER JOIN [Fina].Concepts C
			ON MOV.ConceptId = C.ConceptId
		INNER JOIN [Fina].[MovementTypes] MT
			ON MOV.MovementTypeId = MT.MovementTypeId
		INNER JOIN [Fina].PaymentMethods PM
			ON MOV.MethodId = PM.MethodId
		INNER JOIN [Sec].Users U
			ON MOV.CreatedBy = U.UserId
		INNER JOIN [App].Members MU
			ON U.UserId = MU.UserId
	WHERE
		MOV.MovementId = COALESCE(@MovementId,MOV.MovementId)
		AND YEAR(MOV.MovementDate) = COALESCE(@Year, YEAR(MOV.MovementDate))
		AND MONTH(MOV.MovementDate) = COALESCE(@Month, MONTH(MOV.MovementDate))
END
GO
-- =============================================
-- Author:		Baruch Medina
-- Create date: 2022/10/10
-- Description:	Consulta de movimientos por mes y anio
-- =============================================
CREATE PROCEDURE [Fina].[SPSelMovementsByMonthYear]
	@Year INT = NULL,
	@Month INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		MT.MovementTypeId
		, MT.MovementTypeKey
		, MT.MovementTypeDesc
		, CONVERT(VARCHAR, MOV.MovementDate, 103) MovementDate
		, SUM(MOV.Amount) Amount
	FROM
		[Fina].[Movements] MOV
		INNER JOIN [Fina].[MovementTypes] MT
			ON MOV.MovementTypeId = MT.MovementTypeId
	WHERE		
		YEAR(MOV.MovementDate) = COALESCE(@Year,YEAR(MOV.MovementDate))
		AND MONTH(MOV.MovementDate) = COALESCE(@Month,MONTH(MOV.MovementDate))
	GROUP BY
		MOV.MovementDate,MT.MovementTypeId,MT.MovementTypeKey,MT.MovementTypeDesc
	ORDER BY
		MOV.MovementDate ASC
END
GO
-- =============================================
-- Author:		Baruch Medina
-- Create date: 2022/08/30
-- Description:	Creación inicial de seleccion de los miembros por id
-- =============================================
CREATE PROCEDURE [App].[SPSelMembers]
	@MemberId BIGINT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		M.MemberId
		,M.UserId
		,U.RoleId
		,R.RoleDescription RoleDesc
		,M.FullName
		,M.NickName
		,M.ShirtNumber
		,M.BTSideId
		,BTS.BTSideDesc
		,M.PhotoUrl
		,M.Birthday
		,M.Email
		,M.CellPhoneNumber
		,U.CanEdit
		,U.IsVerified
		,U.IsActive
		,CAST(CAST(U.CreatedDate AS DATETIMEOFFSET) AT TIME ZONE 'CENTRAL STANDARD TIME (MEXICO)' AS DATETIME) CreatedDate
	FROM
		[App].[Members] M
		INNER JOIN [Sec].[Users] U
			ON M.UserId = U.UserId
		INNER JOIN [App].[Roles] R
			ON U.RoleId = R.RoleId
		INNER JOIN [Stats].BattingThrowingSides BTS
			ON M.BTSideId = BTS.BTSideId
	WHERE
		M.MemberId = COALESCE(@MemberId,M.MemberId)
END
GO