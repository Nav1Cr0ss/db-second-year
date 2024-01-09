-- Inserting data into the "user" table
INSERT INTO "user" ("last_name", "first_name", "date_of_birth", "address", "phone", "email", "password", "insurance_number")
VALUES
  ('Doe', 'John', '1990-05-15', '123 Main St, Cityville', '123-456-7890', 'john.doe@email.com', 'password123', 'ABCD123456'),
  ('Smith', 'Alice', '1985-08-22', '456 Oak St, Townsville', '987-654-3210', 'alice.smith@email.com', 'password456', 'EFGH789012');

-- Inserting data into the "patient" table
INSERT INTO "patient" ("user_id")
VALUES
  (1),
  (2);

-- Inserting data into the "doctor" table
INSERT INTO "doctor" ("user_id")
VALUES
  (1),
  (2);

-- Inserting data into the "diagnosis" table
INSERT INTO "diagnosis" ("user_id", "name", "type", "description")
VALUES
  (1, 'Hypertension', 'Cardiovascular', 'High blood pressure'),
  (2, 'Diabetes', 'Metabolic', 'Type 2 diabetes mellitus');

-- Inserting data into the "medication" table
INSERT INTO "medication" ("name", "form", "description")
VALUES
  ('Lisinopril', 'Tablet', 'Angiotensin-converting enzyme (ACE) inhibitor'),
  ('Metformin', 'Tablet', 'Oral diabetes medication');

-- Inserting data into the "medical_record" table
INSERT INTO "medical_record" ("date", "symptoms", "prescribed_treatment", "doctor_examination", "patient_id", "doctor_id", "diagnosis_id")
VALUES
  ('2024-01-01', 'Headache, dizziness', 'Lisinopril 10mg daily', 'Blood pressure normal', 1, 1, 1),
  ('2024-02-01', 'Increased thirst, frequent urination', 'Metformin 500mg twice daily', 'Blood sugar under control', 2, 2, 2);

-- Inserting data into the "medical_record_medication" table
INSERT INTO "medical_record_medication" ("medical_record_id", "medication_id")
VALUES
  (1, 1), -- Lisinopril for the first medical record
  (2, 2); -- Metformin for the second medical record
