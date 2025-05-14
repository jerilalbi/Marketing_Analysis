SELECT * FROM customer_reviews;

-- Checking for Duplicates
WITH DUP_CHECK AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText ORDER BY ReviewID) AS RowNo
FROM customer_reviews
)

SELECT * FROM DUP_CHECK WHERE RowNo > 1;

-- Final Query

SELECT ReviewID, CustomerID, ProductID, ReviewDate,Rating,
REPLACE(ReviewText, "  ", " ") as ReviewText
FROM customer_reviews
ORDER BY 1;
