CREATE TABLE shipping_status (
	shippingid int8 NOT NULL PRIMARY KEY,
	STATUS TEXT NULL,
	STATE TEXT NULL,
	shipping_start_fact_datetime TIMESTAMP NULL,
	shipping_end_fact_datetime TIMESTAMP NULL
	);

WITH s
AS (
	SELECT shippingid,
		max(state_datetime) AS max_state_datetime,
		min(CASE 
				WHEN STATE = 'booked'
					THEN state_datetime
				END) AS shipping_start_fact_datetime,
		min(CASE 
				WHEN STATE = 'recieved'
					THEN state_datetime
				END) AS shipping_end_fact_datetime
	FROM shipping
	GROUP BY shippingid
	)
INSERT INTO shipping_status
SELECT s.shippingid,
	sh.STATUS,
	sh.STATE,
	s.shipping_start_fact_datetime,
	s.shipping_end_fact_datetime
FROM s
JOIN shipping sh ON s.shippingid = sh.shippingid
	AND s.max_state_datetime = sh.state_datetime;