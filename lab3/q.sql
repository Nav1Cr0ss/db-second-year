-- Зв'язування двох таблиць: Вивести ім'я, прізвище користувача та дату його медичного запису
SELECT user.first_name, user.last_name, medical_record.date
FROM user
INNER JOIN medical_record ON user.id = medical_record.patient_id;

-- Зв'язування багатьох таблиць: Вивести ім'я користувача, назву діагнозу та назву призначеного лікування
SELECT user.first_name, diagnosis.name, medication.name
FROM user
INNER JOIN medical_record ON user.id = medical_record.patient_id
INNER JOIN diagnosis ON medical_record.diagnosis_id = diagnosis.id
INNER JOIN medical_record_medication ON medical_record.id = medical_record_medication.medical_record_id
INNER JOIN medication ON medical_record_medication.medication_id = medication.id;

-- Вибір конкретних стовпців: Вивести тільки імена та прізвища користувачів
SELECT first_name, last_name FROM user;

-- З'єднання таблиці з самою собою: Вивести пари користувачів з однаковими прізвищами
SELECT u1.first_name, u2.first_name
FROM user u1
INNER JOIN user u2 ON u1.id <> u2.id AND u1.last_name = u2.last_name;

-- Зовнішнє з'єднання: Вивести ім'я користувача та дату його медичного запису, якщо він існує
SELECT user.first_name, medical_record.date
FROM user
LEFT JOIN medical_record ON user.id = medical_record.patient_id;

-- Арифметичні оператори: Вивести результат додавання чисел 5 і 3
SELECT (5 + 3) AS sum_result;

-- Логічні оператори: Вивести користувачів з іменем John і прізвищем Doe або іменем Alice і прізвищем Smith
SELECT * FROM user WHERE (first_name = 'John' AND last_name = 'Doe') OR (first_name = 'Alice' AND last_name = 'Smith');

-- Оператори порівняння: Вивести медичні записи після 1 січня 2023 року
SELECT * FROM medical_record WHERE date > '2023-01-01';

-- Спеціальний оператор IN: Вивести користувачів з ID 1, 2 або 3
SELECT * FROM user WHERE id IN (1, 2, 3);

-- Спеціальний оператор BETWEEN: Вивести медичні записи за 2023 рік
SELECT * FROM medical_record WHERE date BETWEEN '2023-01-01' AND '2023-12-31';

-- Спеціальний оператор LIKE: Вивести користувачів з email, що містить "gmail.com"
SELECT * FROM user WHERE email LIKE '%gmail.com';

-- Спеціальні оператори IS NULL і IS NOT NULL: Вивести користувачів без номера телефону
SELECT * FROM user WHERE phone IS NULL;

-- Функція NVL(COALESCE) (приклад заміни NULL значеннями за замовчуванням): Вивести імена користувачів та, якщо відсутнє, замінити прізвище на "Unknown"
SELECT first_name, COALESCE(last_name, 'Unknown') AS last_name FROM user;

-- Оператор конкатенації || (приклад об'єднання рядків): Вивести повне ім'я користувача
SELECT first_name || ' ' || last_name AS full_name FROM user;
