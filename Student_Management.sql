-- CREATE SEQUENCES:

CREATE SEQUENCE student_seq  START WITH 1  INCREMENT BY 1;
CREATE SEQUENCE course_seq   START WITH 101 INCREMENT BY 1;
CREATE SEQUENCE marks_seq    START WITH 1001 INCREMENT BY 1;

--CREATE TABLES  (with CONSTRAINTS):

-- TABLE 1 : Students
CREATE TABLE Students (
    student_id   NUMBER        PRIMARY KEY,          
    student_name VARCHAR2(100) NOT NULL,           
    department   VARCHAR2(50)  NOT NULL,             
    email        VARCHAR2(100) UNIQUE,               
    join_year    NUMBER(4)     CHECK                                     
);

-- TABLE 2 : Courses
CREATE TABLE Courses (
    course_id    NUMBER        PRIMARY KEY,
    course_name  VARCHAR2(100) NOT NULL,
    course_code  VARCHAR2(20)  UNIQUE  NOT NULL,     
    credits      NUMBER(1)     CHECK 
);

-- TABLE 3 : Marks 
CREATE TABLE Marks (
    mark_id      NUMBER        PRIMARY KEY,
    student_id   NUMBER        NOT NULL
                               REFERENCES Students(student_id) ON DELETE CASCADE,
    course_id    NUMBER        NOT NULL
                               REFERENCES Courses(course_id)  ON DELETE CASCADE,
    marks        NUMBER(5,2)   CHECK (marks BETWEEN 0 AND 100), 
    exam_date    DATE          DEFAULT SYSDATE,
    UNIQUE (student_id, course_id)              
);

-- INSERT DATA 

--Students :
INSERT INTO Students VALUES (student_seq.NEXTVAL, 'Vasanth B',    'ECE', 'vasanth@mail.com',    2021);
INSERT INTO Students VALUES (student_seq.NEXTVAL, 'Arun Kumar',   'CSE', 'arun@mail.com',       2021);
INSERT INTO Students VALUES (student_seq.NEXTVAL, 'Priya R',      'ECE', 'priya@mail.com',      2021);
INSERT INTO Students VALUES (student_seq.NEXTVAL, 'Karthik S',    'IT',  'karthik@mail.com',    2022);
INSERT INTO Students VALUES (student_seq.NEXTVAL, 'Divya M',      'CSE', 'divya@mail.com',      2022);
INSERT INTO Students VALUES (student_seq.NEXTVAL, 'Ravi T',       'MECH','ravi@mail.com',       2021);
INSERT INTO Students VALUES (student_seq.NEXTVAL, 'Sneha P',      'IT',  'sneha@mail.com',      2022);
INSERT INTO Students VALUES (student_seq.NEXTVAL, 'Manoj L',      'ECE', 'manoj@mail.com',      2023);

--Courses :
INSERT INTO Courses VALUES (course_seq.NEXTVAL, 'Mathematics',         'MA101', 4);
INSERT INTO Courses VALUES (course_seq.NEXTVAL, 'Data Structures',     'CS102', 4);
INSERT INTO Courses VALUES (course_seq.NEXTVAL, 'Database Management', 'CS103', 3);
INSERT INTO Courses VALUES (course_seq.NEXTVAL, 'Physics',             'PH101', 3);
INSERT INTO Courses VALUES (course_seq.NEXTVAL, 'Python Programming',  'CS104', 3);

--Marks :
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 1, 101, 88.5,  TO_DATE('2024-11-10','YYYY-MM-DD'));
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 1, 102, 91.0,  TO_DATE('2024-11-12','YYYY-MM-DD'));
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 1, 103, 76.0,  TO_DATE('2024-11-14','YYYY-MM-DD'));
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 2, 101, 72.0,  TO_DATE('2024-11-10','YYYY-MM-DD'));
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 2, 102, 85.5,  TO_DATE('2024-11-12','YYYY-MM-DD'));
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 2, 105, 90.0,  TO_DATE('2024-11-16','YYYY-MM-DD'));
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 3, 101, 95.0,  TO_DATE('2024-11-10','YYYY-MM-DD'));
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 3, 103, 80.5,  TO_DATE('2024-11-14','YYYY-MM-DD'));
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 4, 102, 60.0,  TO_DATE('2024-11-12','YYYY-MM-DD'));
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 4, 104, 55.0,  TO_DATE('2024-11-15','YYYY-MM-DD'));
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 5, 101, 78.0,  TO_DATE('2024-11-10','YYYY-MM-DD'));
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 5, 105, 88.0,  TO_DATE('2024-11-16','YYYY-MM-DD'));
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 6, 104, 65.0,  TO_DATE('2024-11-15','YYYY-MM-DD'));
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 7, 102, 92.0,  TO_DATE('2024-11-12','YYYY-MM-DD'));
INSERT INTO Marks VALUES (marks_seq.NEXTVAL, 7, 103, 87.5,  TO_DATE('2024-11-14','YYYY-MM-DD'));

COMMIT; 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--TO GET DATA:

-- VIEWS -> Full student report (name + department + course + marks):

CREATE OR REPLACE VIEW vw_student_report AS
SELECT
    s.student_id,
    s.student_name,
    s.department,
    c.course_name,
    c.course_code,
    m.marks
FROM Students s
INNER JOIN Marks   m ON s.student_id = m.student_id   
INNER JOIN Courses c ON m.course_id  = c.course_id;


--  INNER JOIN -> Returns ONLY students who have marks registered (Manoj won't appear here because he has no marks)

SELECT
    s.student_name          AS "Student",
    s.department            AS "Dept",
    c.course_name           AS "Course",
    m.marks                 AS "Marks"
FROM   Students s
INNER JOIN Marks   m ON s.student_id = m.student_id
INNER JOIN Courses c ON m.course_id  = c.course_id
ORDER BY s.student_name, c.course_name;


-- LEFT JOIN -> Returns ALL students, even those with NO marks (Manoj will appear with NULL in the marks column.)

SELECT
    s.student_name          AS "Student",
    s.department            AS "Dept",
    c.course_name           AS "Course",
    NVL(TO_CHAR(m.marks),'Not Enrolled') AS "Marks"
FROM   Students s
LEFT JOIN Marks   m ON s.student_id = m.student_id
LEFT JOIN Courses c ON m.course_id  = c.course_id
ORDER BY s.student_name;


-- GROUP BY + HAVING + AGGREGATE FUNCTIONS (Departments where average mark is ABOVE 75)

SELECT
    s.department             AS "Department",
    ROUND(AVG(m.marks), 2)  AS "Average Marks"
FROM   Students s
JOIN   Marks m ON s.student_id = m.student_id
GROUP BY s.department
HAVING AVG(m.marks) > 75      
ORDER BY AVG(m.marks) DESC;
