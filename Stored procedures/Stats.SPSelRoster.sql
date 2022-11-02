-- =============================================
-- Author:		Baruch Medina
-- Create date: 2022/08/30
-- Description:	Consultar rooster
-- =============================================
CREATE OR ALTER PROCEDURE [Stats].[SPSelRoster]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		R.RosterId
		,M.MemberId
		,M.FullName
		,M.ShirtNumber
		,M.BTSideId
		,BTS.KeyValue BTKeyValue
		,BTS.BTSideDesc
		,M.Birthday
		,P.PositionId
		,P.KeyValue PKeyValue
		,P.PositionDesc
		,CAST(CAST(R.CreatedDate AS DATETIMEOFFSET) AT TIME ZONE 'CENTRAL STANDARD TIME (MEXICO)' AS DATETIME) CreatedDate
		,U.UserName ByUser
		,U.UserId CreatedBy
	FROM
		[Stats].[Roster] R
		INNER JOIN [App].[Members] M
			ON R.MemberId = M.MemberId
		INNER JOIN [Stats].BattingThrowingSides BTS
			ON M.BTSideId = BTS.BTSideId
		INNER JOIN [Stats].Positions P
			ON R.PositionId = P.PositionId
		INNER JOIN [Sec].[Users] U
			ON R.CreatedBy = U.UserId
END
GO