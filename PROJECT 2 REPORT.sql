USE [SkyBarrelBank_UAT];

--REPORT 1A
 
SELECT A.[BorrowerID], 
       ((A.[BorrowerFirstName]) + ' ' + (A.[BorrowerMiddleInitial]) + ' ' + (A.[BorrowerLastName])) AS BORROWERNAME, 
       SSN = RIGHT(A.[TaxPayerID_SSN], 4), 
       YEAROFPURCHASE = YEAR(B.[PurchaseDate]), 
       [PURCHASEAMOUNT(IN THOUSANDS)] = FORMAT(B.[PURCHASEAMOUNT] / 1000, 'C0') + 'K'
FROM [dbo].[Borrower] AS A
     INNER JOIN [dbo].[LoanSetupInformation] AS B ON A.[BorrowerID] = B.[BorrowerID];

--REPORT 1B
SELECT A.[BorrowerID], 
       ((A.[BorrowerFirstName]) + ' ' + (A.[BorrowerMiddleInitial]) + ' ' + (A.[BorrowerLastName])) AS BORROWERNAME, 
       SSN = RIGHT(A.[TaxPayerID_SSN], 4), 
       YEAROFPURCHASE = YEAR(B.[PurchaseDate]), 
       [PURCHASEAMOUNT(IN THOUSANDS)] = FORMAT(B.[PURCHASEAMOUNT] / 1000, 'C0') + 'K'
FROM [dbo].[Borrower] AS A
     LEFT JOIN [dbo].[LoanSetupInformation] AS B ON A.[BorrowerID] = B.[BorrowerID];


--REPORT 2A

SELECT  B.[Citizenship],
[COUNT OF BORROWERS]= COUNT(DISTINCT L.BorrowerID),
[TOTAL PURCHASE AMOUNT]= FORMAT(SUM(L.PurchaseAmount)/1000, 'C0') + 'k',
[AVERAGE PURCHASE AMOUNT]= FORMAT(AVG(L.PurchaseAmount)/100, 'C0') + 'k',
[AVERAGE LTV]= FORMAT(AVG(LTV), 'P'),
[MINIMUM LTV]= FORMAT(MIN(LTV), 'P'),
[MAXIMUM LTV]= FORMAT(MAX(LTV), 'P'),
[AVG AGE OF BORROWER] = FLOOR(AVG(FLOOR(DATEDIFF(DAY, B.DOB, GETDATE())/365.25)))
FROM [dbo].[Borrower] AS B
INNER JOIN
[dbo].[LoanSetupInformation] AS L ON B.BorrowerID=L.BorrowerID
GROUP BY [Citizenship]
ORDER BY [TOTAL PURCHASE AMOUNT] DESC


---REPORT 2B

SELECT [Citizenship],
[FULL Gender] = CASE GENDER
				WHEN 'F' THEN 'F'
				WHEN 'M' THEN 'M'
				ELSE 'X'
				END,
[COUNT OF BORROWERS]= COUNT(DISTINCT L.BorrowerID),
[TOTAL PURCHASE AMOUNT]= FORMAT(SUM(L.PurchaseAmount), 'c0'),
[AVERAGE PURCHASE AMOUNT]= FORMAT(AVG(L.PurchaseAmount), 'c0'),
[AVERAGE LTV]= FORMAT(AVG(LTV), 'P'),
[MINIMUM LTV]= FORMAT(MIN(LTV), 'P'),
[MAXIMUM LTV]= FORMAT(MAX(LTV), 'P'),
[AVG AGE OF BORROWER] = FLOOR(AVG(FLOOR(DATEDIFF(DAY, B.DOB, GETDATE())/365.25)))
FROM [dbo].[Borrower] AS B
INNER JOIN
[dbo].[LoanSetupInformation] AS L ON B.BorrowerID=L.BorrowerID
WHERE GENDER in ('F', 'M', '')
GROUP BY [Citizenship], [Gender], [PurchaseAmount]
ORDER BY [TOTAL PURCHASE AMOUNT] DESC



--REPORT 2C

SELECT[Citizenship],
[FULL Gender] = CASE GENDER
				WHEN 'F' THEN 'F'
				WHEN 'M' THEN 'M'
				END,
[COUNT OF BORROWERS]= COUNT(DISTINCT L.BorrowerID),
[TOTAL PURCHASE AMOUNT]= FORMAT(SUM(L.PurchaseAmount), 'c0'),
[AVERAGE PURCHASE AMOUNT]= FORMAT(AVG(L.PurchaseAmount), 'c0'),
[AVERAGE LTV]= FORMAT(AVG(LTV), 'P'),
[MINIMUM LTV]= FORMAT(MIN(LTV), 'P'),
[MAXIMUM LTV]= FORMAT(MAX(LTV), 'P'),
[AVG AGE OF BORROWER] = FLOOR(AVG(FLOOR(DATEDIFF(DAY, B.DOB, GETDATE())/365.25))),
[YEAR OF PURCHASE] = YEAR(L.PurchaseDate)
FROM [dbo].[Borrower] AS B
INNER JOIN
[dbo].[LoanSetupInformation] AS L ON B.BorrowerID=L.BorrowerID
WHERE GENDER in ('F', 'M')
GROUP BY [Citizenship], [Gender], [PurchaseDate]
ORDER BY [Gender], [Year of Purchase] DESC



--------------------------REPORT 3

------FORMULAR FROM GOOGLE
CREATE TABLE #bin (
    startRange int, 
    endRange int,
    Loan varchar(30));


INSERT INTO #bin (startRange, endRange, mylabel) VALUES (10, 20, '10-20')
INSERT INTO #bin (startRange, endRange, mylabel) VALUES (21, 30, '21-30')
INSERT INTO #bin (startRange, endRange, mylabel) VALUES (31, 35, '31-35')
INSERT INTO #bin (startRange, endRange, mylabel) VALUES (36, 40, '36-40')
GO
---------------------------------------------------------------------

select * from LoanSetupInformation 
Order by PurchaseDate Desc;
---------------------------------------------------------------------------------



--REPORT 4

SELECT [YEAR OF PURCHASE]= YEAR(PURCHASEDATE),
[PAYMENT FREQUENCY]= P.PAYMENTFREQUENCY_DESCRIPTION,
[LOAN NUMBER]= COUNT(LOANNUMBER)
FROM [SKYBARRELBANK_UAT].[dbo].[LoanSetupInformation] AS L
INNER JOIN [SKYBARRELBANK_UAT].[dbo].[LU_PaymentFrequency] AS P
ON L.[PaymentFrequency]=P.[PaymentFrequency]
GROUP BY YEAR(PURCHASEDATE),P.PAYMENTFREQUENCY_DESCRIPTION