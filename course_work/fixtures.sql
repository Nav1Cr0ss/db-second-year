INSERT INTO "user_users" ("first_name", "last_name", "date_of_birth", "address", "phone", "email", "role", "date_added")
VALUES ('John', 'Doe', '1990-05-15', '123 Main St', '555-1234', 'john.doe@example.com', 'applicant', NOW()),
       ('Jane', 'Smith', '1988-08-21', '456 Oak St', '555-5678', 'jane.smith@example.com', 'applicant', NOW()),
       ('Bob', 'Johnson', '1995-03-10', '789 Pine St', '555-9876', 'bob.johnson@example.com', 'applicant', NOW());

INSERT INTO "user_permissions" ("codename", "title")
VALUES ('view', 'View Access'),
       ('edit', 'Edit Access'),
       ('approve', 'Approval Access');

INSERT INTO "user_user_permissions" ("user_id", "permission_id")
VALUES (1, 1),
       (2, 2),
       (3, 3);

INSERT INTO "file_documents" ("user_id", "title", "category", "file_url", "date_added")
VALUES (1, 'High School Transcript', 'Education', '/files/transcript.pdf', NOW()),
       (2, 'Letter of Recommendation', 'Reference', '/files/recommendation.pdf', NOW()),
       (3, 'Resume', 'Resume', '/files/resume.pdf', NOW());

INSERT INTO "education_faculty" ("codename", "title")
VALUES ('eng', 'Engineering'),
       ('bus', 'Business'),
       ('sci', 'Science');

INSERT INTO "education_program" ("faculty_id", "codename", "title")
VALUES (1, 'cs', 'Computer Science'),
       (2, 'mgmt', 'Management'),
       (3, 'bio', 'Biology');

INSERT INTO "education_subjects" ("title")
VALUES ('Mathematics'),
       ('Marketing'),
       ('Biology');

INSERT INTO "education_subject_rules" ("subject_id", "program_id", "min_score", "is_required", "modifier_percent")
VALUES (1, 1, 80, true, 1),
       (2, 1, 70, true, 0.9),
       (3, 1, 75, true, 0.8),
       (1, 2, 80, true, 1),
       (2, 2, 70, true, 0.9),
       (3, 2, 75, true, 0.8),
       (1, 3, 80, true, 1),
       (2, 3, 70, true, 0.9),
       (3, 3, 75, true, 0.8);

INSERT INTO "application_applications" ("user_id", "status", "date_added")
VALUES (1, 'pending', NOW()),
       (2, 'approved', NOW()),
       (3, 'pending', NOW());

INSERT INTO "application_scores" ("application_id", "subject_id", "score")
VALUES (1, 1, 85),
       (1, 2, 75),
       (1, 3, 80),
       (2, 1, 90),
       (2, 2, 85),
       (2, 3, 88),
       (3, 1, 78),
       (3, 2, 65),
       (3, 3, 70);

INSERT INTO "application_application_programs" ("application_id", "program_id", "priority")
VALUES (1, 1, 1),
       (2, 2, 1),
       (3, 3, 1);

INSERT INTO "application_application_documents" ("application_id", "document_id")
VALUES (1, 1),
       (2, 2),
       (3, 3);

