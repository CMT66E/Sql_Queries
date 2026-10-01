USE CUSSReportingDB_CDG
GO
declare	@FromDate DateTime = '2022-09-01 00:00:00 AM'
declare	@ToDate DateTime = '2022-09-30 11:59:59 PM'

--Date: 19-08-2022 The following lines have been added as CDG is complaining the report AvailabilityMonthly_AF was creating two months old report instead of previous month
--after checking the application binary code we can see it minus 2 months then calling this SP. So we add 1 month to both @FromDate and @ToDate to fix this problem
--start adding line
if @FromDate <> ''
   SET @FromDate =  DATEADD(MONTH, 1, @FromDate)  --add one more month from current @FromDate value

if @ToDate <> ''
begin
   SET @ToDate =  DATEADD(MONTH, 1, @ToDate)      --add one more month from current @ToDate value 
   SELECT @ToDate = DATEADD(dd, -DAY(DATEADD(mm, 1, @ToDate)), DATEADD(mm, 1, @ToDate))
   --SELECT @ToDate = cast(cast(cast(EOMONTH(@ToDate) as date) as varchar(50)) + ' 11:59:59 PM' as datetime)  --after sql 2012 can use left function call
end
--end adding line


SELECT     ABDAvailability.Date,dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType) AS AbdStationName,
	TimeSlotHourly.TimeSlotName,	ABDStates.State,   ABDAvailability.MinutesInState
FROM         ABDAvailability INNER JOIN
          ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
          StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
          TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
          AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID
WHERE     (ABDAvailability.Date BETWEEN @FromDate AND @ToDate)
AND AbdStation.ID In(
--CDG2E-Z03-DBA01...12-------
268,
194,
198,
193,
197,
190,
196,
192,
195,
191,
267,
271,
----CDG2E-Z04-DBA07...12--
321,
263,
264,
279,
265,
266,
-----CDG2E-Z05-DBA01...13---
270,
183,
178,
169,
179,
180,
171,
182,
173,
170,
185,
184,
269,

--CDG2F-Z05-DBA02...13---

189,
174,
168,
199,
181,
175,
176,
186,
188,
172,
177,
187,

--CDG2F-Z06-DBA02...13--
290,
291,
287,
296,
295,
289,
288,
292,
220,
293,
286,
294,

-- CDG2G-Z01-DBA03...05--
204,
208,
209,

---ORYS-H2A-DBA01...06

249,
250,
251,
252,
253,
254,

--ORYS-H2B-DBA07...12

255,
256,
257,
259,
258,
248,

----ORYS-H2C-DBA16...21

274,
272,
273,
275,
278,
276,


---ORYS-H3B-DBA03...12 and 14

319,
328,
320,
330,
318,
312,
329,
313,
310,
308,
303,

----  CDG2E-Z10 and CDG2E-Z11
799,
852,
853,
854,
855,
856,
857,
858,
859,
860,
861,
862,
863,
864,
865,
866,
867,
868,
869,
870,
871,
872

)
OR  --before add this 506,466 records after 18528948 records
(
  (AREA in ('Z06', 'Z08', 'Z09') and PortCode = 'CDG' and Terminal = '2E') OR
  (AREA in ('Z32', 'Z33', 'Z34','Z35') and PortCode = 'ORY' and Terminal = '3') OR
  (AREA in ('Z02') and PortCode = 'CDG' and Terminal = '2F')
)
ORDER BY ABDAvailability.Date,dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType), TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName,
	ABDStates.State
RETURN