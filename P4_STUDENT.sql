CREATE TABLE STUDENTS(
USN VARCHAR(10) PRIMARY KEY,
SNAME VARCHAR(20),
ADDRESS VARCHAR(20),
PHONE NUMBER(10),
GENDER VARCHAR(10)
);

INSERT INTO STUDENTS VALUES('4SF15CS001','RANJITH','MANGALORE',9514785236,'M');
INSERT INTO STUDENTS VALUES('1BI15CS101','ROHITH','MANGALORE',9865475821,'M');
INSERT INTO STUDENTS VALUES('4SF15CS101','SURAJ','MANGALORE',9159826473,'M');
INSERT INTO STUDENTS VALUES('4SF15CS102','SAANVI','MANGALORE',9147413659,'F');
INSERT INTO STUDENTS VALUES('4SF15CS103','DEETHVI','MANGALORE',9731658240,'F');
SELECT * FROM STUDENTS;


CREATE TABLE SEMSEC(
SSID NUMBER(5) PRIMARY KEY,
SEM NUMBER(2),
SECTION VARCHAR(1));

INSERT INTO SEMSEC VALUES(1,5,'A');
INSERT INTO SEMSEC VALUES(2,4,'C');
INSERT INTO SEMSEC VALUES(3,8,'C');
INSERT INTO SEMSEC VALUES(4,8,'A');
INSERT INTO SEMSEC VALUES(5,8,'B');
INSERT INTO SEMSEC VALUES(6,8,'C');
SELECT * FROM SEMSEC;

CREATE TABLE CLASSES(
SSID REFERENCES SEMSEC ON DELETE CASCADE,
USN  REFERENCES STUDENTS ON DELETE CASCADE,
PRIMARY KEY (SSID,USN)
);

INSERT INTO CLASSES VALUES(1,'4SF15CS103');
INSERT INTO CLASSES VALUES(2,'4SF15CS101');
INSERT INTO CLASSES VALUES(3,'4SF15CS102');
INSERT INTO CLASSES VALUES(3,'1BI15CS101');
INSERT INTO CLASSES VALUES(4,'1BI15CS101');
INSERT INTO CLASSES VALUES(5,'4SF15CS102');
SELECT * FROM CLASSES;

CREATE TABLE SUBJECT(
SUBCODE VARCHAR(5) PRIMARY KEY,
TITLE VARCHAR(20),
SEM NUMBER(4),
CREDIT NUMBER(2)
);

INSERT INTO SUBJECT VALUES(1551,'ME',5,5);
INSERT INTO SUBJECT VALUES(1552,'DBMS',5,5);
INSERT INTO SUBJECT VALUES(1583,'ST',8,5);
INSERT INTO SUBJECT VALUES(1582,'SMS',8,5);
INSERT INTO SUBJECT VALUES(1542,'OOC',4,5);
SELECT * FROM SUBJECT;

CREATE TABLE IAMARKS(
USN REFERENCES STUDENTS ON DELETE CASCADE,
SUBCODE REFERENCES SUBJECT ON DELETE CASCADE,
SSID REFERENCES SEMSEC ON DELETE CASCADE,
TEST1 NUMBER(3),
TEST2 NUMBER(3),
TEST3 NUMBER(3),
FINALIA NUMBER(3),
PRIMARY KEY(USN,SUBCODE,SSID)
);

INSERT INTO IAMARKS VALUES('4SF15CS101',1551,1,12,12,15,0);
INSERT INTO IAMARKS VALUES('1BI15CS101',1552,1,12,12,15,0);
INSERT INTO IAMARKS VALUES('4SF15CS102',1583,1,12,12,15,0);
INSERT INTO IAMARKS VALUES('4SF15CS103',1582,1,12,12,15,0);
INSERT INTO IAMARKS VALUES('4SF15CS103',1583,4,12,14,15,0);
SELECT * FROM IAMARKS;

--1. List all students of 4th Sem 'C' section
SELECT * FROM STUDENTS WHERE USN IN (
SELECT USN FROM CLASSES WHERE SSID IN (
SELECT SSID FROM SEMSEC WHERE SEM=4 AND SECTION='C')
);

--2. List TotalStrength for SEM/SECTION for M/F
SELECT COUNT(*) "TOTAL" ,SEM,SECTION,GENDER FROM 
STUDENTS S , SEMSEC SS , CLASSES C
WHERE S.USN=C.USN AND SS.SSID=C.SSID
GROUP BY (GENDER,SEM,SECTION)
ORDER BY (SEM);

--3. Create VIEW of Test1 - 1BI15CS101 in all subjects
CREATE VIEW STUDENT_VIEW AS 
SELECT USN,SUBCODE,TEST1 FROM IAMARKS WHERE USN='1BI15CS101';

SELECT * FROM STUDENT_VIEW;

--4. Calculate FINALIA (Average of best 2)
UPDATE IAMARKS SET FINALIA=GREATEST((TEST1+TEST2),(TEST2+TEST3),(TEST1+TEST3))/2;
SELECT * FROM IAMARKS;


--5. Categorize students OUTSTANDING/AVERAGE/WEAK for 8th A,B,C students
SELECT USN,FINALIA,
CASE  
WHEN FINALIA BETWEEN 17 AND 20 THEN 'OUTSTANDING'
WHEN FINALIA BETWEEN 12 AND 16 THEN 'AVERAGE'
WHEN FINALIA <12 THEN 'WEAK'
END "CATEGORY"
FROM IAMARKS I , SEMSEC SS WHERE
I.SSID=SS.SSID AND SEM=8 AND SECTION IN('A','B','C');