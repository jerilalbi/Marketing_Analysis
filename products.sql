SELECT * FROM products;

SELECT ProductID, ProductName, Price,
CASE
  WHEN Price < 50 THEN 'Low'
  WHEN PRICE BETWEEN 50 AND 200 THEN 'Medium'
  ELSE 'High'
END PriceCategory
FROM products
ORDER BY 1;