CREATE VIEW shipping_datamart
AS
SELECT si.shippingid,
	si.vendorid,
	st.transfer_type,
	date_part('day', age(ss.shipping_end_fact_datetime, ss.shipping_start_fact_datetime)) AS full_day_at_shipping,
	CASE 
		WHEN ss.shipping_end_fact_datetime > si.shipping_plan_datetime
			THEN 1
		ELSE 0
		END AS is_delay,
	CASE 
		WHEN ss.STATUS = 'finished'
			THEN 1
		ELSE 0
		END AS is_shipping_finish,
	CASE 
		WHEN ss.shipping_end_fact_datetime > si.shipping_plan_datetime
			THEN ss.shipping_end_fact_datetime::DATE - si.shipping_plan_datetime::DATE
		ELSE 0
		END AS delay_day_at_shipping,
	si.payment_amount,
	si.payment_amount * (scr.shipping_country_base_rate + sa.agreement_rate + st.shipping_transfer_rate) vat,
	si.payment_amount * sa.agreement_commission profit
FROM shipping_info si
JOIN shipping_transfer st ON si.transfer_type_id = st.transfer_type_id
JOIN shipping_status ss ON si.shippingid = ss.shippingid
JOIN shipping_country_rates scr ON scr.shipping_country_id = si.shipping_country_id
JOIN shipping_agreement sa ON sa.agreementid = si.agreementid;