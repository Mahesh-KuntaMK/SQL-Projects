-- creating the student table 
CREATE TABLE students (
student_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50),
last_name VARCHAR(50),
date_of_birth DATE,
gender VARCHAR(10),
email varchar(100)
);
SELECT * FROM students;
-- creating the no of subjects table
CREATE TABLE subjects (
subject_id INT PRIMARY KEY AUTO_INCREMENT,
subject_name VARCHAR(100),
credit_hours INT
);
DROP TABLE STUDENTS;
SELECT * FROM subjects;
-- creating the  semester table for particular tablespace
CREATE TABLE semesters(
semester_id INT PRIMARY KEY AUTO_INCREMENT,
semester_name VARCHAR(50),
start_date DATE,
end_date DATE
);
SELECT * FROM semesters;
/* CREATING THE GRADES TABLE FOR STUDENTS GOT GRADES FOR SUBJECTS AND SEMSESTERS 
and creating foreign keys to their references tables*/

CREATE TABLE  Grades(
 grade_id INT PRIMARY KEY AUTO_INCREMENT ,
 student_id INT,
 subject_id INT,
 semester_id INT,
 grades VARCHAR(2),
 FOREIGN KEY(student_id) REFERENCES Students(student_id),
 FOREIGN KEY(subject_id) REFERENCES subjects(subject_id),
 FOREIGN KEY(semester_id) REFERENCES semesters(semester_id)
);
SELECT * FROM grades;
DROP TABLE grades;
-- all the required tables and thier fields created according to our requirements now it time as insert the data
-- Insert data into Students table
INSERT INTO Students (first_name, last_name, date_of_birth, gender, email) VALUES
('Mahesh', 'kunta', '1999-05-08', 'Male', 'maheshkunta@gmail.com'),
('Mohan', 'Rao', '2000-01-07', 'Male', 'mohanrao@gmail.com'),
('Karthik', 'nallakuntla', '1999-11-25', 'Male', 'karthikrao@gmail.com');

-- Insert data into Subjects table
INSERT INTO Subjects (subject_name, credit_hours) VALUES
('Mathematics', 3),
('Physics', 4),
('Chemistry', 3);


-- Insert data into Semesters table
INSERT INTO Semesters (semester_name, start_date, end_date) VALUES
('sem1', '2015-07-01', '2015-12-01'),
('sem2', '2015-12-01', '2016-05-01');

-- Insert data into Grades table
INSERT INTO Grades (student_id, subject_id, semester_id, grades) VALUES
(1, 1, 1, 'A'),
(1, 2, 1, 'B'),
(1, 3, 1, 'A'),
(2, 1, 1, 'B'),
(2, 2, 1, 'A'),
(2, 3, 1, 'C'),
(3, 2, 1, 'A'),
(3, 1, 1, 'A'),
(3, 3, 1, 'A');
select * from grades;

-- showing each student grades along with name and its grades and semester,subject 
SELECT s.first_name,s.last_name,sem.semester_name,sub.subject_name,g.grades
FROM students as s
JOIN GRADES AS g on g.student_id=s.student_id
JOIN subjects AS sub ON sub.subject_id=g.subject_id
JOIN semesters As sem on sem.semester_id=g.semester_id;

-- this below code for any particular stutudent with thier id
SELECT s.first_name,s.last_name,sem.semester_name,sub.subject_name,g.grades
FROM students as s
JOIN GRADES AS g on g.student_id=s.student_id
JOIN subjects AS sub ON sub.subject_id=g.subject_id
JOIN semesters As sem on sem.semester_id=g.semester_id
where s.student_id='1';

-- here below we will calculate the cgpa of students with a=10,b=9,c=8,d=7,e=6,f=0

-- creating a table for grades to assign value that is points

CREATE TABLE gradepoints(
grades VARCHAR(2),
points INT
);

Truncate gradepoints;

INSERT INTO Gradepoints (grades, points) VALUES
('A', 10),
('B', 9),
('C', 8),
('D', 7),
('F', 0);

select * from gradepoints;

-- lets calculate the each student cgpa

SELECT s.student_id,s.first_name,s.last_name,round(AVG(gp.points),2) AS cgpa
FROM students AS s
JOIN grades AS g ON s.student_id=g.student_id
JOIN gradepoints AS gp ON g.grades=gp.grades
GROUP BY s.student_id;


-- now lets find who is top performer i.e, school topper

SELECT s.student_id,s.first_name,s.last_name,round(AVG(gp.points),2) AS cgpa
FROM students AS s
JOIN grades AS g ON s.student_id=g.student_id
JOIN gradepoints AS gp ON g.grades=gp.grades 
GROUP BY s.student_id
HAVING AVG(gp.points)=(SELECT max(avgcgpa)
					FROM(
					SELECT AVG(gp.points) AS avgcgpa
					FROM grades AS g
                    JOIN gradepoints AS gp ON gp.grades=g.grades 
                    GROUP BY g.student_id 
                    ) AS maxavg
                    );
                    
                    
-- this gives the toppers particular semester

SELECT s.first_name, s.last_name, 
       ROUND(AVG(gp.points), 2) AS GPA
FROM Grades g
JOIN Students s ON g.student_id = s.student_id
JOIN GradePoints gp ON g.grades = gp.grades
JOIN Semesters sem ON g.semester_id = sem.semester_id
WHERE sem.semester_name = 'sem1'
GROUP BY s.student_id
ORDER BY GPA DESC;

-- Lets use some views here to see students cgpa
CREATE VIEW Studentcgpa AS
SELECT s.first_name, s.last_name, 
       ROUND(AVG(gp.points), 2) AS GPA
FROM Grades g
JOIN Students s ON g.student_id = s.student_id
JOIN Gradepoints gp ON g.grades = gp.grades
GROUP BY s.student_id;




                    
                    
	












 