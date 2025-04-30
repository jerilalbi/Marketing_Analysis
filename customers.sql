SELECT * FROM customers;
-- Check for Duplicates
WITH DUP_CHECK AS (
 SELECT *, 
 ROW_NUMBER() OVER(PARTITION BY CustomerID, CustomerName, Email, Gender, Age, GeographyID ORDER BY CustomerID ) AS RowNo
 FROM customers
)

SELECT * FROM DUP_CHECK WHERE RowNO > 1;

-- Join with geography to get customer with country and city 

SELECT * FROM geography;

SELECT CustomerID, CustomerName, Email, Gender, Age, Country, City
FROM customers custom
LEFT JOIN geography geo
ON CUSTOM.GEOGRAPHYID = GEO.GEOGRAPHYID
ORDER BY 1;