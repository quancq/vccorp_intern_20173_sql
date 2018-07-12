Use employees_2;

-- Select dept_manager.*, dept_emp.from_date, dept_emp.to_date, departments.dept_name, employees.hire_date
-- From dept_emp
-- Inner Join dept_manager
-- Inner Join departments
-- Inner Join employees
-- ON dept_emp.dept_no = dept_manager.dept_no 
-- 	AND dept_emp.emp_no = dept_manager.emp_no
--     AND dept_emp.dept_no = departments.dept_no
--     AND employees.emp_no = dept_emp.emp_no

-- Select employees.hire_date, titles.*
-- From employees
-- Inner Join titles
-- Inner Join dept_manager
-- On employees.emp_no = titles.emp_no
-- 	AND dept_manager.from_date = titles.from_date
--     AND dept_manager.to_date = titles.to_date
--     AND dept_manager.emp_no = titles.emp_no

Select *
From dept_emp
Right Join dept_manager
On dept_emp.dept_no = dept_manager.dept_no
	AND dept_emp.emp_no = dept_manager.emp_no;

Select Count(*)
From dept_emp
Inner Join departments
On departments.dept_no = dept_emp.dept_no
Where departments.dept_name = 'Production';

Show Create Table titles;

Select *
From departments
-- Inner Join dept_emp
-- On departments.dept_no = dept_emp.dept_no
Where departments.dept_name = 'Production';

Select Distinct title
From titles;

Show Create Table departments;

Select Distinct dept_no
From departments
order by dept_no;

Select *
From dept_emp
Where dept_emp.emp_no = '10173';

Select *
From titles
Where emp_no = '10173';
