
---Main code
---Data cleaning: columns and Standardising duration to (HH:mm:ss)
SELECT  UserID0  AS UserID,
       Channel2 AS Channel,
      
       date_format(TO_TIMESTAMP(RecordDate2, 'yyyy:mm:dd'), 'yyyy:mm:dd') AS RecordDate,
       ---Get month name
       Monthname(RecordDate2) AS Month_name,
       
       -- Get the day name (e.g., Monday)
       Dayname(RecordDate2) AS Day_name,

       CASE 
              WHEN Day_name IN ('Sat','Sun') THEN 'weekend'
              ELSE 'weekdays'
       END AS Day_classification,

       CASE
              WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
              WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
              WHEN date_format(RecordDate2, 'HH:mm:ss') >= '17:00:00' THEN 'Evening'
END AS Time_bucket,
       
       date_format(DATEADD(Hour, 2, RecordDate2), 'HH:mm') AS SA_Time,
        
       date_format(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'), 'HH:mm:ss') AS Duration,
       Age AS Age, 
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
