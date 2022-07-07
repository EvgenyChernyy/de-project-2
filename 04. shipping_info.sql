CREATE TABLE shipping_info (
	shippingid int8 NOT NULL PRIMARY KEY,
	vendorid int8 NULL,
	payment_amount NUMERIC(14, 2) NULL,
	shipping_plan_datetime TIMESTAMP NULL,
	transfer_type_id INT NOT NULL REFERENCES shipping_transfer(transfer_type_id),
	shipping_country_id INT NOT NULL REFERENCES shipping_country_rates(shipping_country_id),
	agreementid INT NOT NULL REFERENCES shipping_agreement(agreementid)
	);

INSERT INTO shipping_info
SELECT DISTINCT shippingid,
	vendorid,
	payment_amount,
	shipping_plan_datetime,
	st.transfer_type_id,
	scr.shipping_country_id,
	sa.agreementid
FROM shipping s
JOIN shipping_transfer st ON (regexp_split_to_array(s.shipping_transfer_description, ':+')) [1] = st.transfer_type
	AND (regexp_split_to_array(s.shipping_transfer_description, ':+')) [2] = st.transfer_model
	AND s.shipping_transfer_rate = st.shipping_transfer_rate
JOIN shipping_country_rates scr ON s.shipping_country = scr.shipping_country
	AND s.shipping_country_base_rate = scr.shipping_country_base_rate
JOIN shipping_agreement sa ON cast((regexp_split_to_array(s.vendor_agreement_description, ':+')) [1] AS INT) = sa.agreementid
ORDER BY 1;