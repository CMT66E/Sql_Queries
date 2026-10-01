create table tblAbc (id varchar(10)  primary key)

select object_name(object_id),* from sys.key_constraints where object_name(parent_object_id) = 'tblAbc'

ALTER TABLE tblAbc
DROP CONSTRAINT PK__tblAbc__3213E83F0C400F61

ALTER TABLE tblAbc alter column id varchar(20) NOT NULL;


ALTER TABLE tblAbc 
ADD CONSTRAINT MyPrimaryKey PRIMARY KEY (id)