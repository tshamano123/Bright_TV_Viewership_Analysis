---Viewing viewers table
select * from `workspace`.`default`.`viewers`;


---Viewing user table
select * from `workspace`.`default`.`users` limit 10;


---------------------------------------------------------------------------------
---Checking the date range
------------------------------------------------------------------------------
---First and last date of data collection is 2016-01-01

SELECT date_format(MIN(RecordDate2), 'yyyy-MM-dd') AS start_date,
       date_format(MAX(RecordDate2), 'yyyy-MM-dd') AS end_date
FROM `workspace`.`default`.`viewers`;


---LEFT JOIN TABLES

SELECT 
       UserID0, Channel2, RecordDate2, `Duration 2`, Gender, Age, Race, Province
FROM `workspace`.`default`.`viewers` AS A
LEFT JOIN `workspace`.`default`.`users` AS B
ON A.UserID0 = B.UserID;


----Checking different Gender, Age, Race, Province
SELECT DISTINCT(Gender) AS Gender, Age, Race, Province
from `workspace`.`default`.`users`;

---Checking different channels: They are 21 different channels
SELECT DISTINCT(Channel2) AS Channel2
FROM `workspace`.`default`.`viewers`;

---Checking and cleaning Null
SELECT 
       UserID0, Channel2, RecordDate2,  `Duration 2`, userID, Gender,  Age, Race, Province
FROM `workspace`.`default`.`viewers` AS A
LEFT JOIN `workspace`.`default`.`users` AS B
ON A.UserID0 = B.UserID
WHERE Channel2 IS NULL
OR    RecordDate2 IS NULL
OR `Duration 2`IS NULL
OR  userid4 IS NULL;


----Cleaning None values
SELECT
CASE
    WHEN Gender ='None' THEN 'No gender'  
    ELSE Gender
 END AS Gender_title,
       CASE
           WHEN Race ='None' THEN 'No race'
           ELSE Race
END AS Race,
       CASE
           WHEN Province ='None' THEN 'No province'
           ELSE Province
END AS Province
FROM`workspace`.`default`.`users`
ORDER BY AGE DESC;


-------------------------------------------------------------------------
---Trimming and standardising  values
-----------------------------------------------------------------------
----Trimming Users dataset
SELECT (TRIM(Gender)) As Gender, 
       (TRIM(Race)) As Race,
       (TRIM(Age)) As Age,
       (TRIM(Province)) As Province
FROM `workspace`.`default`.`users`;


---Trimming Viewers dataset
SELECT (TRIM(Channel2)) As Channel2
 FROM `workspace`.`default`.`viewers`;


---Converting to time
SELECT TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss') AS Duration_Time
FROM `workspace`.`default`.`viewers`;

---Standardising
SELECT 
       date_format(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'), 'HH:mm:ss') AS Clean_Duration
FROM `workspace`.`default`.`viewers`;

---Converting global time to South African time
SELECT DATEADD(Hour,2,RecordDate2) As South_African_time
FROM `workspace`.`default`.`viewers`;

---Cleanning converted Global time to South African time 
SELECT date_format(DATEADD(Hour, 2,RecordDate2), 'HH:mm') AS South_African_Time
FROM `workspace`.`default`.`viewers`;


----Extracting day and month from date
SELECT Dayname(RecordDate2) AS Day_name,
       Monthname(RecordDate2) AS Month_name,
       CASE 
              WHEN Day_name IN ('sat', 'sun') THEN 'weekend'
              ELSE 'weekdays'
       END AS Days,

       CASE
              WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
              WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
              WHEN date_format(RecordDate2, 'HH:mm:ss') >= '17:00:00' THEN 'Evening'
END AS Time_bucket
FROM `workspace`.`default`.`viewers`;


---Creating Age bucket
SELECT 
       CASE
            WHEN Age BETWEEN '0' AND '17' THEN 'Kid'
            WHEN Age BETWEEN '18' AND '35' THEN 'Youth'
            WHEN Age BETWEEN '36' AND '45' THEN 'Young_adult'
            WHEN Age BETWEEN '46' AND '60' THEN 'Adult'
       ELSE 'Pensioner'
END AS Age_group 
FROM `workspace`.`default`.`users`;


---Counting number of males and female
SELECT
       Gender,
       COUNT(UserID) AS Count
FROM `workspace`.`default`.`users`
GROUP BY Gender
ORDER BY Count DESC;

SELECT Gender, UserID
FROM `workspace`.`default`.`users`
WHERE Gender = '';


---Checking Viewership split by race
SELECT
       Race,
       COUNT(UserID) AS Race_viewership
FROM `workspace`.`default`.`users`
GROUP BY Race
ORDER BY Race_viewership DESC;

---Split by Province
SELECT
       Province,
       COUNT(UserID) AS Province_Split
FROM `workspace`.`default`.`users`
GROUP BY Province
ORDER BY Province_Split DESC;


---Split by Channel2
SELECT
       DISTINCT(Channel2)
       FROM `workspace`.`default`.`viewers`;


---Checking the most watched show
SELECT
       Channel2,
       COUNT(UserID0) AS Viewership_of_channel2
FROM `workspace`.`default`.`viewers`
GROUP BY Channel2
ORDER BY Viewership_of_channel2 DESC;

-------------------------------------------------------------------------------
---Main code
-------------------------------------------------------------------------------
---Data cleaning: columns and Standardising duration to (HH:mm:ss)
SELECT  UserID0  AS UserID,
       Channel2 AS Channel,
      
       date_format(TO_TIMESTAMP(RecordDate2, 'yyyy:MM:dd'), 'yyyy:MM:dd') AS RecordDate,
---Getting month name
       Monthname(RecordDate2) AS Month_name,
       
 --- Getting the day name (e.g., Monday)
       Dayname(RecordDate2) AS Day_name,
---Creating Day-tupe bucket
       CASE 
              WHEN Day_name IN ('Sat', 'Sun') THEN 'weekend'
              ELSE 'weekdays'
       END AS Day_classification,
--- Creating time bucket
       CASE
              WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
              WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
              WHEN date_format(RecordDate2, 'HH:mm:ss') >= '17:00:00' THEN 'Evening'
END AS Time_bucket,

---Converting global time to South African time       
       date_format(DATEADD(Hour,2,RecordDate2), 'HH:mm') AS SA_Time,

---Standardising time
       date_format(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'), 'HH:mm:ss') AS Duration,
       Age AS Age, 

---Creating Age group bucket
 CASE
            WHEN Age BETWEEN '0' AND '17' THEN 'Kid'
            WHEN Age BETWEEN '18' AND '35' THEN 'Youth'
            WHEN Age BETWEEN '36' AND '45' THEN 'Young_adult'
            WHEN Age BETWEEN '46' AND '60' THEN 'Adult'
       ELSE 'Pensioner'
END AS Age_group ,

----Cleaning None values
CASE
    WHEN Gender ='None' THEN 'No gender'  
    ELSE Gender
 END AS Gender_title,

 
       CASE
           WHEN Race ='None' THEN 'No race'
           ELSE Race
END AS Race,
       CASE
           WHEN Province ='None' THEN 'No province'
           ELSE Province
END AS Province


---Left JOIN tables     
FROM `workspace`.`default`.`viewers` AS A
LEFT JOIN `workspace`.`default`.`users` AS B
ON A.UserID0 = B.UserID;

