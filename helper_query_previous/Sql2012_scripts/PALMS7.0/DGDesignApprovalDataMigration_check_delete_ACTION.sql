/****** Script for SelectTopNRows command from SSMS  ******/
declare @newInstrumentID int

-- USE PROCEDURE AS GIVEN BY ERIC -----------------
/* *********************************************** */
Declare @NewNumber        int
Declare @StartNumber      int
Declare @EndNumber        int            
Declare @CurrentNumber    int
Declare @InstrumentID    int
                           
Select	@StartNumber = isNull(PALMSNewNumber,0),
		@EndNumber   = isNull(EndNumber,0)   
        From dbo.tblInstrumentNumber WITH (TABLOCKX)
        Where InstrumentTypeID = 990  --DG Tank Design Approval licence type
        and EffectiveDateTo is null

--FOR DG Design Approval
--StartNumber: 5000000
--EndNumber  : 5999999

Select @CurrentNumber = isNull(MAX(InstrumentID),@StartNumber - 1) 
From dbo.tblInstrument 
        Where 
        (InstrumentTypeID=750 or  InstrumentTypeID= 817 or  InstrumentTypeID= 818  or  InstrumentTypeID= 990)
        and InstrumentID Between @StartNumber and @EndNumber 
--@CurrentNumber could be: 5066889 already existing in table: tblInstrument

If ( @CurrentNumber = 0  OR @CurrentNumber < @EndNumber ) Begin                
    Set @NewNumber  = @CurrentNumber + 1 
End
--@NewNumber could be: 5066889 + 1 = 5066890
			  

--print '@CurrentNumber=' + cast(@CurrentNumber as varchar)
If (@NewNumber is null or @NewNumber = 0 or exists(Select * From tblInstrument where InstrumentID = @NewNumber )) 
        Begin
        declare @errMsg varchar(100)
        set @errMsg = 'Error generating newInstrumentID for type = %d' + ' there is ' + cast(@NewNumber as varchar(10))                   
        RAISERROR (@errMsg, 16, 1, 990) 
        End 
/* *********************************************** */

set @newInstrumentID = @NewNumber
print '@newInstrumentID=' + cast(@newInstrumentID as varchar) 

--delete from tblDGDesignApprovalVehicleMake where  InstrumentID > @newInstrumentID  
--delete from tblDGDesignApprovalTankMake where InstrumentID > @newInstrumentID
--delete from tblInstrumentContact where InstrumentID > @newInstrumentID
--delete from tblContact where [ROW_ID] >= 100000
--delete from tblInstrumentAccountableParty where InstrumentID > @newInstrumentID
--delete from tblAccountableParty where [ROW_ID] is NOT null
--delete from tblAddress where [ROW_ID] is NOT null
--delete from tblDGDesignApprovalClassUN where InstrumentID > @newInstrumentID
--delete from tblDGDesignApproval where [ROW_ID] is NOT null
--delete from tblInstrument where [ROW_ID] is NOT null

--update [tblInstrument] set [ROW_ID] = null
--update [tblDGDesignApproval] set [ROW_ID] = null
--delete from tblDGDesignApprovalClassUN where InstrumentID > 5066890
--update [tblAddress] set [ROW_ID] = null
--update [tblAccountableParty] set [ROW_ID] = null
--update tblInstrumentAccountableParty set [ROW_ID] = null
--update [tblContact] set [ROW_ID] = null
--update [tblInstrumentContact] set [ROW_ID] = null
--delete FROM [tblInstrumentContact] WHERE  InstrumentID > 5066890


SELECT COUNT(*)
FROM [tblInstrument]
WHERE datepart(day, DateCreated) = 22 and datepart(month, DateCreated) = 10 and datepart(year, DateCreated) = 2015

SELECT COUNT(*) FROM tblDGDesignApproval
WHERE datepart(day, DateCreated) = 22 and datepart(month, DateCreated) = 10 and datepart(year, DateCreated) = 2015

SELECT COUNT(*) FROM tblDGDesignApprovalClassUN 
WHERE datepart(day, DateCreated) = 22 and datepart(month, DateCreated) = 10 and datepart(year, DateCreated) = 2015

SELECT COUNT(*)
FROM [tblAddress]
WHERE datepart(day, DateCreated) = 22 and datepart(month, DateCreated) = 10 and datepart(year, DateCreated) = 2015

SELECT COUNT(*)
FROM [tblAccountableParty]
WHERE datepart(day, DateCreated) = 22 and datepart(month, DateCreated) = 10 and datepart(year, DateCreated) = 2015

SELECT COUNT(*)
FROM [tblInstrumentAccountableParty]
WHERE datepart(day, DateCreated) = 22 and datepart(month, DateCreated) = 10 and datepart(year, DateCreated) = 2015

SELECT COUNT(*)
FROM [tblContact]
WHERE datepart(day, DateCreated) = 22 and datepart(month, DateCreated) = 10 and datepart(year, DateCreated) = 2015

SELECT COUNT(*)
FROM [tblInstrumentContact]
WHERE datepart(day, DateCreated) = 22 and datepart(month, DateCreated) = 10 and datepart(year, DateCreated) = 2015

SELECT COUNT(*)
FROM tblDGDesignApprovalTankMake
WHERE datepart(day, DateCreated) = 22 and datepart(month, DateCreated) = 10 and datepart(year, DateCreated) = 2015

SELECT COUNT(*)
FROM tblDGDesignApprovalVehicleMake
WHERE datepart(day, DateCreated) = 22 and datepart(month, DateCreated) = 10 and datepart(year, DateCreated) = 2015


  --      declare @newAddressID int
		--select @newAddressID = addressID from tblAddress a
	 --   where ROW_ID = '1234' -- ID from source Excel

		--select dm_a.Row_ID, a.AddressID
		--from tblAddress a
		--	inner join  dbo.dm_tblAddress dm_a on a.row_ID = cast(dm_a.addressID as varchar)
		--where a.addressID >= @newAddressID


		--UPDATE dm_a
		--	SET dm_a.Row_ID  = a.AddressID
		--from tblAddress a
		--	inner join  dbo.dm_tblAddress dm_a on a.row_ID = cast(dm_a.addressID as varchar)
		--where a.addressID >= @newAddressID

		--select * from dbo.tblAccountableParty WHERE [ROW_ID]  is not null
		--update tblAccountableParty set [ROW_ID] = null

		--declare @newContactID int
	 --   select @newContactID = ContactID from [tblContact] where row_id = '100000'
		--	IF (@newContactID is null or @newContactID = 0 or not exists(Select * From [tblContact] where ContactID = @newContactID )) BEGIN
		--			RAISERROR ('Error obtaining newContactID',
		--				16, -- Severity.
		--				1 -- State.
		--			)
		--	END

		--UPDATE dm_c
		--	SET dm_c.Row_ID  = c.ContactID
		--from tblContact c
		--	inner join  dm_tblContact dm_c  on c.row_ID = cast(dm_c.ContactID as varchar)
		--where c.ContactID >= @newContactID 