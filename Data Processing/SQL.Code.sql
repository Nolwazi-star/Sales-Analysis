SELECT * FROM 
       retail.sales_c;

SELECT Date,
       Sales,
       `Cost Of Sales`,
       `Quantity Sold`,
      ROUND(Sales/`Quantity Sold`,2) AS  Daily_Sales_Price_Per_Unit,
      ROUND((Sales-`Cost Of Sales`),2) AS Daily_Gross_Profit,
      ROUND(((Sales-`Cost Of Sales`)/Sales) *100,2) AS Daily_Percent_Gross_Profit,
      ROUND(`Cost Of Sales` / `Quantity Sold`,2) AS Cost_Per_Unit,
      ROUND((Sales / `Quantity Sold`) - (`Cost of Sales` / `Quantity Sold`), 2) AS Gross_Profit_Per_Unit,
      ROUND((((Sales / `Quantity Sold`) - (`Cost of Sales` / `Quantity Sold`)) / (Sales / `Quantity Sold`)) * 100, 2) AS Daily_Percent_Gross_Profit_Per_Unit
FROM retail.sales_c;

SELECT 
      ROUND(SUM(Sales)/SUM(`Quantity Sold`),2) AS Average_Unit_Price
      FROM retail.sales_c;

SELECT 
     Date,
      ROUND(Sales / `Quantity Sold`, 2) AS Price_Per_Unit,
       `Quantity Sold`
       FROM retail.sales_c
       WHERE ROUND(Sales / `Quantity Sold`, 2) < (
    SELECT AVG(Sales / `Quantity Sold`) * 0.90 
    FROM retail.sales_c
) 
AND Date > '2014-01-07'  -- Only dates after first week
ORDER BY Date;

-- Calculate Price Elasticity of Demand for 3 promo periods
WITH baseline AS (
    -- Average price and quantity before each promo
    SELECT 
        'Promo1' AS promo_period,
        AVG(Sales / `Quantity Sold`) AS avg_price_before,
        AVG(`Quantity Sold`) AS avg_qty_before
    FROM retail.sales_c
    WHERE Date BETWEEN '2014-01-31' AND '2014-02-06'

    UNION ALL
    SELECT 
        'Promo2',
        AVG(Sales / `Quantity Sold`) AS avg_price_before,
        AVG(`Quantity Sold`) AS avg_qty_before
    FROM retail.sales_c
    WHERE Date BETWEEN '2014-04-01' AND '2014-04-09'

    UNION ALL
    SELECT 
        'Promo3',
        AVG(Sales / `Quantity Sold`) AS avg_price_before,
        AVG(`Quantity Sold`) AS avg_qty_before
    FROM retail.sales_c
    WHERE Date BETWEEN '2014-09-17' AND '2014-09-23'
),
promo AS (
    -- Average price and quantity during each promo
    SELECT 
        'Promo1' AS promo_period,
        AVG(Sales / `Quantity Sold`) AS avg_price_during,
        AVG(`Quantity Sold`) AS avg_qty_during
    FROM retail.sales_c
    WHERE Date BETWEEN '2014-02-07' AND '2014-02-17'

    UNION ALL
    SELECT 
        'Promo2',
        AVG(Sales / `Quantity Sold`) AS avg_price_during,
        AVG(`Quantity Sold`) AS avg_qty_during
    FROM retail.sales_c
    WHERE Date BETWEEN '2014-04-10' AND '2014-04-22'

    UNION ALL
    SELECT 
        'Promo3',
        AVG(Sales / `Quantity Sold`) AS avg_price_during,
        AVG(`Quantity Sold`) AS avg_qty_during
    FROM retail.sales_c
    WHERE Date BETWEEN '2014-09-24' AND '2014-10-06'
)

SELECT 
    b.promo_period,
    ROUND(p.avg_price_during,2) AS avg_price,
    ROUND(p.avg_qty_during,0) AS avg_quantity,
    ROUND(
        ((p.avg_qty_during - b.avg_qty_before) / b.avg_qty_before) /
        ((p.avg_price_during - b.avg_price_before) / b.avg_price_before),
        2
    ) AS PED
FROM baseline b
JOIN promo p
  ON b.promo_period = p.promo_period;

SELECT
    YEAR(Date) AS year,
    MONTHNAME(Date) AS month,
    SUM(Sales) AS total_sales,
    SUM(`Quantity Sold`) AS total_quantity
FROM retail.sales_c
GROUP BY YEAR(Date), MONTHNAME(Date)
ORDER BY YEAR(Date), MONTHNAME(Date);

