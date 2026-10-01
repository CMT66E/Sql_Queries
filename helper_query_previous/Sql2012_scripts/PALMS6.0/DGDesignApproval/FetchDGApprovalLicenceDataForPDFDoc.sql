select 
 a.InstrumentID
,a.NoticeInstrumentID 
,[dbo].[ufn_GetDGApprovalTankMakerByInstrumentID](a.InstrumentID) as TankManufacturer
,[dbo].[ufn_GetDGApprovalVehicleMakerByInstrumentID](a.InstrumentID) as VehicleManufacturer
,[dbo].[ufn_GetDGApprovalClassUNNumberByInstrumentID](a.InstrumentID, 'class') as DGClasss
,[dbo].[ufn_GetDGApprovalClassUNNumberByInstrumentID](a.InstrumentID, 'number') as DGUNNumbers
,d.TankerTypeID
,e.[description] as TankerTypeText
,d.Capacity
,isnull(d.VINNumber, 'n/a') as VINNumber
,isnull(d.TankSerialNumber, 'n/a') as TankSerialNumber
from tblInstrumentNotice a 
inner join tblNotice b on a.NoticeInstrumentID = b.InstrumentID 
inner join tblInstrument c on b.InstrumentID = c.InstrumentID
inner join tblDGDesignApproval d on a.InstrumentID = d.InstrumentID
inner join tblClassification e on d.TankerTypeID = e.ClassificationID 
where a.NoticeInstrumentID = 1531378


select z.*, y.DGTankMake 
from tblDGDesignApprovalTankMake z
inner join tblDGTankMake y on z.DGTankMakeID = y.DGTankMakeID
where z.InstrumentID = 5065605 order by y.SequenceOrder 

select [dbo].[ufn_GetDGApprovalTankMakerByInstrumentID](5065605) as TankMakers

select b.DGVehicleMake from tblDGDesignApprovalVehicleMake a inner join tblDGVehicleMake b on a.DGVehicleMakeID = b.DGVehicleMakeID
where a.InstrumentID = 5065605
