CREATE TYPE user_role AS ENUM (
    'applicant',
    'facility_member',
    'program_member'
    );

CREATE TYPE application_status AS ENUM (
    'pending',
    'approved',
    'rejected'
    );

CREATE TABLE "user_users"
(
    "id"            SERIAL PRIMARY KEY,
    "first_name"    varchar   NOT NULL,
    "last_name"     varchar   NOT NULL,
    "date_of_birth" date,
    "address"       varchar   NOT NULL,
    "phone"         varchar   NOT NULL,
    "email"         varchar   NOT NULL,
    "role"          user_role NOT NULL,
    "date_added"    timestamp NOT NULL,
    "date_updated"  timestamp DEFAULT (now())
);

CREATE TABLE "user_permissions"
(
    "id"       SERIAL PRIMARY KEY,
    "codename" varchar NOT NULL,
    "title"    varchar NOT NULL
);

CREATE TABLE "user_user_permissions"
(
    "id"            SERIAL PRIMARY KEY,
    "user_id"       int NOT NULL,
    "permission_id" int NOT NULL
);

CREATE TABLE "file_documents"
(
    "id"           SERIAL PRIMARY KEY,
    "user_id"      int       NOT NULL,
    "title"        varchar   NOT NULL,
    "category"     varchar   NOT NULL,
    "file_url"     varchar   NOT NULL,
    "date_added"   timestamp NOT NULL,
    "date_updated" timestamp DEFAULT (now())
);

CREATE TABLE "education_faculty"
(
    "id"       SERIAL PRIMARY KEY,
    "codename" varchar NOT NULL,
    "title"    varchar NOT NULL
);

CREATE TABLE "education_program"
(
    "id"         SERIAL PRIMARY KEY,
    "faculty_id" int     NOT NULL,
    "codename"   varchar NOT NULL,
    "title"      varchar NOT NULL
);

CREATE TABLE "education_subjects"
(
    "id"    SERIAL PRIMARY KEY,
    "title" varchar NOT NULL
);

CREATE TABLE "education_subject_rules"
(
    "id"               SERIAL PRIMARY KEY,
    "program_id"       int NOT NULL,
    "subject_id"       int NOT NULL,
    "min_score"        int   DEFAULT 0,
    "is_required"      bool  DEFAULT true,
    "modifier_percent" float DEFAULT 1.0
);


CREATE TABLE "application_applications"
(
    "id"           SERIAL PRIMARY KEY,
    "user_id"      int       NOT NULL,
    "status"       application_status DEFAULT 'pending'::application_status,
    "date_added"   timestamp NOT NULL,
    "date_updated" timestamp          DEFAULT (now())
);

CREATE TABLE "application_scores"
(
    "id"             SERIAL PRIMARY KEY,
    "application_id" int NOT NULL,
    "subject_id"     int NOT NULL,
    "score"          int DEFAULT 0
);

CREATE TABLE "application_application_programs"
(
    "id"             SERIAL PRIMARY KEY,
    "application_id" int NOT NULL,
    "program_id"     int NOT NULL,
    "priority"       int DEFAULT 1
);

CREATE TABLE "application_application_documents"
(
    "id"             SERIAL PRIMARY KEY,
    "application_id" int NOT NULL,
    "document_id"    int NOT NULL
);


-- PK

ALTER TABLE "user_user_permissions"
    ADD FOREIGN KEY ("user_id") REFERENCES "user_users" ("id");

ALTER TABLE "user_user_permissions"
    ADD FOREIGN KEY ("permission_id") REFERENCES "user_permissions" ("id");

ALTER TABLE "file_documents"
    ADD FOREIGN KEY ("user_id") REFERENCES "user_users" ("id");

ALTER TABLE "education_program"
    ADD FOREIGN KEY ("faculty_id") REFERENCES "education_faculty" ("id");

ALTER TABLE "education_subject_rules"
    ADD FOREIGN KEY ("program_id") REFERENCES "education_program" ("id"),
    ADD FOREIGN KEY ("subject_id") REFERENCES "education_subjects" ("id");

ALTER TABLE "application_applications"
    ADD FOREIGN KEY ("user_id") REFERENCES "user_users" ("id");

ALTER TABLE "application_scores"
    ADD FOREIGN KEY ("application_id") REFERENCES "application_applications" ("id");

ALTER TABLE "application_scores"
    ADD FOREIGN KEY ("subject_id") REFERENCES "education_subjects" ("id");

ALTER TABLE "application_application_programs"
    ADD FOREIGN KEY ("application_id") REFERENCES "application_applications" ("id");

ALTER TABLE "application_application_programs"
    ADD FOREIGN KEY ("program_id") REFERENCES "education_program" ("id");

ALTER TABLE "application_application_documents"
    ADD FOREIGN KEY ("application_id") REFERENCES "application_applications" ("id");

ALTER TABLE "application_application_documents"
    ADD FOREIGN KEY ("document_id") REFERENCES "file_documents" ("id");


-- IDX

CREATE INDEX idx_user_users_email ON user_users (email);

CREATE INDEX idx_education_program_faculty_id ON education_program (faculty_id);
CREATE INDEX idx_education_program_title_id ON education_program (title);

CREATE INDEX idx_application_applications_date_added ON application_applications (date_added);

CREATE INDEX idx_application_scores_application_id ON application_scores (application_id);
CREATE INDEX idx_application_scores_subject_id ON application_scores (subject_id);


-- Distinct

ALTER TABLE "application_scores"
    ADD CONSTRAINT unique_application_subject
        UNIQUE ("application_id", "subject_id");

ALTER TABLE "application_applications"
    ADD CONSTRAINT unique_user_applications
        UNIQUE ("user_id");

ALTER TABLE "application_application_programs"
    ADD CONSTRAINT unique_application_program
        UNIQUE ("application_id", "program_id");

-- VIEWS


CREATE VIEW applicant_view AS
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

CREATE VIEW facility_member_view AS
SELECT u.id, u.first_name, u.last_name, u.date_of_birth, u.email, f.title AS faculty, p.title AS program
FROM "user_users" AS u
         LEFT JOIN "education_program" AS p ON u.id = p.faculty_id
         LEFT JOIN "education_faculty" AS f ON p.faculty_id = f.id
WHERE u.role = 'facility_member';

CREATE VIEW program_member_view AS
SELECT u.id, u.first_name, u.last_name, u.date_of_birth, u.email, p.title AS program
FROM "user_users" AS u
         LEFT JOIN "education_program" AS p ON u.id = p.faculty_id
WHERE u.role = 'program_member';

-- TRIGGERS and FUNCTIONS

CREATE OR REPLACE FUNCTION set_date_added()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.date_added = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_set_date_added
    BEFORE INSERT
    ON "user_users"
    FOR EACH ROW
EXECUTE FUNCTION set_date_added();

CREATE TRIGGER documents_set_date_added
    BEFORE INSERT
    ON "file_documents"
    FOR EACH ROW
EXECUTE FUNCTION set_date_added();

CREATE TRIGGER applications_set_date_added
    BEFORE INSERT
    ON "application_applications"
    FOR EACH ROW
EXECUTE FUNCTION set_date_added();



