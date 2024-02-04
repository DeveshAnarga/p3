--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T2-mns-select.sql

--Student ID: 32818866
--Student Name: Devesh Gurusinghe
--Unit Code: FIT2094
--Applied Class No: 1 (Monday 11-1)

/* Comments for your marker:




*/

/*2(a)*/
SELECT id, description, standard_cost, stock
FROM MNS.ITEM
WHERE stock >= 50 AND description LIKE '%composite%'
ORDER BY stock DESC, id;


/*2(b)*/
SELECT
  CONCAT(title, '. ', first_name, ' ', last_name) AS full_name
FROM MNS.PROVIDER
WHERE specialization = 'PAEDIATRIC DENTISTRY'
ORDER BY last_name, first_name, provider_code;




/*2(c)*/
SELECT
  service_code,
  description,
  CONCAT('$', FORMAT(standard_fee, 2)) AS formatted_fee
FROM MNS.SERVICE
WHERE standard_fee > (
  SELECT AVG(standard_fee) FROM MNS.SERVICE
)
ORDER BY standard_fee DESC, service_code;



/*2(d)*/
SELECT
  appointment_number,
  appointment_date_time,
  patient_number,
  CONCAT(patient_first_name, ' ', patient_last_name) AS patient_full_name,
  CONCAT('$', FORMAT(appointment_total_cost, 2)) AS formatted_cost
FROM (
  SELECT
    A.appointment_number,
    A.appointment_date_time,
    A.patient_number,
    P.patient_first_name,
    P.patient_last_name,
    (SUM(S.service_fee) + SUM(I.item_fees)) AS appointment_total_cost
  FROM MNS.APPOINTMENT AS A
  JOIN MNS.PATIENT AS P ON A.patient_number = P.patient_number
  LEFT JOIN (
    SELECT S.appointment_number, SUM(S.service_fee) AS service_fee
    FROM MNS.SERVICE_AT_APPOINTMENT AS S
    GROUP BY S.appointment_number
  ) AS S ON A.appointment_number = S.appointment_number
  LEFT JOIN (
    SELECT I.appointment_number, SUM(I.item_fees) AS item_fees
    FROM MNS.ITEMS_USED_AT_APPOINTMENT AS I
    GROUP BY I.appointment_number
  ) AS I ON A.appointment_number = I.appointment_number
  GROUP BY A.appointment_number, A.appointment_date_time, A.patient_number, P.patient_first_name, P.patient_last_name
) AS T
ORDER BY appointment_total_cost DESC, appointment_number;



/*2(e)*/
SELECT
  S.service_code,
  S.description,
  CONCAT('$', FORMAT(S.standard_fee, 2)) AS standard_fee,
  CONCAT('$', FORMAT(AVG(SAAP.actual_charged_service_fee - S.standard_fee), 2)) AS service_fee_differential
FROM MNS.SERVICE AS S
JOIN MNS.SERVICE_AT_APPOINTMENT AS SAAP ON S.service_code = SAAP.service_code
GROUP BY S.service_code, S.description, S.standard_fee
ORDER BY S.service_code;


/*2(f)*/
SELECT
  P.patient_number AS PATIENT_NO,
  CONCAT(P.patient_first_name, ' ', P.patient_last_name) AS PATIENTNAME,
  FLOOR(DATEDIFF(CURRENT_DATE, P.date_of_birth) / 365) AS CURRENTAGE,
  COUNT(A.appointment_number) AS NUMAPPTS,
  CONCAT(
    IFNULL(
      CONCAT(FORMAT(COUNT(F.appointment_number) / COUNT(A.appointment_number) * 100, 1), '%'),
      '0%'
    )
  ) AS FOLLOWUPS
FROM MNS.PATIENT AS P
LEFT JOIN MNS.APPOINTMENT AS A ON P.patient_number = A.patient_number
LEFT JOIN MNS.APPOINTMENT AS F ON A.prior_appointment_number = F.appointment_number
GROUP BY P.patient_number, PATIENTNAME, CURRENTAGE
ORDER BY PATIENT_NO;




/*2(g)*/
SELECT
  P.provider_code AS PCODE,
  IFNULL(COUNT(A.appointment_number), '-') AS NUMBERAPPTS,
  IFNULL(CONCAT('$', FORMAT(IFNULL(SUM(A.actual_charged_service_fee), 0), 2)), '-') AS TOTLFEES,
  IFNULL(SUM(IFNULL(I.quantity, 0)), '-') AS NOITEMS
FROM MNS.PROVIDER AS P
LEFT JOIN MNS.APPOINTMENT AS A ON P.provider_code = A.provider_code
LEFT JOIN MNS.ITEMS_USED_AT_APPOINTMENT AS I ON A.appointment_number = I.appointment_number
WHERE A.appointment_date_time >= '2023-09-10 09:00:00' AND A.appointment_date_time <= '2023-09-14 17:00:00'
GROUP BY P.provider_code
ORDER BY P.provider_code;




