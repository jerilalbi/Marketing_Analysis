SELECT * FROM customer_journey;

-- REMOVE DUPLICATES
CREATE TEMPORARY TABLE TEMP_CUST_JOURNEY AS
SELECT *,
ROW_NUMBER() OVER(PARTITION BY JourneyID, CustomerID, ProductID, VisitDate, Stage,
`Action`, Duration ORDER BY JourneyID) AS RowNo
FROM customer_journey;

DELETE FROM customer_journey;
ALTER TABLE customer_journey ADD COLUMN RowNo INT;

INSERT INTO customer_journey
SELECT * FROM TEMP_CUST_JOURNEY;

-- REMOVE BLANKS IN DURATION BY TAKING AVG OF DURATION IN VISITDATE

-- Final Query

WITH RM_DURATION_NULLS AS (
	SELECT *,
	AVG(Duration) OVER(PARTITION BY VisitDate) AS Avg_duration
	FROM customer_journey 
	WHERE RowNo = 1
)
SELECT JourneyID, CustomerID, ProductID, VisitDate, Upper(Stage) as Stage,
Action, 
CASE
 WHEN Duration = "" THEN ROUND(Avg_duration,2)
 ELSE Duration
END AS Duration
from RM_DURATION_NULLS
WHERE RowNo = 1
ORDER BY 1;