CREATE TABLE "user" (
  "id" SERIAL PRIMARY KEY,
  "last_name" varchar(255),
  "first_name" varchar(255),
  "date_of_birth" date,
  "address" text,
  "phone" varchar(15),
  "email" varchar(255) UNIQUE,
  "password" varchar(255)
);

CREATE TABLE "patient" (
  "id" SERIAL PRIMARY KEY,
  "user_id" int REFERENCES "user" ("id")
);

CREATE TABLE "doctor" (
  "id" SERIAL PRIMARY KEY,
  "user_id" int REFERENCES "user" ("id")
);

CREATE TABLE "diagnosis" (
  "id" SERIAL PRIMARY KEY,
  "user_id" int REFERENCES "user" ("id"),
  "name" varchar(255),
  "type" varchar(255),
  "description" text
);

CREATE TABLE "medication" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar(255),
  "form" varchar(255),
  "description" text
);

CREATE TABLE "medical_record" (
  "id" SERIAL PRIMARY KEY,
  "date" date,
  "symptoms" text,
  "prescribed_treatment" text,
  "doctor_examination" text,
  "patient_id" int REFERENCES "patient" ("id"),
  "doctor_id" int REFERENCES "doctor" ("id"),
  "diagnosis_id" int REFERENCES "diagnosis" ("id")
);

CREATE TABLE "medical_record_medication" (
  "medical_record_id" int,
  "medication_id" int,
  PRIMARY KEY ("medical_record_id", "medication_id")
);

ALTER TABLE "medical_record_medication" ADD FOREIGN KEY ("medical_record_id") REFERENCES "medical_record" ("id");
ALTER TABLE "medical_record_medication" ADD FOREIGN KEY ("medication_id") REFERENCES "medication" ("id");


ALTER TABLE "user" ADD "insurance_number" varchar(20);

ALTER TABLE "user"
    ALTER COLUMN "phone" TYPE varchar(20);

ALTER TABLE "medication"
    ALTER COLUMN "description" TYPE text;
