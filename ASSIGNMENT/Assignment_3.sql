CREATE TABLE FLIGHT(
FLNO INT PRIMARY KEY,
FRM VARCHAR(20),
TOO VARCHAR(20),
DISTANCE INT,
DEPARTS VARCHAR(20),
ARRIVES VARCHAR(20),
PRICE REAL);
DELETE FROM FLIGHT;
INSERT INTO FLIGHT VALUES(1,'LONDON','DUBAI',1500,'10:30','12:00',23000);
INSERT INTO FLIGHT VALUES(7,'LOS ANGELES','HONOLULU',3500,'10:30','12:00',23000);
INSERT INTO FLIGHT VALUES(8,'LOS ANGELES','HONOLULU',3400,'11:30','13:00',22500);
INSERT INTO FLIGHT VALUES(2,'BANGLORE','FRANKFURT',3000,'12:30','14:00',13000);
INSERT INTO FLIGHT VALUES(3,'BANGLORE','DELHI',400,'10:30','12:00',20000);
INSERT INTO FLIGHT VALUES(4,'FRANKFURT','DELHI',2500,'10:30','12:00',50000);
INSERT INTO FLIGHT VALUES(5,'NAGALAND','MYSORE',850,'10:30','12:00',40000);
INSERT INTO FLIGHT VALUES(6,'FRANKFURT','BANGLORE',3000,'17:30','19:00',15000);
INSERT INTO FLIGHT VALUES(10,'LOS ANGELES','CHICAGO',4500,'17:30','19:00',85000);
DELETE FROM FLIGHT WHERE FLNO=9;
CREATE TABLE AIRCRAFT(
AID INT PRIMARY KEY,
ANAME VARCHAR(20),
CRUISINGRANGE INT);

INSERT INTO AIRCRAFT VALUES(200,'BOEING',1000);
INSERT INTO AIRCRAFT VALUES(201,'VISTARA',4000);
INSERT INTO AIRCRAFT VALUES(202,'SPICEJET',5000);
INSERT INTO AIRCRAFT VALUES(203,'INDIGO',8000);
INSERT INTO AIRCRAFT VALUES(204,'AIRBUS',6000);

CREATE TABLE AIRCRAFT_EMPLOYEE(
EID INT PRIMARY KEY,
ENAME VARCHAR(20),
ESALARY NUMBER(7)
);
INSERT INTO AIRCRAFT_EMPLOYEE VALUES(1,'ABHIJITH',100000);
INSERT INTO AIRCRAFT_EMPLOYEE VALUES(2,'RAMESH',150000);
INSERT INTO AIRCRAFT_EMPLOYEE VALUES(3,'SURESH',120000);
INSERT INTO AIRCRAFT_EMPLOYEE VALUES(4,'GANESH',95000);
INSERT INTO AIRCRAFT_EMPLOYEE VALUES(5,'UMESH',160000);
INSERT INTO AIRCRAFT_EMPLOYEE VALUES(6,'KAMLESH',170000);
INSERT INTO AIRCRAFT_EMPLOYEE VALUES(7,'RAJESH',2000);


CREATE TABLE CERTIFIED(
EID REFERENCES AIRCRAFT_EMPLOYEE ON DELETE CASCADE,
AID REFERENCES AIRCRAFT ON DELETE CASCADE,
PRIMARY KEY(EID,AID));

INSERT INTO CERTIFIED VALUES(7,200);
INSERT INTO CERTIFIED VALUES(7,202);
INSERT INTO CERTIFIED VALUES(7,201);

INSERT INTO CERTIFIED VALUES(1,200);
INSERT INTO CERTIFIED VALUES(1,201);
INSERT INTO CERTIFIED VALUES(1,203);
INSERT INTO CERTIFIED VALUES(2,200);
INSERT INTO CERTIFIED VALUES(3,200);
INSERT INTO CERTIFIED VALUES(4,200);
INSERT INTO CERTIFIED VALUES(1,204);
INSERT INTO CERTIFIED VALUES(2,202);
INSERT INTO CERTIFIED VALUES(4,202);
INSERT INTO CERTIFIED VALUES(5,200);


SELECT * FROM CERTIFIED;
SELECT * FROM AIRCRAFT_EMPLOYEE;
SELECT * FROM FLIGHT;
SELECT * FROM AIRCRAFT;

--1.Find the names of aircraft such that all pilots certified to operate them have salaries more than $80,000.
SELECT ANAME FROM AIRCRAFT WHERE AID IN( SELECT AID FROM CERTIFIED WHERE EID IN(SELECT EID FROM AIRCRAFT_EMPLOYEE WHERE ESALARY>80000));

--2. For each pilot who is certified for more than three aircraft, find the eid and the maximum cruising range of the aircraft for which she or he is certified

--SELECT AID FROM CERTIFIED GROUP BY(AID) HAVING COUNT(*)>=3 ; 
--SELECT EID FROM CERTIFIED GROUP BY(AID) HAVING COUNT(*)>=3 ; 
SELECT MAX(CRUISINGRANGE) FROM AIRCRAFT WHERE AID IN (SELECT AID FROM CERTIFIED GROUP BY(AID) HAVING COUNT(*)>=3) ; 

--3.Find the names of pilots whose salary is less than the price of the cheapest route from Los Angeles to Honolulu.
SELECT MIN(PRICE) FROM FLIGHT WHERE FRM='LOS ANGELES' AND TOO='HONOLULU';
SELECT ENAME , ESALARY FROM AIRCRAFT_EMPLOYEE WHERE ESALARY<(SELECT MIN(PRICE) FROM FLIGHT WHERE FRM='LOS ANGELES' AND TOO='HONOLULU');

--4.For all aircraft with cruising range over 1000 miles, find the name of the aircraft and the average salary of all pilots certified for this aircraft.
--AVERAFE SALARY
SELECT AVG(ESALARY)FROM AIRCRAFT_EMPLOYEE;

--SELECT ENAME FROM CERTIFIED C,AIRCRAFT_EMPLOYEE AE WHERE AE.EID=C.EID AND AE.EID IN (SELECT EID FROM CERTIFIED WHERE AID IN(SELECT AID FROM AIRCRAFT WHERE CRUISINGRANGE=1000));

--SELECT AVG(ESALARY) FROM AIRCRAFT_EMPLOYEE WHERE AID IN (SELECT AID FROM AIRCRAFT WHERE CRUISINGRANGE=1000);
SELECT AVG(ESALARY),ANAME FROM AIRCRAFT A , AIRCRAFT_EMPLOYEE AE, CERTIFIED C WHERE
A.AID=C.AID AND C.EID = AE.EID AND CRUISINGRANGE=1000 GROUP BY(C.AID,C.EID);

--5.Find the aids of all aircraft that can be used on routes from Los Angeles to Chicago. 
SELECT AID FROM AIRCRAFT A
WHERE CRUISINGRANGE > (SELECT MIN(DISTANCE) FROM FLIGHT F WHERE FRM='LOS ANGELES'AND TOO='CHICAGO');

--6.Print the enames of pilots who can operate planes with cruising range greater than 3000 miles but are not certified on any Boeing aircraft
SELECT DISTINCT(AE.ENAME) FROM AIRCRAFT A , AIRCRAFT_EMPLOYEE AE, CERTIFIED C WHERE
A.AID=C.AID AND C.EID = AE.EID AND CRUISINGRANGE>3000 AND A.ANAME !='BOEING'; 

--8.Print the name and salary of every nonpilot whose salary is more than the average salary for pilots.
SELECT * FROM AIRCRAFT_EMPLOYEE WHERE ESALARY>(SELECT AVG(ESALARY) FROM AIRCRAFT_EMPLOYEE);

--9. Print the names of employees who are certified only on aircrafts with cruisingrange longer than 1000 miles, but on at least two such aircrafts

SELECT ENAME FROM AIRCRAFT A , AIRCRAFT_EMPLOYEE AE, CERTIFIED C WHERE
A.AID=C.AID AND C.EID = AE.EID AND CRUISINGRANGE>1000
GROUP BY(ENAME) HAVING COUNT(ENAME)>=2;
--HAVING COUNT(ENAME)>=2


--10.  Print the names of employees who are certified on all aircrafts
SELECT AE.EID,ENAME FROM AIRCRAFT_EMPLOYEE AE,CERTIFIED C GROUP BY(AE.EID,ENAME);


