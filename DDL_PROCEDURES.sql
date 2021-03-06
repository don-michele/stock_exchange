-- CREATE PROCEDURE acquire_stocks

DELIMITER $
CREATE PROCEDURE stock_exchange_db.acquire_stocks(IN id_cmp VARCHAR(5), IN date_acq DATE, IN time_acq TIME, 
												  IN price_acq DECIMAL(8, 4), IN qty_acq DECIMAL(5, 2), IN acq_dlt_err DECIMAL(4, 3))
BEGIN
	DECLARE comp_exists_cmp INT;
    DECLARE comp_exists_stk INT;
    DECLARE current_stock DECIMAL(5, 2);
    DECLARE new_stock DECIMAL(5, 2);
	DECLARE crt_avg_acq_price DECIMAL(8, 4);
	DECLARE new_avg_acq_price DECIMAL(8, 4);
	DECLARE crt_acq_dlt_err DECIMAL(4, 3);
	DECLARE new_acq_dlt_err DECIMAL(4, 3);
    DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
    -- Step 1: Check if company_id exists in table 'companies' and crash if it doesn't
	SET comp_exists_cmp = (SELECT COUNT(*) FROM stock_exchange_db.companies WHERE company_id = id_cmp);
	IF (comp_exists_cmp = 0) THEN
		SIGNAL CUSTOM_EXCEPTION 
        SET MESSAGE_TEXT = 'Company ID not found in table "companies"!';
	END IF;
    -- Step 2: Insert values in table 'stock_acquisitions'
    INSERT INTO stock_exchange_db.stock_acquisitions VALUES (id_cmp, date_acq, time_acq, price_acq, qty_acq, acq_dlt_err);
    -- Step 3: Modify table 'stocks' accordingly
    SET comp_exists_stk = (SELECT COUNT(*) FROM stock_exchange_db.stock_inventory WHERE company_id = id_cmp);
    IF (comp_exists_stk = 0) THEN
		INSERT INTO stock_exchange_db.stock_inventory VALUES(id_cmp, qty_acq, price_acq, acq_dlt_err);
	ELSE
		SET current_stock = (SELECT current_inventory FROM stock_exchange_db.stock_inventory WHERE company_id = id_cmp);
        SET new_stock = current_stock + qty_acq;
		SET crt_avg_acq_price = (SELECT current_avg_acq_price FROM stock_exchange_db.stock_inventory WHERE company_id = id_cmp);
		SET new_avg_acq_price = ROUND(((current_stock * crt_avg_acq_price) + (qty_acq * price_acq))/new_stock, 4);
		SET crt_acq_dlt_err = (SELECT current_acq_delta_error FROM stock_exchange_db.stock_inventory WHERE company_id = id_cmp);
		SET new_acq_dlt_err = crt_acq_dlt_err + acq_dlt_err;
        UPDATE stock_exchange_db.stock_inventory SET current_inventory = new_stock WHERE company_id = id_cmp;
		UPDATE stock_exchange_db.stock_inventory SET current_avg_acq_price = new_avg_acq_price WHERE company_id = id_cmp;
		UPDATE stock_exchange_db.stock_inventory SET current_acq_delta_error = new_acq_dlt_err WHERE company_id = id_cmp;
	END IF;
END$
DELIMITER ;


-- CREATE PROCEDURE sale_stocks

DELIMITER $
CREATE PROCEDURE stock_exchange_db.sale_stocks(IN id_cmp VARCHAR(5), IN date_sl DATE, IN time_sl TIME, 
												  IN price_sl DECIMAL(8, 4), IN qty_sl DECIMAL(5, 2), IN taf_sl DECIMAL(7, 3), 
												  sl_dlt_err DECIMAL(4, 3))
BEGIN
	DECLARE comp_exists_cmp INT;
    DECLARE comp_exists_stk INT;
    DECLARE current_stock DECIMAL(5, 2);
    DECLARE new_stock DECIMAL(5, 2);
	DECLARE crt_avg_acq_price DECIMAL(8, 4);
	DECLARE crt_acq_dlt_err DECIMAL(4, 3);
    DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
    -- Step 1: Check if company_id exists in table 'companies' and crash if it doesn't
	SET comp_exists_cmp = (SELECT COUNT(*) FROM stock_exchange_db.companies WHERE company_id = id_cmp);
	IF (comp_exists_cmp = 0) THEN
		SIGNAL CUSTOM_EXCEPTION 
        SET MESSAGE_TEXT = 'Company ID not found in table "companies"!';
	END IF;
    -- Step 2: Insert values in table 'stock_sales'
	SET comp_exists_stk = (SELECT COUNT(*) FROM stock_exchange_db.stock_inventory WHERE company_id = id_cmp);
    IF (comp_exists_stk = 0) THEN
		SIGNAL CUSTOM_EXCEPTION
        SET MESSAGE_TEXT = 'You cannot sale stocks for a company where you do not own any!';
	ELSE
		SET current_stock = (SELECT current_inventory FROM stock_exchange_db.stock_inventory WHERE company_id = id_cmp);
		IF (current_stock < qty_sl) THEN
			SIGNAL CUSTOM_EXCEPTION
            SET MESSAGE_TEXT = 'You cannot sell at a company more stocks than you own!';
		ELSE
			SET crt_avg_acq_price = (SELECT current_avg_acq_price FROM stock_exchange_db.stock_inventory WHERE company_id = id_cmp);
			SET crt_acq_dlt_err = (SELECT current_acq_delta_error FROM stock_exchange_db.stock_inventory WHERE company_id = id_cmp);
			INSERT INTO stock_exchange_db.stock_sales VALUES (id_cmp, date_sl, time_sl, crt_avg_acq_price, crt_acq_dlt_err, price_sl, qty_sl, 
															  taf_sl, sl_dlt_err);
        END IF;
	END IF;
    -- Step 3: Modify table 'stocks' accordingly
    SET new_stock = current_stock - qty_sl;
    UPDATE stock_exchange_db.stock_inventory SET current_inventory = new_stock WHERE company_id = id_cmp;
	UPDATE stock_exchange_db.stock_inventory SET current_acq_delta_error = 0 WHERE company_id = id_cmp;
END$
DELIMITER ;
