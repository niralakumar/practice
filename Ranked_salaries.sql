
employee
eid, firstname, lastname, salary, dept_id

department
dept_id, dept_name

highest paid employee in each dept

o/p : firstname, lastname, dept_name, salary


Approach 1:


select firstname, lastname, dept_name, salary from (
with cte grouped_employee as (
select  e.dept_id, max(salary) max_salary
from employee  e
group by dept_id
) 
select e.firstname,e.lastname,dept.dept_name, emp.max_salary as salary, row_number() over(partition by dept.dept_id order by emp.max_salary  ) rn
from grouped_employee emp
inner join employee e 
on e.dept_id=emp.dept_id
inner join  department dept 
on dept.dept_id=emp.dept_id
) where rn=1

Approach 2: 
WITH RankedSalaries AS (
    SELECT 
        e.firstname,
        e.lastname,
        d.dept_name,
        e.salary,
        ROW_NUMBER() OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC) AS rnk
    FROM 
        employee e
    JOIN 
        department d ON e.dept_id = d.dept_id
)
SELECT 
    firstname,
    lastname,
    dept_name,
    salary
FROM 
    RankedSalaries
WHERE 
    rnk = 1;