CREATE TABLE shipping_transfer (
	transfer_type_id serial NOT NULL PRIMARY KEY,
	transfer_type TEXT NOT NULL,
	transfer_model TEXT NOT NULL,
	shipping_transfer_rate NUMERIC(14, 3) NOT NULL
	);

CREATE sequence shipping_transfer_serial start
	WITH 1;

INSERT INTO shipping_transfer
SELECT nextval('shipping_transfer_serial'),
	(regexp_split_to_array(t.shipping_transfer_description, ':+')) [1] transfer_type,
	(regexp_split_to_array(t.shipping_transfer_description, ':+')) [2] transfer_model,
	t.shipping_transfer_rate
FROM (
	SELECT DISTINCT shipping_transfer_description,
		shipping_transfer_rate
	FROM shipping s
	) t
ORDER BY 2,
	3,
	4;

DROP sequence shipping_transfer_serial;
