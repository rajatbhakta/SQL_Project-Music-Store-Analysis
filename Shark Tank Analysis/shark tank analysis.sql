-- Create Projectdata Table
CREATE TABLE projectdata (
    Ep_No INT,
    Brand VARCHAR(255),
    Male INT,
    Female INT,
    Location VARCHAR(255),
    Idea VARCHAR(300),
    Sector VARCHAR(255),
    Deal TEXT,
    Amount_Invested_lakhs INT,
    Amount_Asked INT,
    Debt_Invested INT,
    Debt_Asked INT,
    Equity_Taken FLOAT,
    Equity_Asked FLOAT,
    Avg_Age TEXT,
    Team_Members INT,
    Ashneer_Amount_Invested VARCHAR(255),
    Ashneer_Equity_Taken VARCHAR(255),
    Namita_Amount_Invested VARCHAR(255),
    Namita_Equity_Taken VARCHAR(255),
    Anupam_Amount_Invested VARCHAR(255),
    Anupam_Equity_Taken VARCHAR(255),
    Vineeta_Amount_Invested VARCHAR(255),
    Vineeta_Equity_Taken VARCHAR(255),
    Aman_Amount_Invested VARCHAR(255),
    Aman_Equity_Taken VARCHAR(255),
    Peyush_Amount_Invested VARCHAR(255),
    Peyush_Equity_Taken VARCHAR(255),
    Ghazal_Amount_Invested VARCHAR(255),
    Ghazal_Equity_Taken VARCHAR(255),
    Total_Investors INT,
    Partners TEXT
);


COPY projectdata (Ep_No, Brand, Male, Female, Location, Idea, Sector, Deal, Amount_Invested_lakhs, Amount_Asked, Debt_Invested, Debt_Asked, Equity_Taken, Equity_Asked, Avg_Age, Team_Members, Ashneer_Amount_Invested, Ashneer_Equity_Taken, Namita_Amount_Invested, Namita_Equity_Taken, Anupam_Amount_Invested, Anupam_Equity_Taken, Vineeta_Amount_Invested, Vineeta_Equity_Taken, Aman_Amount_Invested, Aman_Equity_Taken, Peyush_Amount_Invested, Peyush_Equity_Taken, Ghazal_Amount_Invested, Ghazal_Equity_Taken, Total_Investors, Partners)
FROM 'C:\Users\Administrator\Downloads\SHARK TANK DATAAS.csv' 
DELIMITER ','
CSV HEADER;

select * from projectdata;

select count(*) from projectdata

-- total episodes
	
select max(Ep_No) as max_ep_no from projectdata;
select count(distinct Ep_No) as unique_ep from projectdata;

-- total count of unique pitches 

select count(distinct (brand)) as unique_pitches from projectdata

--pitches converted

select count(distinct(brand)) as brand_converted, sum(equity_taken), avg(equity_taken) from projectdata
where equity_taken > 0 and equity_taken is not null

-- total male

select sum(male) as total_males from projectdata 

-- total female

select sum(female) from projectdata

--gender ratio

SELECT 
    CAST(SUM(female) AS FLOAT) / CAST(SUM(male) AS FLOAT) AS ratio_female_to_male
FROM 
    projectdata;


-- total invested amount

select sum(amount_invested_lakhs) from projectdata

-- avg equity taken

select avg(equity_taken) from projectdata
where equity_taken>0

--highest deal taken

select max(amount_invested_lakhs) as biggest_deal from projectdata 

--higheest equity taken

select max(equity_taken) as highest_equity_taken from projectdata

-- startups having at least one woman

select distinct(brand) from projectdata
	where female > 0 and female is not null

-- pitches converted having atleast one women

select count(distinct(brand)) as pitches_converted,
sum(amount_invested_lakhs) as total_fund_raised,
avg(amount_invested_lakhs) as avg_fund_raised, avg(female) as avg_female, sum(female) as total_female
from projectdata
where female > 0 and amount_invested_lakhs > 0;

/* OR */

select distinct(brand), female as female_count from projectdata
	group by distinct(brand), female
	having female > 0
	order by female desc
	
-- avg team members

select avg(team_members) as average_Team_members from projectdata

-- amount invested per deal

	
select avg(b.amount_invested_lakhs) as avg_amount_invested from (
	select * from projectdata where 
	deal!='No Deal') as b
	
-- avg age group of contestants

select avg_age,count(avg_age) as count_of_age from
	(select * from projectdata where avg_age is not null)
	group by avg_age
	order by count_of_age desc
	

-- location group of contestants

select location as _location_,count(location) cnt from 
	(select * from projectdata where location is not null) 
	group by _location_
	order by cnt desc

-- sector group of contestants?

select sector,count(sector) cnt from 
	(select * from projectdata where sector is not null)  
	group by sector order by cnt desc


--partner deals?

select partners,count(partners) cnt from projectdata
	where partners!='-'
	group by partners order by cnt desc



-- which is the startup in which the highest amount has been invested in each domain/sector


select c.brand,c.sector,c.amount_invested_lakhs from 
(select brand,sector,amount_invested_lakhs,
	rank() over (partition by sector order by amount_invested_lakhs desc) rnk 

from projectdata) c

where c.rnk=1 and c.sector is not null 

