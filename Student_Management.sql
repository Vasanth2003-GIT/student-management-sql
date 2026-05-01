-- Create Tables
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50)
);

CREATE TABLE Marks (
    mark_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    marks INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Insert Data
INSERT INTO Students VALUES
(1, 'Vasanth', 'ECE'),
(2, 'Arun', 'CSE'),
(3, 'vicky', 'IT');

TO GET OUTPUT:

--JOIN: Get student name, course, and marks

SELECT s.name, c.course_name, m.marks
FROM Students s
JOIN Marks m ON s.student_id = m.student_id
JOIN Courses c ON m.course_id = c.course_id;


 -- GROUP BY: Average marks per student
 
SELECT student_id, AVG(marks) AS avg_marks
FROM Marks
GROUP BY student_id;


 -- Top student based on total marks
 
SELECT s.name, SUM(m.marks) AS total_marks
FROM Students s
JOIN Marks m ON s.student_id = m.student_id
GROUP BY s.name
ORDER BY total_marks DESC;
