use bank_loan_db;
show tables;
select count(*) from bank_loan;

use bank_loan_db;
show tables;
select * from bank_loan; 

select count(*)
from bank_loan;

Alter table bank_loan
ADD column con_issue_date DATE;

-- converting the values the date values in the 'issue_date' column to a valid date formate and adding the values into 'con_issue_date'

Update bank_loan
SET con_issue_date = CASE
	WHEN issue_date like '__/__/____' THEN STR_TO_DATE(issue_date,'%d/%m/%Y') -- DD/MM/YYYY
	WHEN issue_date like '__-__-____' THEN STR_TO_DATE(issue_date,'%d-%m-%Y') -- DD-MM-YYYY
    WHEN issue_date like '____-__-__' THEN STR_TO_DATE(issue_date,'%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

select * from bank_loan; 

ALTER TABLE bank_loan
DROP COLUMN issue_date;

ALTER TABLE bank_loan
CHANGE COLUMN con_issue_date issue_date DATE;

-- converting the values the date values in the 'last_credit_pull_date' column to a valid date formate and adding the values into 'con_last_credit_pull_date'


Alter table bank_loan
ADD column con_last_credit_pull_date DATE;

Update bank_loan
SET con_last_credit_pull_date = CASE
	WHEN last_credit_pull_date like '__/__/____' THEN STR_TO_DATE(last_credit_pull_date,'%d/%m/%Y') -- DD/MM/YYYY
	WHEN last_credit_pull_date like '__-__-____' THEN STR_TO_DATE(last_credit_pull_date,'%d-%m-%Y') -- DD-MM-YYYY
    WHEN last_credit_pull_date like '____-__-__' THEN STR_TO_DATE(last_credit_pull_date,'%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

select * from bank_loan; 

ALTER TABLE bank_loan
DROP COLUMN last_credit_pull_date;

ALTER TABLE bank_loan
CHANGE COLUMN con_last_credit_pull_date last_credit_pull_date DATE;


-- converting the values the date values in the 'next_payment_date' column to a valid date formate and adding the values into 'con_next_payment_date'

Alter table bank_loan
ADD column con_next_payment_date DATE;

Update bank_loan
SET con_next_payment_date = CASE
	WHEN next_payment_date like '__/__/____' THEN STR_TO_DATE(next_payment_date,'%d/%m/%Y') -- DD/MM/YYYY
	WHEN next_payment_date like '__-__-____' THEN STR_TO_DATE(next_payment_date,'%d-%m-%Y') -- DD-MM-YYYY
    WHEN next_payment_date like '____-__-__' THEN STR_TO_DATE(next_payment_date,'%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

select * from bank_loan; 

ALTER TABLE bank_loan
DROP COLUMN next_payment_date;

ALTER TABLE bank_loan
CHANGE COLUMN con_next_payment_date next_payment_date DATE;

-- converting the values the date values in the 'last_payment_date' column to a valid date formate and adding the values into 'con_last_payment_date'

Alter table bank_loan
ADD column con_last_payment_date DATE;

Update bank_loan
SET con_last_payment_date = CASE
	WHEN last_payment_date like '__/__/____' THEN STR_TO_DATE(last_payment_date,'%d/%m/%Y') -- DD/MM/YYYY
	WHEN last_payment_date like '__-__-____' THEN STR_TO_DATE(last_payment_date,'%d-%m-%Y') -- DD-MM-YYYY
    WHEN last_payment_date like '____-__-__' THEN STR_TO_DATE(last_payment_date,'%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

select * from bank_loan; 

ALTER TABLE bank_loan
DROP COLUMN last_payment_date;

ALTER TABLE bank_loan
CHANGE COLUMN con_last_payment_date last_payment_date DATE;

-- calculating the total application received
select count(id) Total_loan_Application FROM bank_loan;

--  calculating MTD total loan application
SELECT  COUNT(id) MTD_Total_Loan_Applications
FROM bank_loan WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021; -- 4314

--  calculating MTD total loan application
SELECT  COUNT(id) PMTD_Total_Loan_Applications
FROM bank_loan WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021; -- 4035

-- Calculating the MOM Total calculation

WITH MTD_app as (
SELECT  COUNT(id) AS MTD_Total_Loan_Applications
FROM bank_loan WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021),
PMTD_app as(
SELECT  COUNT(id) AS PMTD_Total_Loan_Applications
FROM bank_loan WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)

SELECT ((MTD.MTD_Total_Loan_Applications - PMTD.PMTD_Total_Loan_Applications) / PMTD.PMTD_Total_Loan_Applications) * 100 as MOM_Total_Loan_Applications
FROM MTD_app MTD,PMTD_app PMTD;

 
 -- calculating thr total funded amount
 
SELECT SUM(loan_amount) as Total_Loan_Amount
FROM bank_loan; -- 435757075

-- Calulating the MTD Total Funded Amount

SELECT SUM(loan_amount) as MTD_Funded_Amount
FROM bank_loan
WHERE MONTH (issue_date) = 12 AND YEAR(issue_date) = 2021; -- 53981425 

-- Calulating the PMTD Total Funded Amount

SELECT SUM(loan_amount) as PMTD_Funded_Amount
FROM bank_loan
WHERE MONTH (issue_date) = 11 AND YEAR(issue_date) = 2021; -- 47754825

-- Calulating the MOM Total Funded Amount

with MTD_funded as (SELECT SUM(loan_amount) as MTD_Funded_Amount
FROM bank_loan
WHERE MONTH (issue_date) = 12 AND YEAR(issue_date) = 2021),

PMTD_Funded as (SELECT SUM(loan_amount) as PMTD_Funded_Amount
FROM bank_loan
WHERE MONTH (issue_date) = 11 AND YEAR(issue_date) = 2021)

SELECT ((MTD.MTD_Funded_Amount - PMTD.PMTD_Funded_Amount) / PMTD.PMTD_Funded_Amount)* 100 as MOM_Total_Funded_AMount
from MTD_Funded MTD, PMTD_Funded PMTD; -- 13.0387

-- Calculating total amount recived

SELECT SUM(total_payment) as Total_Amount_Recived
FROM bank_loan; -- 473070933

-- Calculating MTD amount recived

SELECT SUM(total_payment) as MTD_Amount_Recived
FROM bank_loan
WHERE MONTH (issue_date) = 12 AND YEAR(issue_date) = 2021; -- 58074380

-- Calculating PMTD amount recived

SELECT SUM(total_payment) as PMTD_Amount_Recived
FROM bank_loan
WHERE MONTH (issue_date) = 11 AND YEAR(issue_date) = 2021; -- 50132030

-- Calulating the MOM Total Amount recived

with MTD_recived as (SELECT SUM(total_payment) as MTD_Amount_Recived
FROM bank_loan
WHERE MONTH (issue_date) = 12 AND YEAR(issue_date) = 2021),

PMTD_recived as (SELECT SUM(total_payment) as PMTD_Amount_Recived
FROM bank_loan
WHERE MONTH (issue_date) = 11 AND YEAR(issue_date) = 2021)

SELECT ((MTD.MTD_Amount_Recived - PMTD.PMTD_Amount_Recived) / PMTD.PMTD_Amount_Recived)* 100 as MOM_Total_Amount_recived
from MTD_recived MTD, PMTD_recived PMTD; -- 15.8429

-- Calculating the avg Int Rate

SELECT Round(AVG(int_rate) * 100,2) Avg_interest_rate From bank_loan; -- 12.05

-- Calculating the MTD avg Int Rate

SELECT Round(AVG(int_rate) * 100,2) Avg_MTD_interest_rate 
From bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021 ; -- 12.36

-- Calculating the PMTD avg Int Rate

SELECT Round(AVG(int_rate) * 100,2) Avg_PMTD_interest_rate 
From bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021 ; -- 11.94

-- Calulating the MOM Total AVG interset rate

with MTD_interest_rate as (SELECT AVG(int_rate) as MTD_AVG_interest_rate
FROM bank_loan
WHERE MONTH (issue_date) = 12 AND YEAR(issue_date) = 2021),

PMTD_interest_rate as (SELECT AVG(int_rate) as PMTD_AVG_interest_rate
FROM bank_loan
WHERE MONTH (issue_date) = 11 AND YEAR(issue_date) = 2021)

SELECT ROUND(((MTD.MTD_AVG_interest_rate - PMTD.PMTD_AVG_interest_rate) / PMTD.PMTD_AVG_interest_rate)* 100,2) as MOM_AVG_interest_rate
from MTD_interest_rate MTD, PMTD_interest_rate PMTD; -- 3.47

-- Calculating the avg dept to income ratio 

SELECT Round(AVG(dti) * 100,2) Avg_dept_to_income_ratio From bank_loan; -- 13.33

-- Calculating the avg MTD dept to income ratio 

SELECT Round(AVG(dti) * 100,2) Avg_MTD_dept_to_income_ratio From bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021; -- 13.67

-- Calculating the avg PMTD dept to income ratio 

SELECT Round(AVG(dti) * 100,2) Avg_PMTD_dept_to_income_ratio From bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021; -- 13.3

-- Calulating the MOM PMTD dept to income ratio 

with MTD_dti as(SELECT Round(AVG(dti) * 100,2) Avg_MTD_dept_to_income_ratio From bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021),

PMTD_dti as(SELECT Round(AVG(dti) * 100,2) Avg_PMTD_dept_to_income_ratio From bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)

SELECT ROUND(((MTD.Avg_MTD_dept_to_income_ratio - PMTD.Avg_PMTD_dept_to_income_ratio) / PMTD.Avg_PMTD_dept_to_income_ratio)* 100,2) as MOM_AVG_dept_to_income_ratio
from MTD_dti MTD, PMTD_dti PMTD; -- 2.78

-- calculating the good loan Application percentage
SELECT ROUND((COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END)) * 100 /
COUNT(id),2) AS Good_loan_Percentage
FROM bank_loan; -- 86.18

-- Calculating the good loan application
Select COUNT(id) AS Good_Loan_Application
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'; -- 33243

-- Calcuating the good loan funded amount
SELECT SUM(loan_amount) AS Good_Loan_funded_Amount
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'; -- 370224850

-- Calculating the Good loan recived amount
SELECT SUM(total_payment) AS Good_Loan_Amount_Recive
FROM  bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'; -- 435786170

-- Calculating bad loan percentage
SELECT ROUND((COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END)) * 100 /
COUNT(id),2) AS Bad_loan_Percentage
FROM bank_loan;  -- 13.82

-- Calculating the bad loan application
Select COUNT(id) AS Bad_Loan_Application
FROM bank_loan
WHERE loan_status = 'Charged Off'; -- 5333

-- Calcuating the Bad loan funded amount
SELECT SUM(loan_amount) AS Bad_Loan_funded_Amount
FROM bank_loan
WHERE loan_status = 'Charged Off'; -- 65532225

-- Calculating the Bad loan recived amount
SELECT SUM(total_payment) AS Bad_Loan_Amount_Recive
FROM  bank_loan
WHERE loan_status = 'Charged Off'; -- 37284763

-- Calulating the count of 'Loan Status', Total_Amount_Recived, Total_Funded_Amount, Interst_Rate, DTI on the basis of loan_status
SELECT
	loan_status,
    COUNT(id) AS Loan_Count,
    SUM(total_payment) AS Total_Funded_Amount_Recived,
    Sum(loan_amount) AS Total_Funded_Amount,
    AVG(int_rate * 100) AS Interest_Rate,
    AVG(dti * 100) AS DTI
FROM bank_loan
GROUP BY loan_status;

-- Calculating MTD total amount recived and MTD total amount on basis of loan status

SELECT
	loan_status,
    SUM(total_payment) AS MTD_total_Amount_Recive,
    SUM(loan_amount) AS MTD_Loan_Amount
FROM
	bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
GROUP BY 
	loan_status;
    
-- Calculating Monthly total loan application and total funded amount and total amount recived

-- bank loan report overview on the basis of month
SELECT
	MONTH(issue_date) AS Month_Number,
    MONTHNAME(issue_date) AS Month_Name,
    YEAR(issue_date) AS 'Year',
    COUNT(id) AS Total_Loan_Application,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Recived_Amount
FROM 
	bank_loan
GROUP BY MONTH(issue_date), MONTHNAME(issue_date),YEAR(issue_date)
ORDER BY MONTH(issue_date);

-- BANK loan report on the basis of state

SELECT
	address_state AS state,
    COUNT(id) AS Total_Loan_Application,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Recived_Amount
FROM 
	bank_loan
GROUP BY address_state
ORDER BY address_state;

-- Bank Loan REport on basis of TERMS
SELECT
	term AS Term,
    COUNT(id) AS Total_Loan_Application,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Recived_Amount
FROM 
	bank_loan
GROUP BY term
ORDER BY term;

--  Bank Loan REport on basis of EMployee Length
SELECT
	emp_length AS Employee_Length,
    COUNT(id) AS Total_Loan_Application,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Recived_Amount
FROM 
	bank_loan
GROUP BY emp_length
ORDER BY emp_length;

-- Bank Loan REport on basis of Perpose
SELECT
	purpose AS Purpose_of_Loan,
    COUNT(id) AS Total_Loan_Application,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Recived_Amount
FROM 
	bank_loan
GROUP BY purpose
ORDER BY purpose;

-- Bank Loan REport on basis of home_ownership
SELECT
	home_ownership AS Home_Ownership,
    COUNT(id) AS Total_Loan_Application,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Recived_Amount
FROM 
	bank_loan
GROUP BY home_ownership
ORDER BY home_ownership;