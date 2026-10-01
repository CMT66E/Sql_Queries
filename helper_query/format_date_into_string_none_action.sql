1  select convert(varchar, getdate(), 1)  12/30/06  
2  select convert(varchar, getdate(), 2)  06.12.30  
3  select convert(varchar, getdate(), 3)  30/12/06  
4  select convert(varchar, getdate(), 4)  30.12.06  
5  select convert(varchar, getdate(), 5)  30-12-06  
6  select convert(varchar, getdate(), 6)  30 Dec 06  
7  select convert(varchar, getdate(), 7)  Dec 30, 06  
10  select convert(varchar, getdate(), 10)  12-30-06  
11  select convert(varchar, getdate(), 11)  06/12/30  
12  select convert(varchar, getdate(), 12)  061230  
23  select convert(varchar, getdate(), 23)  2006-12-30 
101  select convert(varchar, getdate(), 101)  12/30/2006  
102  select convert(varchar, getdate(), 102)  2006.12.30  
103  select convert(varchar, getdate(), 103)  30/12/2006  
104  select convert(varchar, getdate(), 104)  30.12.2006  
105  select convert(varchar, getdate(), 105)  30-12-2006  
106  select convert(varchar, getdate(), 106)  30 Dec 2006  
107  select convert(varchar, getdate(), 107)  Dec 30, 2006  
110  select convert(varchar, getdate(), 110)  12-30-2006  
111  select convert(varchar, getdate(), 111)  2006/12/30  
112  select convert(varchar, getdate(), 112)  20061230 
   
TIME ONLY FORMATS 
8  select convert(varchar, getdate(), 8)  00:38:54  
14 select convert(varchar, getdate(), 14)  00:38:54:840  
24 select convert(varchar, getdate(), 24)  00:38:54 
108  select convert(varchar, getdate(), 108)  00:38:54  
114 select convert(varchar, getdate(), 114)  00:38:54:840 
   
DATE & TIME FORMATS 
0  select convert(varchar, getdate(), 0)  Dec 12 2006 12:38AM  
9 select convert(varchar, getdate(), 9)  Dec 30 2006 12:38:54:840AM  
13  select convert(varchar, getdate(), 13)  30 Dec 2006 00:38:54:840AM  
20  select convert(varchar, getdate(), 20)  2006-12-30 00:38:54 
21  select convert(varchar, getdate(), 21)  2006-12-30 00:38:54.840 
22  select convert(varchar, getdate(), 22)  12/30/06 12:38:54 AM 
25 select convert(varchar, getdate(), 25)  2006-12-30 00:38:54.840 
100 select convert(varchar, getdate(), 100)  Dec 30 2006 12:38AM 
109  select convert(varchar, getdate(), 109)  Dec 30 2006 12:38:54:840AM  
113 select convert(varchar, getdate(), 113)  30 Dec 2006 00:38:54:840 
120 select convert(varchar, getdate(), 120)  2006-12-30 00:38:54 
121 select convert(varchar, getdate(), 121)  2006-12-30 00:38:54.840 
126 select convert(varchar, getdate(), 126)  2006-12-30T00:38:54.840 
127 select convert(varchar, getdate(), 127)  2006-12-30T00:38:54.840 
   
ISLAMIC CALENDAR DATES 
130 select convert(nvarchar, getdate(), 130)  date output 
131 select convert(nvarchar, getdate(), 131)  10/12/1427 12:38:54:840AM 
