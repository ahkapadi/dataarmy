/* DROPPING TABLES */

DROP TABLE Educator2
DROP TABLE Student2
DROP TABLE Course2
DROP TABLE TimeSlot2
DROP TABLE EducatorCourseSchedule2
DROP TABLE Registration2
DROP TABLE Professor2
DROP TABLE Rating2
DROP TABLE RecommendationScore2



/* CREATING TABLES */

CREATE TABLE Educator2(						-- Defining Table Name
EducatorID CHAR(10) NOT NULL PRIMARY KEY,				-- Declaring Variable, NOT NULL = Mandatory Input
EFName VARCHAR(30) NOT NULL,
ELName VARCHAR(30) NOT NULL,
EPhNo VARCHAR(30) NOT NULL,
EEmail VARCHAR(30) NOT NULL,
GPA FLOAT CHECK (GPA>=3) NOT NULL,
);

CREATE TABLE Student2(						-- Defining Table Name
StudentID CHAR(10) NOT NULL PRIMARY KEY,				-- Declaring Variable, NOT NULL = Mandatory InputSEFName VARCHAR(30) NOT NULL,
SFName VARCHAR(30) NOT NULL,
SLName VARCHAR(30) NOT NULL,
SEmail VARCHAR(30) NOT NULL,
);

CREATE TABLE Course2(
CourseID CHAR(10) NOT NULL PRIMARY KEY,
CourseName VARCHAR(30) NOT NULL,

CONSTRAINT Course2isCHK1 CHECK (CourseID = 'C01' OR CourseID = 'C02' OR CourseID = 'C03' OR CourseID = 'C04' OR CourseID = 'C05' 
OR CourseID = 'C06' OR CourseID = 'C07' OR CourseID = 'C08' OR CourseID = 'C09' OR CourseID = 'C10')
);

CREATE TABLE TimeSlot2(
TimeSlotID CHAR(10) NOT NULL PRIMARY KEY,
SlotDay CHAR(3) NOT NULL CHECK (SlotDay = 'Mon' OR SlotDay = 'Tue' OR SlotDay = 'Wed' OR SlotDay = 'Thu' OR SlotDay = 'Fri'),
SlotTime VARCHAR(30) NOT NULL CHECK (SlotTime = '9am - 12pm'OR SlotTime = '1pm - 4pm' OR SlotTime = '5pm - 8pm')
);

CREATE TABLE EducatorCourseSchedule2(
EducatorCourseScheduleID CHAR(10) NOT NULL PRIMARY KEY,
EducatorID CHAR(10) NOT NULL,
CourseID CHAR(10) NOT NULL,			-- Educator must be registered for at least one Course
TimeSlotID CHAR(10) NOT NULL,		-- Educator must be registered for at least one Time Slot
Grade CHAR (2) NOT NULL CHECK (Grade = 'A' OR Grade = 'A-')

CONSTRAINT EducatorCourseSchedule2isFKEY1 FOREIGN KEY (EducatorID) REFERENCES Educator2(EducatorID),
CONSTRAINT EducatorCourseSchedule2isFKEY2 FOREIGN KEY (CourseID) REFERENCES Course2(CourseID),
CONSTRAINT EducatorCourseSchedule2isFKEY3 FOREIGN KEY (TimeSlotID) REFERENCES TimeSlot2(TimeSlotID),
CONSTRAINT EducatorCourseSchedule2isUNIQ1 UNIQUE (EducatorID, CourseID),
);

CREATE TABLE Registration2(
RegistrationID CHAR(10) NOT NULL PRIMARY KEY,
StudentID CHAR(10) NOT NULL,
EducatorCourseScheduleID CHAR(10) NOT NULL,

CONSTRAINT Registration2isFKEY1 FOREIGN KEY (EducatorCourseScheduleID) REFERENCES EducatorCourseSchedule2(EducatorCourseScheduleID),
CONSTRAINT Registration2isFKEY2 FOREIGN KEY (StudentID) REFERENCES Student2(StudentID),
CONSTRAINT Registration2isUNIQ1 UNIQUE (StudentID, EducatorCourseScheduleID),
);

CREATE TABLE Professor2(
ProfessorID CHAR(10) NOT NULL PRIMARY KEY,
PFName VARCHAR(30) NOT NULL,
PLName VARCHAR(30) NOT NULL,
);

CREATE TABLE Rating2(
RatingID CHAR(10) NOT NULL PRIMARY KEY,
RegistrationID CHAR(10) NOT NULL,
--StudentID CHAR(10) NOT NULL,
--EducatorID CHAR(10) NOT NULL,
--CourseID CHAR(10) NOT NULL,
Rating INT,

--CONSTRAINT Rating2isFKEY1 FOREIGN KEY (StudentID) REFERENCES Student2(StudentID),
--CONSTRAINT Rating2isFKEY2 FOREIGN KEY (EducatorID) REFERENCES Educator2(EducatorID),
--CONSTRAINT Rating2isFKEY3 FOREIGN KEY (CourseID) REFERENCES Course2(CourseID),
CONSTRAINT Rating2isFKEY1 FOREIGN KEY (RegistrationID) REFERENCES Registration2(RegistrationID),
CONSTRAINT Rating2isCHK1 CHECK (Rating>=0 AND Rating<=5),
);

CREATE TABLE RecommendationScore2(
ScoreID CHAR(10) NOT NULL PRIMARY KEY,
ProfessorID CHAR(10) NOT NULL,
EducatorID CHAR(10) NOT NULL,
Score INT,

CONSTRAINT RecommendationScore2isFKEY1 FOREIGN KEY (ProfessorID) REFERENCES Professor2(ProfessorID),
CONSTRAINT RecommendationScore2isFKEY2 FOREIGN KEY (EducatorID) REFERENCES Educator2(EducatorID),
CONSTRAINT RecommendationScore2isCHK1 CHECK (Score>=0 AND Score<=5),
CONSTRAINT RecommendationScore2isUNIQ1 UNIQUE (ProfessorID, EducatorID),
);


/* POPULATING TABLES */

INSERT INTO Educator2
VALUES ('E01', 'John', 'Smith', '111-111-1111', 'johnsmith@sky.edu', '3.7');
INSERT INTO Educator2
VALUES ('E02', 'Megan', 'Cook', '222-222-2222', 'megancook@sky.edu', '3.5');
INSERT INTO Educator2
VALUES ('E03', 'Daniel', 'Taylor', '333-333-3333', 'danieltaylor@sky.edu', '3.8');
INSERT INTO Educator2
VALUES ('E04', 'Roger', 'Nadal', '444-444-4444', 'rogernadal@sky.edu', '3.2');
INSERT INTO Educator2
VALUES ('E05', 'Angela', 'Mathews', '555-555-5555', 'angelamathews@sky.edu', '3.4');
INSERT INTO Educator2
VALUES ('E06', 'Jennifer', 'Harrison', '666-666-6666', 'jenniferharrison@sky.edu', '3.1');
INSERT INTO Educator2
VALUES ('E07', 'Steve', 'Waugh', '777-777-7777', 'stevewaugh@sky.edu', '3.4');
INSERT INTO Educator2
VALUES ('E08', 'Henry', 'Oswald', '888-888-8888', 'henryoswald@sky.edu', '3.3');
INSERT INTO Educator2
VALUES ('E09', 'Bob', 'Kepler', '999-999-9999', 'bobkepler@sky.edu', '3.2');
INSERT INTO Educator2
VALUES ('E10', 'Fred', 'Mercury', '000-000-0000', 'fredmercury@sky.edu', '3.4');

SELECT * FROM Educator2;

INSERT INTO Student2 (StudentID, SFName, SLName, SEmail)
VALUES ('S01', 'Bill', 'Erikson', 'billerikson@sky.edu'),
	   ('S02', 'Lily', 'Jones', 'lilyjones@sky.edu'),
	   ('S03', 'Casie', 'Williams', 'casiewilliams@sky.edu'),
	   ('S04', 'Jack', 'Miller', 'jackmiller@sky.edu'),
	   ('S05', 'Xu', 'Ching', 'xuching@sky.edu'),
	   ('S06', 'Kim', 'Brown', 'kimbrown@sky.edu'),
	   ('S07', 'Christina', 'Wilson', 'christinewilson@sky.edu'),
	   ('S08', 'Mellissa', 'Johnson', 'mellissajohnson@sky.edu'),
	   ('S09', 'George', 'Davis', 'georgedavis@sky.edu'),
	   ('S10', 'Ronald', 'Pencer', 'ronaldpencer@sky.edu');

SELECT * FROM Student2;

INSERT INTO Course2 (CourseID, CourseName)
VALUES ('C01', 'Accounting'),
	   ('C02', 'Architecture'),
	   ('C03', 'Business Studies'),
	   ('C04', 'Chemistry'),
	   ('C05', 'History'),
	   ('C06', 'Law'),
	   ('C07', 'Robotics');

SELECT * FROM Course2;

INSERT INTO TimeSlot2(TimeSlotID, SlotDay, SlotTime)
VALUES ('TS01', 'Mon', '9am - 12pm'),
	   ('TS02', 'Mon', '1pm - 4pm'),
	   ('TS03', 'Mon', '5pm - 8pm'),
	   ('TS04', 'Tue', '9am - 12pm'),
	   ('TS05', 'Tue', '1pm - 4pm'),
	   ('TS06', 'Tue', '5pm - 8pm'),
	   ('TS07', 'Wed', '9am - 12pm'),
	   ('TS08', 'Wed', '1pm - 4pm'),
	   ('TS09', 'Wed', '5pm - 8pm'),
	   ('TS10', 'Thu', '9am - 12pm'),
	   ('TS11', 'Thu', '1pm - 4pm'),
	   ('TS12', 'Thu', '5pm - 8pm'),
	   ('TS13', 'Fri', '9am - 12pm'),
	   ('TS14', 'Fri', '1pm - 4pm'),
	   ('TS15', 'Fri', '5pm - 8pm');
	  
SELECT * FROM TimeSlot2;

INSERT INTO EducatorCourseSchedule2(EducatorCourseScheduleID, EducatorID, CourseID, TimeSlotID, Grade)
Values ('ECS01', 'E01', 'C01', 'TS01', 'A'),
	   ('ECS02', 'E02', 'C03', 'TS11', 'A'),
	   ('ECS03', 'E03', 'C03', 'TS03', 'A-'),
	   ('ECS04', 'E04', 'C05', 'TS04', 'A'),
	   ('ECS05', 'E05', 'C05', 'TS09', 'A-'),
	   ('ECS06', 'E06', 'C05', 'TS12', 'A'),
	   ('ECS07', 'E07', 'C06', 'TS15', 'A-'),
	   ('ECS08', 'E08', 'C07', 'TS13', 'A'),
	   ('ECS09', 'E09', 'C07', 'TS10', 'A-'),
	   ('ECS10', 'E10', 'C07', 'TS07', 'A-');

SELECT * FROM EducatorCourseSchedule2;

INSERT INTO Registration2 ( RegistrationID, StudentID, EducatorCourseScheduleID)
VALUES ('RG01', 'S01', 'ECS01'),
	   ('RG02', 'S01', 'ECS07'),
	   ('RG03', 'S01', 'ECS09'),
	   ('RG04', 'S02', 'ECS06'),
	   ('RG05', 'S02', 'ECS10'),
	   ('RG06', 'S03', 'ECS04'),
	   ('RG07', 'S04', 'ECS07'),
	   ('RG08', 'S04', 'ECS02'),
	   ('RG09', 'S05', 'ECS10'),
	   ('RG10', 'S06', 'ECS06'),
	   ('RG11', 'S08', 'ECS05'),
	   ('RG12', 'S10', 'ECS04'),
	   ('RG13', 'S07', 'ECS04'),
	   ('RG14', 'S07', 'ECS10'),
	   ('RG15', 'S05', 'ECS04');
	   
SELECT * FROM Registration2;

INSERT INTO Professor2 (ProfessorID, PFName, PLName)
VALUES ('P01', 'James', 'Steward'),
	   ('P02', 'Tim', 'Edward'),
	   ('P03', 'Will', 'Beckham'),
	   ('P04', 'Jared', 'Cruise');

SELECT * FROM Professor2;

INSERT INTO Rating2 (RatingID, RegistrationID, Rating)
VALUES ('RT01', 'RG01', '5'),
	   ('RT02', 'RG03', '4'),
	   ('RT03', 'RG05', '4'),
	   ('RT04', 'RG07', '3'),
	   ('RT05', 'RG11', '2'),
	   ('RT06', 'RG02', '1'),
	   ('RT07', 'RG13', '0'),
	   ('RT08', 'RG15', '1'),
	   ('RT09', 'RG04', '2'),
	   ('RT10', 'RG06', '5'),
	   ('RT11', 'RG08', '4'),
	   ('RT12', 'RG10', '3');

SELECT * FROM Rating2;

INSERT INTO RecommendationScore2(ScoreID, ProfessorID, EducatorID, Score)
VALUES ('S01', 'P01', 'E10', '5'),
	   ('S02', 'P01', 'E07', '3'),
	   ('S03', 'P02', 'E07', '4'),
	   ('S04', 'P03', 'E04', '4'),
	   ('S05', 'P04', 'E09', '2'),
	   ('S06', 'P04', 'E05', '4'),
	   ('S07', 'P03', 'E01', '5'),
	   ('S08', 'P02', 'E08', '3'),
	   ('S09', 'P02', 'E01', '4'),
	   ('S10', 'P01', 'E02', '5'),
	   ('S11', 'P03', 'E05', '5'),
	   ('S12', 'P04', 'E02', '3'),
	   ('S13', 'P02', 'E05', '2'),
	   ('S14', 'P02', 'E02', '1'),
	   ('S15', 'P03', 'E02', '3');

SELECT * FROM RecommendationScore2;

/* DATA QUESTIONS */

/* Find all the Educators whose GPA is 3.5 or more. Show the Educators' first name, last name, and GPA. */

SELECT EFName, ELName, GPA
FROM Educator2
WHERE GPA>=3.5;					/* CORRECT */


/* Find the Educator who has 'A' grade in the subject. Show the Educators' first name, last name, GPA */

SELECT e.EFName, e.ELName, e.GPA
FROM Educator2 AS e
JOIN EducatorCourseSchedule2 AS ecs ON ecs.EducatorID = e.EducatorID
WHERE Grade='A'																				/* CORRECT */


/*	Show the CourseID and Course Name of the courses that are being taught by more than one educator */

SELECT ecs.CourseID,  c.CourseName
FROM EducatorCourseSchedule2 AS ecs
JOIN Course2 AS c ON c.CourseID=ecs.CourseID
GROUP BY ecs.CourseID, c.CourseName
HAVING COUNT(ecs.CourseID) > 1																						/* CORRECT */

/* Find the Educators who have received two or more recommendations from the professors. Show Educators' First name, last name, and number of recommendations 
 received */

SELECT r.EducatorID,  e.EFName, e.ELName, COUNT(r.EducatorID) 'No. of Recommendations'
FROM RecommendationScore2 AS r
JOIN Educator2 AS e ON e.EducatorID=r.EducatorID
GROUP BY r.EducatorID,  e.EFName, e.ELName
HAVING COUNT(r.EducatorID) >= 2																						/* CORRECT */

/* Find the Professors who gave recommendations to Educator Megan Cook. Show their first names & last names */

SELECT r.ProfessorID, p.PFName, p.PLName
FROM RecommendationScore2 AS r
JOIN Professor2 AS p ON p.ProfessorID = r.ProfessorID
JOIN Educator2 AS e ON e.EducatorID = r.EducatorID
WHERE e.EFName = 'Megan' AND e.ELName = 'Cook'																		/* CORRECT */

/*	Find the educators who are offering help in History on Thursday 5pm to 8pm. Show the Educators' details */

SELECT ecs.EducatorID, e.EFName, e.ELName, e.EPhNo, e.EEmail, e.GPA
FROM EducatorCourseSchedule2 AS ecs
JOIN TimeSlot2 AS t ON t.TimeSlotID = ecs.TimeSlotID
JOIN Educator2 AS e ON e.EducatorID = ecs.EducatorID
WHERE SlotDay = 'Thu' AND SlotTime = '5pm - 8pm'																		/* CORRECT */


/* Calculate minimum, maximum, and average recommendation score for Educators and show them along with educator details */

SELECT r.EducatorID, e.EFName, e.ELName, e.EEmail,
MIN(Score) 'Minimum Recommendation Score',
MAX(Score) 'Minimum Recommendation Score',
AVG(Score) 'Average Recommendation Score'
FROM RecommendationScore2 AS r
JOIN Educator2 AS e ON e.EducatorID = r.EducatorID
GROUP BY r.EducatorID, e.EFName, e.ELName, e.EEmail
ORDER BY [Average Recommendation Score] DESC;																			/* CORRECT */
