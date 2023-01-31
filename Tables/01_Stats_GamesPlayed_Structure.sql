CREATE TABLE [Stats].[RivalTeam](
	RivalTeamId INT IDENTITY(1,1) NOT NULL,
	TeamName VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL DEFAULT(1),
	CONSTRAINT PK_Stats_RivalTeam_RivalTeamId PRIMARY KEY (RivalTeamId)
)
GO
CREATE TABLE [Stats].[OpposingTeamMembers](
	MemberId INT IDENTITY(1,1) NOT NULL,
	MemberName VARCHAR(100) NOT NULL,
	IsPitcher BIT NOT NULL DEFAULT(0),
	CONSTRAINT PK_Stats_OpposingTeamMembers_MemberId PRIMARY KEY (MemberId)
)
GO
CREATE TABLE [Stats].[GamesPlayed](
	GameId INT IDENTITY(1,1) NOT NULL,
	RivalTeamId INT NOT NULL,
	[Date] DATE NOT NULL,
	WeWON BIT NOT NULL,
	CONSTRAINT PK_Stats_GamesPlayed_GameId PRIMARY KEY (GameId),
	CONSTRAINT FK_Stats_GamesPlayed_RivalTeamId FOREIGN KEY (RivalTeamId) REFERENCES [Stats].[RivalTeam] (RivalTeamId),
	CONSTRAINT UK_Stats_GamesPlayed_RivalTeamId_Date UNIQUE (RivalTeamId, [Date])
)
GO
CREATE TABLE [Stats].[DetailOfOurGamePlayed](
	OurDetailId BIGINT IDENTITY(1,1) NOT NULL,
	PositionAtBat INT NOT NULL,
	Inning INT NOT NULL,
	MemberId BIGINT NOT NULL,
	IsRun BIT NOT NULL,
	IsHit BIT NOT NULL,
	IsDouble BIT NOT NULL,
	IsTriple BIT NOT NULL,
	IsHomeRun BIT NOT NULL,
	RunsBattedIn INT NOT NULL,
	Walks BIT NOT NULL,
	StikeOut BIT NOT NULL,
	StolenBases INT NOT NULL,
	CaughtStealing INT NOT NULL,
	IsOut BIT NOT NULL,
	OutValue INT NULL,
	OutSector INT NULL,
	CenterValue VARCHAR(4) NULL,
	CONSTRAINT PK_Stats_DetailOfOurGamePlayed_GameId PRIMARY KEY (OurDetailId),
	CONSTRAINT FK_Stats_DetailOfOurGamePlayed_MemberId FOREIGN KEY (MemberId) REFERENCES [App].[Members](MemberId),
	CONSTRAINT PK_Stats_DetailOfOurGamePlayed_Inning_MemberId UNIQUE (Inning, MemberId)
)
GO
CREATE TABLE [Stats].[DetailOfTheRivalGamePlayed](
	RivalDetailId BIGINT IDENTITY(1,1) NOT NULL,
	PositionAtBat INT NOT NULL,
	Inning INT NOT NULL,
	MemberId INT NOT NULL,
	IsRun BIT NOT NULL,
	IsHit BIT NOT NULL,
	IsDouble BIT NOT NULL,
	IsTriple BIT NOT NULL,
	IsHomeRun BIT NOT NULL,
	RunsBattedIn INT NOT NULL,
	Walks BIT NOT NULL,
	StikeOut BIT NOT NULL,
	StolenBases INT NOT NULL,
	CaughtStealing INT NOT NULL,
	IsOut BIT NOT NULL,
	OutValue INT NULL,
	OutSector INT NULL,
	CenterValue VARCHAR(4) NULL,
	CONSTRAINT PK_Stats_DetailOfTheRivalGamePlayed_GameId PRIMARY KEY (RivalDetailId),
	CONSTRAINT FK_Stats_DetailOfTheRivalGamePlayed_MemberId FOREIGN KEY (MemberId) REFERENCES [Stats].[OpposingTeamMembers](MemberId),
	CONSTRAINT PK_Stats_DetailOfTheRivalGamePlayed_Inning_MemberId UNIQUE (Inning, MemberId)
)
GO