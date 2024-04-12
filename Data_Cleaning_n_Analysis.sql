use projects;
select * from hr;
#Changing table name using alter statement
alter table hr 
change column ï»¿id emp_id varchar(20) null;
alter table hr modify column emp_id int;

describe hr;

#Converting string to fdate formarts
 update hr
 set birthdate = case 
	when birthdate like "%/%" then date_format(str_to_date(birthdate,"%m/%d/%Y"),"%Y-%m-%d")
    when birthdate like "%-%" then date_format(str_to_date(birthdate,"%m-%d-%Y"),"%Y-%m-%d")
    else null
    end;
    
select birthdate from hr;
 #Change column birthdate 
 alter table hr
 Modify column birthdate date;
 
 
 #Converting hire date
 update hr
 set hire_date = case 
	when hire_date like "%/%" then date_format(str_to_date(hire_date,"%m/%d/%Y"),"%Y-%m-%d")
    when hire_date like "%-%" then date_format(str_to_date(hire_date,"%m-%d-%Y"),"%Y-%m-%d")
    else null
    end;
select hire_date from hr;
#Change column birthdate 
 alter table hr
 Modify column hire_date date;
 
 describe hr;
 #Update the term date field
 update hr
 set termdate = date(str_to_date(termdate,"%Y-%m-%d %H:%i:%s UTC"))
 where termdate != null and termdate = "";
 select termdate from hr;
 
#Change column termdate 
 alter table hr
 Modify column termdate date;
 
 #Add Age colum
 alter table hr add column age int ;
 
 #Calculating the age
 update hr
 set age = timestampdiff(year,birthdate,current_date());
 
 select timestampdiff(year,birthdate,current_date()) from hr;
 
 #Check for outliers
 Select min(age) as youngest,max(age) as oldest from hr;
 
 #What is the gender breakdown of employees in the company
 Select gender , count(*) as Total from hr
 where age >=18 and termdate =""
 group by gender
 order by total desc;
 
#What is the age distribution in the comapny
select min(age) as youngest, max(age) as oldest from hr
where age >=18 and termdate ="";

#Use age groups
select count(*) as Total, case 
when age >= 18 and age <= 24 then "18-24"
when age >= 25 and age <= 34 then "25-34"
when age >= 35 and age <= 44 then "35-44"
when age >= 45 and age <= 54 then "45-54"
when age >= 55 and age <= 64 then "55-64"
else "65+" 

end as age_group

from hr
where age >=18 and termdate =""
group by age_group
order by age_group asc;

#How age groups in between and gender distribution
select min(age) as youngest, max(age) as oldest from hr
where age >=18 and termdate ="";

#Use age groups
select distinct case 
when age >= 18 and age <= 24 then "18-24"
when age >= 25 and age <= 34 then "25-34"
when age >= 35 and age <= 44 then "35-44"
when age >= 45 and age <= 54 then "45-54"
when age >= 55 and age <= 64 then "55-64"
else "65+" 

end as age_group,gender,
count(*) as count
from hr
where age >=18 and termdate =""
group by age_group,gender
order by age_group,gender asc;

#How many employee work at Headquaters
Select location ,count(*) as count from hr
where age >=18 and termdate =""
group by location;

#Years employee worked in the company before they were fired 
select round(avg(datediff(termdate,hire_date))/365,0) as avg_length_of_employment from hr
where termdate <= current_date() and termdate !="" and age >=18;

#What is the gender distribution accross departments
select department,gender,count(*) as count
from hr
where age >=18 and termdate =""
group by department,gender
order by department;

#What is the distribution of Job titles across the company
select jobtitle,count(*) as count
from hr
where age >=18 and termdate =""
group by jobtitle
order by jobtitle asc;

#Which department has the highest turnover rate(rate at which employee leave the company)

select department,total_count,terminated_count,terminated_count/total_count as termination_rate 
from (select department,
count(*) as total_count,
sum(case when termdate != "" and termdate <= current_date() then 1 else 0 end) as terminated_count
from hr
where age >= 18
group by department) as subQ
order by termination_rate desc;

#Distribution of employees across cities and states
Select location_state,count(*) as count from hr
where age >=18 and termdate =""
group by location_state;

#10. How many has the company empyee count changed over time based on hire and therm dates
select year,number_of_hires,terminations, number_of_hires- terminations as net_change,round((number_of_hires-terminations)/number_of_hires*100,2) as net_chnages_percent
from  (select year(hire_date) as year, count(*) as number_of_hires,
sum(case when termdate != "" and termdate <= current_date() then 1 else 0 end) as terminations
from hr
where age >= 18 
group by year
 ) as sub 
 order by year asc
 
#11. How long employees stay in each department
