--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T3-mns-json.sql

--Student ID: 32818866
--Student Name: Devesh Gurusinghe
--Unit Code: FIT2094
--Applied Class No: 1 (Monday 11-1)

/* Comments for your marker:




*/

/*3(a)*/
SELECT
  A.appointment_number AS _id,
  TO_CHAR(A.appointment_date_time, 'DD/MM/YYYY HH24:MI') AS datetime,
  P.provider_code AS provider_code,
  CONCAT(P.title, ' ', P.first_name, ' ', P.last_name) AS provider_name,
  SUM(I.item_fees) AS item_totalcost,
  COUNT(I.item_id) AS no_of_items,
  JSON_ARRAYAGG(
    JSON_OBJECT(
      'id', I.item_id,
      'desc', I.item_description,
      'standardcost', I.standard_cost,
      'quantity', I.quantity
    )
  ) AS items
FROM MNS.APPOINTMENT AS A
JOIN MNS.SERVICE_AT_APPOINTMENT AS SA ON A.appointment_number = SA.appointment_number
JOIN MNS.ITEMS_USED_AT_APPOINTMENT AS I ON A.appointment_number = I.appointment_number
JOIN MNS.PROVIDER AS P ON A.provider_code = P.provider_code
GROUP BY A.appointment_number, datetime, provider_code, provider_name
HAVING COUNT(I.item_id) > 0;

