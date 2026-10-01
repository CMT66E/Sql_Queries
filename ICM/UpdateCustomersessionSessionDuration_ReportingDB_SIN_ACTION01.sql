declare @LastID bigint
select @LastID = 10369154

	Declare @leastID Bigint

	Select @leastID = isnull(Min(ID),0) from CustomerSession Where SessionDuration is null

print '@leastID =' + cast(@leastID as varchar)

	IF @leastID <> @LastID
	SET @LastID = @leastID

 

if exists(select TOP 1 C.ID from CustomerSession C Where C.SessionDuration is null)
begin
	UPDATE CustomerSession
	SET SessionDuration = Duration 
	From CustomerSession C
	JOIN( Select SUM(CEILING(Duration)) /1000 as Duration, isnull(CustomerSessionID, 0) as CustomerSessionID  From CustomerSessionTimeOnEachScreen group by isnull(CustomerSessionID, 0)) CT
	ON isnull(CT.CustomerSessionID, 0) = isnull(C.ID, 0)
	Where C.SessionDuration is null
end

	-- to update where  UtcCompletionTime is null 
	UPDATE CustomerSession
	SET SessionDuration = 0
	Where UtcCompletionTime  IS NULL AND isnull(ID, 0) >= @LastID AND   SessionDuration is null

	-- to update where no record in  CustomerSessionTimeOnEachScreen 

	UPDATE CustomerSession
	SET SessionDuration =  Cast(Datediff(ms,UtcCreationTime,UtcCompletionTime)/1000.00 as decimal(10,2))
	Where UtcCompletionTime  IS NOT  NULL AND  SessionDuration is null AND  isnull(ID, 0) >= @LastID