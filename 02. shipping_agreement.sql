CREATE TABLE shipping_agreement (
	agreementid INT NOT NULL PRIMARY KEY,
	agreement_number TEXT NOT NULL,
	agreement_rate NUMERIC(14, 3) NOT NULL,
	agreement_commission NUMERIC(14, 3) NOT NULL
	);

INSERT INTO shipping_agreement
SELECT cast((regexp_split_to_array(t.vendor_agreement_description, ':+')) [1] AS INT) agreementid,
	(regexp_split_to_array(t.vendor_agreement_description, ':+')) [2] agreement_number,
	cast((regexp_split_to_array(t.vendor_agreement_description, ':+')) [3] AS NUMERIC(14, 3)) agreement_rate,
	cast((regexp_split_to_array(t.vendor_agreement_description, ':+')) [4] AS NUMERIC(14, 3)) agreement_commission
FROM (
	SELECT DISTINCT vendor_agreement_description
	FROM shipping s
	) t
ORDER BY 1;
