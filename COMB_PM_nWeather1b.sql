--In this program we generate the daily but corresponding values of air temperature (Tavg), 
--  Precipitation (Precip) and air quality (PM2.5) for Pereira (Air Quality station Carder - Las Americas),
--  period 2022 to 2024.
--Also, we generate the monthly average but corresponding  values of air temperature (Tavg), 
--   Precipitation (Precip) and air quality (PM2.5). 
--We use CTEs and window functions. 

--Tables: 
--Weather table (DataWeather_PereiraFrom2022), involves columns: Date, air temperature (Tavg), Precipitation (Precip)
--Air quality table (PM25_PereiraFrom2022), involves columns: Date, PM2.5 (PM2_5), Month number (Month_1to12), 
--                                                           Year    

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--Data profiling for Air quality (PM2.5). Table PM25_PereiraFrom2022

--Determination of the number of rows ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT COUNT(*), COUNT(Date), COUNT(PM2_5)
FROM PM25_PereiraFrom2022;
--Result: COUNT(*): 715; COUNT(Date): 715; COUNT(PM2_5): 715

--Determination of Null values ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT PM2_5, Date, Weather_station
FROM PM25_PereiraFrom2022
WHERE PM2_5 IS NULL OR Date IS NULL OR Weather_station IS NULL;
--Result: no null values

--Identification of duplicates+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT Date, COUNT(*)
FROM PM25_PereiraFrom2022
GROUP BY Date
HAVING COUNT(*)>1;
--Result: there are no duplicates

--Determination of minimum, maximum and average values +++++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT MIN(PM2_5), MAX(PM2_5), AVG(PM2_5)
FROM PM25_PereiraFrom2022;
--Result: MIN(PM2_5): 5, MAX(PM2_5):31.04, AVG(PM2_5):11.995

--Determination of Year, Month and Day from the Data column, ++++++++++++++++++++++++++++++++++++++++++++++++++ 
--as a way to assess the correcteness of the Date column
SELECT Date, STRFTIME('%Y', Date) AS Year,  
STRFTIME('%m', Date) AS Month,
STRFTIME('%d', Date) AS Day
FROM PM25_PereiraFrom2022;


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--Data profiling for the Weather table (DataWeather_PereiraFrom2022) ++++++++++++++++++++++++++++++++++++++++++++++

--Determination of the number of rows +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT COUNT(*), COUNT(Date), COUNT(Avg_T), COUNT(Precip)
FROM DataWeather_PereiraFrom2022;
--Result: COUNT(*): 1096; COUNT(Date): 1096; COUNT(Avg_T):1096; COUNT(Precip): 1096

--Determination of the null values +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT Date, Min_T, Max_T, Avg_T, Precip
FROM DataWeather_PereiraFrom2022
WHERE Date IS NULL OR Min_T IS NULL OR Max_T IS NULL OR Avg_T IS NULL OR Precip IS NULL;
--Result: no null values

SELECT Date, Min_T, Max_T, Avg_T, Precip
FROM DataWeather_PereiraFrom2022
WHERE Date ='' OR Min_T ='' OR Max_T = '' OR Avg_T ='' OR Precip ='';
--Result: no empty values

--Identification of duplicates+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT Date, COUNT(*)
FROM DataWeather_PereiraFrom2022
GROUP BY Date
HAVING COUNT(*)>1;
--Result: there are no duplicates

--Determination of minimum, maximum and average values +++++++++++++++++++++++++++++++++++++++++++++++
SELECT MIN(Precip), MAX(Precip), AVG(Precip), 
MIN(Min_T), MAX(Min_T), AVG(Min_T),
MIN(Max_T), MAX(Max_T), AVG(Max_T),
MIN(Avg_T), MAX(Avg_T), AVG(Avg_T)
FROM DataWeather_PereiraFrom2022;
--REsult: MIN(Precip): 0, MAX(Precip): 103, AVG(Precip): 6.75, 
--MIN(Min_T): -8.5, MAX(Min_T):21, AVG(Min_T):17.4,
--MIN(Max_T):21, MAX(Max_T):32.5, AVG(Max_T):27.3,
--MIN(Avg_T):0, MAX(Avg_T):25.6, AVG(Avg_T):21.7

--The results MIN(Min_T) = -8.5 is ilogical.  
--From an indepth examination, We notice several ilogical values in Min_T column, including 0.0. Then, we will disregard Min_T column. 

--The result MIN(Avg_T) = 0 is ilogical. From an in depth examination of Avg_T column, We notice that Avg_T = 0 for Date 2022_07_26. 
--Therefore, we delete this value:
DELETE FROM DataWeather_PereiraFrom2022 
WHERE Date = '2022-07-26'; 

--Now, we verify that the row is absent:
SELECT Date, Min_T, Max_T, Avg_T, Precip
FROM DataWeather_PereiraFrom2022
WHERE STRFTIME('%Y', Date) = '2022' AND STRFTIME('%m', Date) = '07'
--Result: the row for Date = 2022-07-26 is absent 

--Next, we determine the Min, Avg and Max values for Tmin column, +++++++++++++++++++++++++++++++++++++++
--but we disregard the extreme (outlier) values:
 SELECT MIN(Min_T), AVG(Min_T), MAX(Min_T)
 FROM DataWeather_PereiraFrom2022
 WHERE Min_T >14;

--Determination of the Year, Month and Day from the Data column,   ++++++++++++++++++++++++++++++++++++++++
--as a way to assess the correcteness of the Date column
SELECT Date, STRFTIME('%Y', Date) AS Year,
STRFTIME('%m', Date) AS Month,
STRFTIME('%d', Date) AS Day
FROM DataWeather_PereiraFrom2022;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--Determination of the monthly PM2.5 values, but segmented by years 2022, 2023, 2024

--2022: Monthly PM2.5 values +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT STRFTIME('%m', Date) AS Month, STRFTIME('%Y', Date) AS Year, 
   AVG(PM2_5) AS PM25_permonth
FROM PM25_PereiraFrom2022
WHERE Year = '2022'
GROUP BY Month
ORDER BY Month ASC

--2023: Monthly PM2.5 values
SELECT STRFTIME('%m', Date) AS Month, STRFTIME('%Y', Date) AS Year, 
   AVG(PM2_5) AS PM25_permonth 
FROM PM25_PereiraFrom2022
WHERE Year = '2023'
GROUP BY Month
ORDER BY Month ASC

--2024: Monthly PM2.5 values
SELECT STRFTIME('%m', Date) AS Month, STRFTIME('%Y', Date) AS Year, 
   AVG(PM2_5) AS PM25_permonth 
FROM PM25_PereiraFrom2022
WHERE Year = '2024'
GROUP BY Month
ORDER BY Month ASC


--Now, we generate the combined table (vertical combination)
WITH MonthTab2022 AS (SELECT STRFTIME('%m', Date) AS Month, STRFTIME('%Y', Date) AS Year, 
   AVG(PM2_5) AS PM25_permonth
  FROM PM25_PereiraFrom2022
  WHERE Year = '2022'
  GROUP BY Month
  ORDER BY Month ASC
),
MonthTab2023 AS (SELECT STRFTIME('%m', Date) AS Month, STRFTIME('%Y', Date) AS Year, 
   AVG(PM2_5) AS PM25_permonth 
  FROM PM25_PereiraFrom2022
  WHERE Year = '2023'
  GROUP BY Month
  ORDER BY Month ASC
),
MonthTab2024 AS (SELECT STRFTIME('%m', Date) AS Month, STRFTIME('%Y', Date) AS Year, 
   AVG(PM2_5) AS PM25_permonth 
  FROM PM25_PereiraFrom2022
  WHERE Year = '2024'
  GROUP BY Month
  ORDER BY Month ASC
)
SELECT Year, Month, PM25_permonth FROM MonthTab2022
UNION ALL
SELECT Year, Month, PM25_permonth FROM MonthTab2023
UNION ALL
SELECT Year, Month, PM25_permonth FROM MonthTab2024

  





--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--Determination of daily corresponding values of Tavg, Precip and PM25, along time 
--Combination of the Weather and Air quality tables into a single table, using INNER JOIN.  
--We use the Date as the key for the JOIN
--Also, we generate the day number, as it facilitates creation of figures:

--Development of the combined table: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 SELECT wt.Date, STRFTIME('%j', wt.Date) AS Day_ofyear, wt.Year AS Year_Combtable, 
     wt.Avg_T AS AvgT_Combtable, wt.Precip AS Precip_Combtable, 
     tpm25.PM2_5 AS PM25_Combtable
  FROM DataWeather_PereiraFrom2022 wt INNER JOIN PM25_PereiraFrom2022 tpm25
  ON wt.Date = tpm25.Date
  ORDER BY wt.Date ASC

--Determination of the number of rows of the combined table +++++++++++++++++++++++++++++++++++++++++++++++++++++
WITH CombTable AS (
  SELECT wt.Date, STRFTIME('%j', wt.Date) AS Day_ofyear, wt.Year AS Year_Combtable, 
     wt.Avg_T AS AvgT_Combtable, wt.Precip AS Precip_Combtable, 
     tpm25.PM2_5 AS PM25_Combtable
  FROM DataWeather_PereiraFrom2022 wt INNER JOIN PM25_PereiraFrom2022 tpm25
  ON wt.Date = tpm25.Date
  ORDER BY wt.Date ASC
)
SELECT COUNT(*), COUNT(Day_ofyear), COUNT(Year_Combtable), COUNT(AvgT_Combtable), 
  COUNT(Precip_Combtable)
FROM CombTable
--Result: 715
--Recall that the number of rows of the Air quality table is  715, 
--and the number of rows of the Weather table is 1095.  
--Therefore, the obtained number of rows (715) is logical  


--Development of the combined table, but we also generate the time in days, ++++++++++++++++++++++++++++++++++++++++
--that is, the Day series number, departing from 0
WITH CombTable AS (
  SELECT wt.Date, STRFTIME('%j', wt.Date) AS Day_ofyear, wt.Year AS Year_Combtable, 
     wt.Avg_T AS AvgT_Combtable, wt.Precip AS Precip_Combtable, 
     tpm25.PM2_5 AS PM25_Combtable
  FROM DataWeather_PereiraFrom2022 wt INNER JOIN PM25_PereiraFrom2022 tpm25
  ON wt.Date = tpm25.Date
  ORDER BY wt.Date ASC
)
SELECT Day_ofyear+365.0*(Year_Combtable - 2022) AS Day_seriesnumber, AvgT_Combtable, 
  Precip_Combtable, PM25_Combtable
FROM CombTable



--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--Determination of monthly corresponding values of Tavg, Precip and PM25, along time +++++++++++++++++++++++++++++++++++++++++

--Monthly PM2.5 values +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT MonthSeries, AVG(PM2_5) AS PM25_permonth --STRFTIME('%m', Date) AS Month
FROM PM25_PereiraFrom2022
GROUP BY MonthSeries
ORDER BY MonthSeries ASC

--Monthly AvgT values +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT MonthSeriesNb, AVG(Avg_T) AS AvgT_permonth, AVG(Precip) AS Precip_permonth --  STRFTIME('%m', Date) AS Month
FROM DataWeather_PereiraFrom2022
GROUP BY MonthSeriesNb
ORDER BY MonthSeriesNb ASC

--Determination of monthly (but corresponding) values of PM2.5, T_avg, Precip +++++++++++++++++++++++++++++++++++++++++++
WITH TableClim_Monthly AS (   --Monthly values of Avg_T and Precip
     SELECT MonthSeriesNb AS MonthSeriesClim, AVG(Avg_T) AS Month_AvgT, AVG(Precip) AS Month_Precip --STRFTIME('%m', Date) AS MonthSeriesClim
     FROM DataWeather_PereiraFrom2022
     GROUP BY MonthSeriesClim
     ),
     TablePM_Monthly AS (   --Monthly values of PM2.5
     SELECT MonthSeries AS MonthSeries_PM, AVG(PM2_5) AS Month_PM25 --STRFTIME('%m', Date) AS MonthSeries_PM
     FROM PM25_PereiraFrom2022
     GROUP BY MonthSeries_PM
     )
SELECT TableClim_Monthly.MonthSeriesClim, Month_AvgT, Month_Precip, Month_PM25
FROM TableClim_Monthly INNER JOIN TablePM_Monthly 
ON TableClim_Monthly.MonthSeriesClim = TablePM_Monthly.MonthSeries_PM 
--Result: there is a correlation between monthly PM2.5 levels and monthly air temperature (Avg_T): 
--    High PM2.5 levels are associated with high Avg_T values, whereas low PM2.5 levels correspond to low Avg_T values. 
--    In contrast, there is no evident relationship between PM2.5 levels and precipitation (Precip). 

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%WINDOWS FUNCTIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--Identification of the three highest PM2.5 values for each month, using Windows functions 


--We extract the highest PM2.5 values by month 
SELECT Date, MonthSeries AS mthval, PM2_5, 
RANK() OVER (PARTITION BY MonthSeries ORDER BY PM2_5 DESC) AS pm25rank --STRFTIME('%m', Date) AS mthval
FROM PM25_PereiraFrom2022;

--Identification of the three highest PM2.5 values for each month +++++++++++++++++++++++++++++++++++++++++++++++++++++
--but also we obtain the average PM2.5 for each month
WITH rankpm25table AS (
  SELECT Date, MonthSeries AS Monthval, PM2_5 AS HighestPM25perMonth,
  AVG(PM2_5) OVER (PARTITION BY MonthSeries) AS AvgPm25PerMonth,
  RANK() OVER (PARTITION BY MonthSeries ORDER BY PM2_5 DESC) AS pm25rank 
  FROM PM25_PereiraFrom2022
)
SELECT *
FROM rankpm25table
WHERE pm25rank <=3

--Identification of the three highest PM2.5 values for each month, +++++++++++++++++++++++++++++++++++++++++++++++++++++
--but we also obtain the corresponding monthly averages AVG(T) and AVG(Precip) values, and  AVG(PM2_5) for each Month     
WITH CombinedTable AS (   --combination of Weather and PM2.5 tables
     SELECT wt.Date, wt.MonthSeriesNb AS MonthSeries_Join, wt.Precip, wt.Avg_T, tpm25.PM2_5
     FROM DataWeather_PereiraFrom2022 wt INNER JOIN PM25_PereiraFrom2022 tpm25
     ON wt.Date = tpm25.Date 
     ),
     rankpm25table AS (
     SELECT Date, MonthSeries_Join, Precip, Avg_T, PM2_5,
     RANK () OVER (PARTITION BY MonthSeries_Join ORDER BY PM2_5 DESC) AS PM25_rank,
     AVG(PM2_5) OVER (PARTITION BY MonthSeries_Join) AS PM25_MonthlyAvg,
     AVG(Precip) OVER (PARTITION BY MonthSeries_Join) AS Precip_MonthlyAvg,
     AVG(Avg_T) OVER (PARTITION BY MonthSeries_Join) AS T_MonthlyAvg
     FROM CombinedTable
     )
SELECT Date, MonthSeries_Join, PM2_5 AS PM25_threeHighest, PM25_rank, Precip, Avg_T, 
PM25_MonthlyAvg, Precip_MonthlyAvg, T_MonthlyAvg --*
FROM rankpm25table
WHERE PM25_rank <=3
--Result: there is a correlation between monthly PM2.5 levels and monthly air temperature (Avg_T): 
--    High PM2.5 levels are associated with high Avg_T values, whereas low PM2.5 levels correspond to low Avg_T values. 
--    In contrast, there is no evident relationship between PM2.5 levels and precipitation (Precip). 

