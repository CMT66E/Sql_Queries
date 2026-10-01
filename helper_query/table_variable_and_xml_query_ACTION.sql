DECLARE @test TABLE
(
  temp xml 
)
insert into @test values
('
<Envelope>
	<Header>
		<Action>http://webservices.amadeus.com/1ASIWICMSQ/CCPRRQ_12_1_1A</Action>
		<Session>
			<SessionId>01JHUYLW09</SessionId>
			<SequenceNumber>9</SequenceNumber>
			<SecurityToken>MA9SR1Z0IJG63AQSYYDGFG8TO</SecurityToken>
		</Session>
	</Header>
	<Body>
		<DCSIDC_CPRIdentification>
			<setOfCriteria>
				<travelCriteria>
					<carrierDetails>
						<marketingCarrier>SQ</marketingCarrier>
					</carrierDetails>
					<flightDetails>
						<flightNumber>248</flightNumber>
					</flightDetails>
					<departureDate>20190604</departureDate>
					<boardPoint>WLG</boardPoint>
					<offPoint>SIN</offPoint>
				</travelCriteria>
				<securityNumber>
					<referenceDetails>
						<type>4</type>
						<value>WLG-007</value>
					</referenceDetails>
				</securityNumber>
			</setOfCriteria>
		</DCSIDC_CPRIdentification>
	</Body>
   </Envelope>');


select * from @test

SELECT temp.value('(/Envelope/Body/DCSIDC_CPRIdentification/setOfCriteria/travelCriteria/flightDetails/flightNumber)[1]', 'varchar(100)')
FROM   @test;
 

delete @test