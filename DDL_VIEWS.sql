-- CREATE VIEW profits

CREATE OR REPLACE VIEW stock_exchange_db.profits AS
(
SELECT 
	   stock_exchange_db.companies.company_name,
       stock_exchange_db.stock_sales.sale_date,
       stock_exchange_db.stock_sales.sale_time,
	   stock_exchange_db.stock_sales.average_acquisition_price,
       stock_exchange_db.stock_sales.sale_price,
       stock_exchange_db.stock_sales.sale_quantity,
       stock_exchange_db.stock_sales.sale_taf_value,
       round(stock_exchange_db.stock_sales.sale_quantity * (stock_exchange_db.stock_sales.sale_price - 
	   stock_exchange_db.stock_sales.average_acquisition_price) - stock_exchange_db.stock_sales.sale_taf_value, 4) AS profit
FROM stock_exchange_db.companies,
     stock_exchange_db.stock_sales
WHERE stock_exchange_db.stock_sales.company_id = stock_exchange_db.companies.company_id
)
WITH CHECK OPTION;