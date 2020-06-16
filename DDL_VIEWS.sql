-- CREATE VIEW profits

CREATE OR REPLACE VIEW stock_exchange_db.profits AS
(
SELECT 
	   stock_exchange_db.companies.company_name,
       stock_exchange_db.stock_acquisitions.acquisition_date,
       stock_exchange_db.stock_acquisitions.acquisition_time,
       stock_exchange_db.stock_acquisitions.acquisition_price,
       stock_exchange_db.stock_acquisitions.acquisition_quantity,
       stock_exchange_db.stock_sales.sale_date,
       stock_exchange_db.stock_sales.sale_time,
       stock_exchange_db.stock_sales.sale_price,
       stock_exchange_db.stock_sales.sale_quantity,
       stock_exchange_db.stock_sales.sale_taf_value,
       round((stock_exchange_db.stock_sales.sale_quantity * stock_exchange_db.stock_sales.sale_price) -
       (stock_exchange_db.stock_acquisitions.acquisition_quantity * stock_exchange_db.stock_acquisitions.acquisition_price) -
       stock_exchange_db.stock_sales.sale_taf_value, 3) AS profit
FROM stock_exchange_db.companies,
	 stock_exchange_db.stock_acquisitions,
     stock_exchange_db.stock_sales
WHERE stock_exchange_db.stock_sales.company_id = stock_exchange_db.stock_acquisitions.company_id
AND stock_exchange_db.companies.company_id = stock_exchange_db.stock_acquisitions.company_id
AND stock_exchange_db.stock_acquisitions.acquisition_quantity = stock_exchange_db.stock_sales.sale_quantity
AND stock_exchange_db.stock_acquisitions.company_id IN 
(
SELECT company_id FROM stock_exchange_db.stock_inventory
WHERE current_inventory = 0
)
)
WITH CHECK OPTION;