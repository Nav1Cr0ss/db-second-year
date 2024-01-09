--Розгорнутий список Абітурієнтів:
SELECT u.id,
       u.email,
       u.first_name,
       u.last_name,
       a.id                           AS application_id,
       array_agg(DISTINCT d.title)    AS documents,
       array_agg(DISTINCT p.codename) AS programs,
       a.date_added
FROM "user_users" AS u
         LEFT JOIN "application_applications" AS a ON u.id = a.user_id

         LEFT JOIN "application_application_documents" AS ad ON ad.application_id = a.id
         LEFT JOIN "file_documents" AS d ON d.id = ad.document_id

         LEFT JOIN "application_application_programs" AS ap ON ap.application_id = a.id
         LEFT JOIN "education_program" AS p ON p.id = ap.program_id
WHERE u.role = 'applicant'
GROUP BY u.id, a.id;


-- Список всіх абітурієнтів та їхніх заявок:
SELECT u.first_name, u.last_name, a.id AS application_id, a.status
FROM "user_users" u
         LEFT JOIN "application_applications" a ON u.id = a.user_id;


-- Загальна кількість абітурієнтів за факультетами:
SELECT f.title AS faculty, COUNT(u.id) AS applicants_count
FROM "user_users" u
         LEFT JOIN "application_applications" a ON u.id = a.user_id
         LEFT JOIN application_application_programs ap ON ap.application_id = a.id
         JOIN "education_program" p ON ap.program_id = p.id
         JOIN "education_faculty" f ON p.faculty_id = f.id
GROUP BY faculty;


-- Кількість абітурієнтів на кожному факультеті, які подали заявку та мають статус 'rejected':
SELECT f.title AS faculty, COUNT(u.id) AS approved_applicants_count
FROM "user_users" u
         LEFT JOIN "application_applications" a ON u.id = a.user_id
         LEFT JOIN application_application_programs ap ON ap.application_id = a.id
         JOIN "education_program" p ON ap.program_id = p.id
         JOIN "education_faculty" f ON p.faculty_id = f.id
WHERE a.status = 'rejected'
GROUP BY faculty;

--Пріорітетна заявка абітурієнта:
SELECT u.id, u.first_name, u.last_name, a.id AS application_id, a.status, ap.program_id
FROM "user_users" u
         LEFT JOIN "application_applications" a ON u.id = a.user_id
         LEFT JOIN application_application_programs ap ON ap.application_id = a.id
ORDER BY ap.priority
LIMIT 1;


--Список абітурієнтів, які мають найвищий рейтинг (спрощено, без урахування правил програми):
SELECT u.id, u.first_name, u.last_name, ROUND(COALESCE(SUM(s.score), 0)) AS max_score
FROM "user_users" u
         LEFT JOIN "application_scores" s ON u.id = s.application_id
GROUP BY u.id
ORDER BY max_score DESC;


--Середній бал абітурієнта:
SELECT u.id, u.first_name, u.last_name, ROUND(COALESCE(AVG(s.score), 0)) AS avg_score
FROM "user_users" u
         LEFT JOIN "application_scores" s ON u.id = s.application_id
GROUP BY u.id
ORDER BY avg_score DESC;


--Кількість абітурієнтів за роками народження:
SELECT EXTRACT(YEAR FROM u.date_of_birth) AS birth_year, COUNT(u.id) AS applicants_count
FROM "user_users" u
GROUP BY birth_year
ORDER BY birth_year;

--Список факультетів та кількість програм на кожному:
SELECT f.title AS faculty, COUNT(p.id) AS program_count
FROM "education_faculty" f
         LEFT JOIN "education_program" p ON f.id = p.faculty_id
GROUP BY faculty;

--Список програм з кількістю абітурієнтів:
SELECT p.title AS program, COUNT(ap.id) AS applicants_count
FROM "education_program" p
         LEFT JOIN application_application_programs ap ON ap.program_id = p.id
GROUP BY program
ORDER BY applicants_count DESC;


--Середній бал з обов'язкових предметів на кожному факультеті:
SELECT p.title AS faculty, Round(AVG(sr.min_score)) AS average_score
FROM "education_program" p
         LEFT JOIN "education_subject_rules" sr ON p.id = sr.subject_id
WHERE sr.is_required = true
GROUP BY p.title;


--Загальна кількість абітурієнтів за статусом заявки:
SELECT a.status, COUNT(u.id) AS applicants_count
FROM "user_users" u
         LEFT JOIN "application_applications" a ON u.id = a.user_id
GROUP BY a.status;

--Кількість абітурієнтів на кожному факультеті за статусом заявки:
SELECT f.title, a.status, COUNT(f.id)
FROM "application_application_programs" ap
         JOIN "application_applications" a ON a.id = ap.application_id
         JOIN "education_program" p ON p.id = ap.program_id
         JOIN "education_faculty" f ON f.id = p.faculty_id
GROUP BY f.title, a.status;


-- Кількість абітурієнтів на кожному факультеті, які подали заявку та мають статус 'approved':
SELECT f.title AS faculty, COUNT(u.id) AS approved_applicants_count
FROM "user_users" u
         LEFT JOIN "application_applications" a ON u.id = a.user_id
         LEFT JOIN application_application_programs ap ON ap.application_id = a.id
         JOIN "education_program" p ON ap.program_id = p.id
         JOIN "education_faculty" f ON p.faculty_id = f.id
WHERE a.status = 'approved'
GROUP BY faculty;


-- Кількість абітурієнтів на кожному факультеті, які подали заявку та мають статус 'pending':
SELECT f.title AS faculty, COUNT(u.id) AS approved_applicants_count
FROM "user_users" u
         LEFT JOIN "application_applications" a ON u.id = a.user_id
         LEFT JOIN application_application_programs ap ON ap.application_id = a.id
         JOIN "education_program" p ON ap.program_id = p.id
         JOIN "education_faculty" f ON p.faculty_id = f.id
WHERE a.status = 'pending'
GROUP BY faculty;


--Список абітурієнтів, які подали заявку, та кількість їх документів:
SELECT u.first_name, u.last_name, a.id AS application_id, COUNT(d.id) AS document_count
FROM "user_users" u
         LEFT JOIN "application_applications" a ON u.id = a.user_id
         LEFT JOIN "application_application_documents" ad ON ad.application_id = a.id
         LEFT JOIN "file_documents" d ON ad.document_id = d.id
GROUP BY a.id, u.first_name, u.last_name, application_id;


--Список всіх дозволів та кількість користувачів, які мають кожен дозвіл:
SELECT p.title AS permission, COUNT(u.id) AS user_count
FROM "user_permissions" p
         LEFT JOIN "user_user_permissions" up ON p.id = up.permission_id
         LEFT JOIN "user_users" u ON up.user_id = u.id
GROUP BY permission;

--Список користувачів та їхніх дозволів:
SELECT u.first_name, u.last_name, ARRAY_AGG(p.title) AS permissions
FROM "user_users" u
         LEFT JOIN "user_user_permissions" up ON u.id = up.user_id
         LEFT JOIN "user_permissions" p ON up.permission_id = p.id
GROUP BY u.first_name, u.last_name;

--Дозволи, які не використовуються жодним користувачем:
SELECT p.title AS unused_permission
FROM "user_permissions" p
         LEFT JOIN "user_user_permissions" up ON p.id = up.permission_id
WHERE up.user_id IS NULL;

--лькість дозволів для кожного користувача, враховуючи роль:
SELECT u.first_name, u.last_name, u.role, COUNT(up.permission_id) AS permission_count
FROM "user_users" u
         LEFT JOIN "user_user_permissions" up ON u.id = up.user_id
GROUP BY u.first_name, u.last_name, u.role;