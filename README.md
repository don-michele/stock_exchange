# stock_exchange

Examples of uses for the procedures 

insert into stock_exchange_db.companies values ('ZHN', 'China Southern Airlines');

CALL stock_exchange_db.acquire_stocks('ZHN', '2018-04-13', '13:22', 12.12, 3);

CALL stock_exchange_db.sale_stocks('ZHN', '2019-02-01', '23:11', 14.11, 3, 0.01);
