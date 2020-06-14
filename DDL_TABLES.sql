CREATE TABLE stock_exchange_db.companies
(
	company_id VARCHAR(5) NOT NULL PRIMARY KEY,
	company_name VARCHAR(40) NOT NULL,
	INDEX idx_comp_id(company_id)
);


CREATE TABLE stock_exchange_db.stock_acquisitions
(
	company_id VARCHAR(5) NOT NULL,
	acquisition_date DATE NOT NULL,
	acquisition_time TIME NOT NULL,
	acquisition_price DECIMAL(7, 3) UNSIGNED NOT NULL,
	acquisition_quantity DECIMAL(5, 2) UNSIGNED NOT NULL,
	FOREIGN KEY stk_acq_comp_id_fk(company_id) REFERENCES companies(company_id) ON UPDATE CASCADE ON DELETE NO ACTION,
	PRIMARY KEY stk_acq_pk(company_id, acquisition_date, acquisition_time),
	INDEX idx_stk_acq_comp_id(company_id)
);


CREATE TABLE stock_exchange_db.stock_sales
(
	company_id VARCHAR(5) NOT NULL,
	sale_date DATE NOT NULL,
	sale_time TIME NOT NULL,
	sale_price DECIMAL(7, 3) UNSIGNED NOT NULL,
	sale_quantity DECIMAL(5, 2) UNSIGNED NOT NULL,
	sale_taf_value DECIMAL(7, 3) UNSIGNED NOT NULL,
	FOREIGN KEY stk_sl_comp_id_fk(company_id) REFERENCES companies(company_id) ON UPDATE CASCADE ON DELETE NO ACTION,
	PRIMARY KEY stk_sl_pk(company_id, sale_date, sale_time),
	INDEX idx_stk_sl_comp_id(company_id)
);


CREATE TABLE stock_exchange_db.stock_inventory
(
	company_id VARCHAR(5) NOT NULL PRIMARY KEY,
	current_inventory DECIMAL(5, 2) NOT NULL,
	FOREIGN KEY stk_inv_comp_id_fk(company_id) REFERENCES companies(company_id) ON UPDATE CASCADE ON DELETE NO ACTION,
	INDEX idx_stk_inv_comp_id(company_id)
);