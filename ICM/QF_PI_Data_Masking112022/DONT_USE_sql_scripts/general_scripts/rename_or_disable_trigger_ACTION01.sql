
INSERT INTO [dbo].[employee] select 100, 'James Bond', 'Spy Trainer', '2019-06-26', 230000
INSERT INTO [dbo].[employee] select 101, 'Janet Lee', 'Office Admin', '2015-01-12', 100000
INSERT INTO [dbo].[employee] select 102, 'Wang Ming', 'Goal Keeper', '2014-09-09', 130000
INSERT INTO [dbo].[employee] select 103, 'John Smith', 'Director', '2017-10-12', 120000


--exec sp_rename 'trigger_employee', 'trig_employee_after_insert';

ALTER TABLE employee DISABLE TRIGGER [trigger_passportinfo_insert_DocumentNumber]
ALTER TABLE employee ENABLE TRIGGER [trigger_passportinfo_insert_DocumentNumber]

--delete from employee
--delete from employee_backup