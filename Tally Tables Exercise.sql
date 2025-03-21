/*
 * Tally Tables Exercise

 * The temporary table, #PatientAdmission, has values for dates between the 1st and 8th January inclusive
 * But not all dates are present
 */

DROP TABLE IF EXISTS #PatientAdmission;
CREATE TABLE #PatientAdmission (AdmittedDate DATE, NumAdmissions INT);
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2024-01-01', 5)
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2024-01-02', 6)
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2024-01-03', 4)
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2024-01-05', 2)
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2024-01-08', 2)
SELECT * FROM #PatientAdmission

/*
 * Exercise: create a resultset that has a row for all dates in that period 
 * of 8 days with NumAdmissions set to 0 for missing dates. 
 You may wish to use the SQL statements below to set the start and end dates
 */

DECLARE @StartDate DATE;
DECLARE @EndDate DATE;
DECLARE @NumDays INT;
SELECT @StartDate = DATEFROMPARTS(2024, 1, 1);
SELECT @EndDate = DATEFROMPARTS(2024, 1, 8);
select @NumDays=DATEDIFF(DAY, @startdate, @enddate)+1;
with ContigDateRange (N, AdmittedDate) AS
(
select t.N,
DATEADD(DAY, t.N-1, @StartDate) 
from Tally t 
where t.N<=@NumDays
)
SELECT
crd.* ,
ISNULL(pa.NumAdmissions,0) as 'Admissions'
from ContigDateRange crd 
left join #PatientAdmission pa on crd.AdmittedDate =pa.AdmittedDate


/*
 * Exercise: list the dates that have no patient admissions
*/


DECLARE @StartDate DATE;
DECLARE @EndDate DATE;
DECLARE @NumDays INT;
SELECT @StartDate = DATEFROMPARTS(2024, 1, 1);
SELECT @EndDate = DATEFROMPARTS(2024, 1, 8);
select @NumDays=DATEDIFF(DAY, @startdate, @enddate)+1;
with ContigDateRange (N, AdmittedDate) AS
(
select t.N,
DATEADD(DAY, t.N-1, @StartDate) 
from Tally t 
where t.N<=@NumDays
)
SELECT
crd.* ,
ISNULL(pa.NumAdmissions,0) as 'Admissions'
from ContigDateRange crd 
left join #PatientAdmission pa on crd.AdmittedDate =pa.AdmittedDate
where pa.NumAdmissions IS NULL