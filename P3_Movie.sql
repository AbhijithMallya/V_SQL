CREATE TABLE ACTOR
(
ACT_ID NUMBER(3) PRIMARY KEY,
ACT_NAME VARCHAR(20),
ACT_GENDER VARCHAR(10)
);

INSERT INTO ACTOR VALUES(1,'JAMES STWART','M');
INSERT INTO ACTOR VALUES(2,'KIM SNOVACK','F');
INSERT INTO ACTOR VALUES(3,'GRACE KELLY','F');
INSERT INTO ACTOR VALUES(4,'AMIR KHAN','M');
INSERT INTO ACTOR VALUES(5,'ZAIRA WASIM','F');
INSERT INTO ACTOR VALUES(6,'SHARUKH KHAN','M');
INSERT INTO ACTOR VALUES(7,'KAJOL','F');
SELECT * FROM ACTOR;

CREATE TABLE DIRECTOR 
(
DIR_ID NUMBER(3) PRIMARY KEY,
DIR_NAME VARCHAR(20) ,
DIR_PHONE NUMBER(10)
);

INSERT INTO DIRECTOR values(1,'HITCHCOCK',null);
INSERT INTO DIRECTOR values(2,'ADVAIT CHANDAN',9854632758);
INSERT INTO DIRECTOR values(3,'KARAN JOHAR',9653578421);
INSERT INTO DIRECTOR values(4,'YASH CHOPRA',9974563258);
INSERT INTO DIRECTOR values(6,'STEVEN SPILLSBERG',null);
SELECT * FROM DIRECTOR ORDER BY DIR_ID;

CREATE TABLE MOVIES
(
MOV_ID NUMBER(3) PRIMARY KEY,
MOV_TITLE VARCHAR(20) ,
MOV_YEAR NUMBER(4),
MOV_LANG VARCHAR(10),
DIR_ID REFERENCES DIRECTOR ON DELETE CASCADE 
);

INSERT INTO MOVIES VALUES(1,'VERTIGO',1954,'ENGLISH',1);
INSERT INTO MOVIES VALUES(2,'REAR WIDOW',1954,'ENGLISH',1);
INSERT INTO MOVIES VALUES(3,'SECRET SUPESRTAR',2017,'HINDI',2);
INSERT INTO MOVIES VALUES(4,'KUCH KUCH HOTA HAI',1998,'HINDI',3);
INSERT INTO MOVIES VALUES(5,'KAL HO NA HO',2003,'HINDI',3);
INSERT INTO MOVIES VALUES(6,'KAAL',2005,'HINDI',3);
INSERT INTO MOVIES VALUES(7,'DIL',1990,'HINDI',4);
INSERT INTO MOVIES VALUES(8,'BAAZI',1995,'HINDI',4);
INSERT INTO MOVIES VALUES(9,'MINORITY REPORT',2002,'ENGLISH',6);
INSERT INTO MOVIES VALUES(10,'MUNICH',2005,'ENGLISH',6);
SELECT * FROM MOVIES;

CREATE TABLE MOVIE_CAST
(
ACT_ID REFERENCES ACTOR ON DELETE CASCADE ,
MOV_ID REFERENCES MOVIES ON DELETE CASCADE ,
ROLE VARCHAR(10),
PRIMARY KEY(ACT_ID,MOV_ID) 
);

INSERT INTO MOVIE_CAST VALUES(1,1,'HERO');
INSERT INTO MOVIE_CAST VALUES(1,2,'HERO');
INSERT INTO MOVIE_CAST VALUES(3,2,'HEROINE');
INSERT INTO MOVIE_CAST VALUES(2,2,'HEROINE');
INSERT INTO MOVIE_CAST VALUES(4,3,'HERO');
INSERT INTO MOVIE_CAST VALUES(5,3,'HEROINE');
INSERT INTO MOVIE_CAST VALUES(4,4,'HERO');
INSERT INTO MOVIE_CAST VALUES(4,8,'HERO');
SELECT * FROM MOVIE_CAST;

CREATE TABLE RATING
(
MOV_ID REFERENCES MOVIES ON DELETE CASCADE ,
STARS NUMBER(2) ,
PRIMARY KEY(MOV_ID,STARS)
);

INSERT INTO RATING VALUES(1,1);
INSERT INTO RATING VALUES(1,2);
INSERT INTO RATING VALUES(2,1);
INSERT INTO RATING VALUES(2,5);
INSERT INTO RATING VALUES(9,5);
INSERT INTO RATING VALUES(10,5);
SELECT * FROM RATING;

--1. List the titles of all movies directed by ‘Hitchcock'
SELECT MOV_TITLE FROM MOVIES 
WHERE DIR_ID = (SELECT DIR_ID FROM DIRECTOR WHERE DIR_NAME='HITCHCOCK');

--2.  Find Movie name where one or more actors acted in 2 or more movies
--              MOVIE_TITLE( MOV_ID (ACT_ID COUNT(*)>=2) ) 
SELECT MOV_TITLE FROM MOVIES
WHERE MOV_ID 
IN (SELECT MOV_ID FROM MOVIE_CAST WHERE ACT_ID 
IN(SELECT ACT_ID FROM MOVIE_CAST GROUP BY(ACT_ID) HAVING COUNT(*)>=2));

--3. List of actors who acted <2000 and >2015 (JOIN)
SELECT * FROM ACTOR 
WHERE ACT_ID IN
(SELECT ACT_ID FROM MOVIES M , MOVIE_CAST MC WHERE M.MOV_ID=MC.MOV_ID AND MOV_YEAR<2000
INTERSECT
SELECT ACT_ID FROM MOVIES M , MOVIE_CAST MC WHERE M.MOV_ID=MC.MOV_ID AND MOV_YEAR>2015
);

--4. List Mov_Title & Stars 
SELECT MOV_TITLE,MAX(STARS) FROM MOVIES M , RATING R 
WHERE M.MOV_ID=R.MOV_ID 
GROUP BY (MOV_TITLE)
ORDER BY (MOV_TITLE);
SELECT * FROM DIRECTOR;

--5. Update rating of all movies directed by 'STEVEN SPILLSBERG' to 5
UPDATE RATING SET STARS=5
WHERE MOV_ID IN(
SELECT MOV_ID FROM MOVIES WHERE 
DIR_ID IN(SELECT DIR_ID FROM DIRECTOR WHERE DIR_NAME = 'STEVEN SPILLSBERG')
);
SELECT * FROM RATING;


