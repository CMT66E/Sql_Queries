			--1. Current financial year start and end date
			declare @StartDateCurrentFY date 
			declare @EndDateCurrenyFY date

			select @StartDateCurrentFY = dbo.GetFinYearDate(1)
			select @EndDateCurrenyFY = dbo.GetFinYearDate(0)

			--2. Next financial year start and end date
			declare @StartDateNextFY date 
			declare @EndDateNextFY date

			select @StartDateNextFY = dateadd(year, 1, dbo.GetFinYearDate(1))
			select @EndDateNextFY = dateadd(year, 1, dbo.GetFinYearDate(0))
			----------------------------------------------------------------------------
			--3. Counting how many inspections have been done during current fiancial year
			declare @InspectionCountCurrentFY int = 0

			select @InspectionCountCurrentFY = isnull(count(b.InstrumentID), 0) from tblInstrumentNotice a 
			inner join tblNotice b on a.NoticeInstrumentID = b.InstrumentID
			left outer join tblInstrument c on b.InstrumentID = c.InstrumentID
			where 
			a.InstrumentID = 11555
			and 
			b.NoticeTemplateID = 532 
			and c.InstrumentStatusID = 12
			and b.InspectionDate >= @StartDateCurrentFY and b.InspectionDate <= @EndDateCurrenyFY
			order by b.InspectionDate desc

			--4. difference cases check
			declare @TempCurrentYear int
			select @TempCurrentYear = datepart(year, getdate())

			declare @TempLastYear int
			set @TempLastYear = @TempCurrentYear -1

			declare @TempLastNov date
			select @TempLastNov = CONVERT(date, '01/07/' + cast(@TempLastYear as varchar), 103)

			declare @TempCurrentApr date
			select @TempCurrentApr = CONVERT(date, '30/04/' + cast(@TempCurrentYear as varchar), 103)

			declare @TempCurrentNov date
			select @TempCurrentNov = CONVERT(date, '01/07/' + cast(@TempCurrentYear as varchar), 103)

			declare @TempNextApr date
			select @TempNextApr = CONVERT(date, '30/04/' + cast(@TempCurrentYear + 1 as varchar), 103)

			declare @TempNextNov date
			select @TempNextNov = CONVERT(date, '01/07/' + cast(@TempCurrentYear + 1 as varchar), 103)

			--a. If none namely @InspectionCountCurrentFY = 0
			if @InspectionCountCurrentFY = 0
			begin
				if getdate() <= @TempCurrentNov
				begin
						select @TempNextInspectionDueDateLevel3 = @TempCurrentNov
						set @TempDueInMonth = 0			 		
				end    
				if getdate() > @TempCurrentNov
				begin
						select @TempNextInspectionDueDateLevel3 = @TempNextApr
						set @TempDueInMonth = 0			 		
				end    
			end
			--b. If 1 namely @InspectionCountCurrentFY = 1
			if @InspectionCountCurrentFY = 1
			begin
						select @TempNextInspectionDueDateLevel3 = @TempNextApr
						set @TempDueInMonth = 0		   
			end
			--c. If 2 or more namely @InspectionCountCurrentFY >= 2 
			if @InspectionCountCurrentFY >= 2
			begin
						select @TempNextInspectionDueDateLevel3 = @TempNextNov
						set @TempDueInMonth = 0		   
			end
 

exec [dbo].[uspGetPOEORBLInspectionData] 11555