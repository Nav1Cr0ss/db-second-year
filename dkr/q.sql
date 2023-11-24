-- Середній вік пацієнтів
SELECT AVG(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM date_of_birth)) AS average_age
FROM "user";

-- Кількість діагностик пацієнтів
SELECT pa.id, pa.user_id, u.date_of_birth, count(mr.id) as diagnostics
from patient pa
         LEFT JOIN "user" u ON u.id = pa.user_id
         LEFT JOIN medical_record mr on pa.id = mr.patient_id
GROUP BY pa.id, u.date_of_birth;

-- Отримати унікальні діагнози
SELECT COUNT(DISTINCT "name") AS diagnosis
FROM "diagnosis";

-- Order by, Group by, HAVING
SELECT FLOOR(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM u.date_of_birth)) AS patient_full_years,
       count(u.date_of_birth)                                                      as patient_cnt
FROM "user" u
         JOIN "patient" p ON u."id" = p."user_id"
GROUP BY u.date_of_birth
HAVING COUNT(DISTINCT p."id") > 1
ORDER BY patient_full_years;


-- Отримати пацієнтів що старші за середній вік
SELECT p."id",
       u."first_name",
       u."last_name",
       EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM u."date_of_birth") AS age
FROM "user" u
         JOIN "patient" p ON u."id" = p."user_id"
WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM u."date_of_birth") >
      (SELECT AVG(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM "date_of_birth")) FROM "user");


-- EXISTS
SELECT p."id", u."first_name", u."last_name"
FROM "user" u
         JOIN "patient" p ON u."id" = p."user_id"
WHERE EXISTS (SELECT 1 FROM "medical_record" WHERE "medical_record"."patient_id" = p."id");


-- Доктора що мають більше за 2 діагнози
SELECT d."id", u."first_name", u."last_name"
FROM "user" u
         JOIN "doctor" d ON u."id" = d."user_id"
WHERE d."id" IN (SELECT doctor_id
                 FROM "medical_record"
                 GROUP BY doctor_id
                 HAVING COUNT(*) > 2)
ORDER BY d."id";


-- На скільки багато лікив в середньому прописують
SELECT AVG((SELECT COUNT("medication_id")
            FROM "medical_record_medication"
            WHERE "medical_record_id" = "medical_record"."id")) AS average_medications_per_record
FROM "medical_record";






