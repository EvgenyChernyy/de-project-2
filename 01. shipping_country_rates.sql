CREATE TABLE shipping_country_rates (
	shipping_country_id serial4 NOT NULL PRIMARY KEY,
	shipping_country TEXT NULL,
	shipping_country_base_rate NUMERIC(14, 3) NULL
	);

CREATE SEQUENCE shipping_country_rates_serial START 1;

INSERT INTO shipping_country_rates
SELECT nextval('shipping_country_rates_serial'),
	t.shipping_country,
	t.shipping_country_base_rate
FROM (
	SELECT DISTINCT shipping_country,
		shipping_country_base_rate
	FROM shipping s
	) t;

DROP sequence shipping_country_rates_serial;
