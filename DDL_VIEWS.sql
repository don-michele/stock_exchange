-- CREATE VIEW profits

CREATE OR REPLACE VIEW stock_exchange_db.profits AS
(
SELECT 
	   stock_exchange_db.companies.company_name,
       stock_exchange_db.stock_sales.sale_date,
       stock_exchange_db.stock_sales.sale_time,
	   stock_exchange_db.stock_sales.average_acquisition_price,
       stock_exchange_db.stock_sales.current_acquisition_delta_error,
	   stock_exchange_db.stock_sales.sale_price,
       stock_exchange_db.stock_sales.sale_quantity,
       stock_exchange_db.stock_sales.sale_taf_value,
	   stock_exchange_db.stock_sales.sale_delta_error,
       round(stock_exchange_db.stock_sales.sale_quantity * (stock_exchange_db.stock_sales.sale_price - 
	   stock_exchange_db.stock_sales.average_acquisition_price) + stock_exchange_db.stock_sales.current_acquisition_delta_error +
	   stock_exchange_db.stock_sales.sale_delta_error - stock_exchange_db.stock_sales.sale_taf_value, 4) AS profit
FROM stock_exchange_db.companies,
     stock_exchange_db.stock_sales
WHERE stock_exchange_db.stock_sales.company_id = stock_exchange_db.companies.company_id
)
WITH CHECK OPTION;


-- CREATE VIEW stocks_age

CREATE OR REPLACE VIEW stock_exchange_db.stocks_age AS
(
SELECT stock_exchange_db.companies.company_name,
	   MAX(stock_exchange_db.stock_acquisitions.acquisition_date) AS latest_acquisition_date, 
	   DATEDIFF(CURDATE(), acquisition_date) as days_from_acquisition 
FROM stock_exchange_db.stock_acquisitions
INNER JOIN stock_exchange_db.companies
ON (stock_exchange_db.companies.company_id = stock_exchange_db.stock_acquisitions.company_id)	
WHERE stock_exchange_db.companies.company_id IN
	(
	SELECT company_id FROM stock_exchange_db.stock_inventory
	WHERE current_inventory <> 0
	)
GROUP BY stock_exchange_db.companies.company_name
);
