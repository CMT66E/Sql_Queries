DECLARE @test TABLE
(
  temp xml 
)
insert into @test values
('
<ROOT>
  <Customer>
    <Order>Order 1</Order>
  </Customer>
  <Customer>
    <Order>Order 2</Order>
  </Customer>
</ROOT>');


select * from @test

SELECT temp.value('(ROOT/Customer/Order)[1]', 'varchar(100)')
FROM   @test;
 

delete @test
