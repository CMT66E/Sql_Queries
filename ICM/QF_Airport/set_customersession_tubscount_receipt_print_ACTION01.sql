Update CustomerSession set NumberOfTubs = 0, IsReceiptPrinted = 1
WHERE        
 (ID % 2) = 1
 and
(UtcCreationTime >= '2019/01/01 00:00:00') AND (UtcCreationTime < '2019/01/5 00:00:00')

Update CustomerSession set NumberOfTubs = 1, IsReceiptPrinted = 1
WHERE        
 (ID % 2) = 1
 and
(UtcCreationTime >= '2019/01/06 00:00:00') AND (UtcCreationTime < '2019/01/15 00:00:00')

Update CustomerSession set NumberOfTubs = 0, IsReceiptPrinted = 0
WHERE        
 (ID % 2) = 0
 and
(UtcCreationTime >= '2019/01/16 00:00:00') AND (UtcCreationTime < '2019/01/20 00:00:00')

Update CustomerSession set NumberOfTubs = 2, IsReceiptPrinted = 1
WHERE        
 (ID % 2) = 1
 and
(UtcCreationTime >= '2019/01/21 00:00:00') AND (UtcCreationTime < '2019/01/24 00:00:00')

Update CustomerSession set NumberOfTubs = 1, IsReceiptPrinted = 0
WHERE        
 (ID % 2) = 1
 and
(UtcCreationTime >= '2019/01/25 00:00:00') AND (UtcCreationTime < '2019/01/31 00:00:00')