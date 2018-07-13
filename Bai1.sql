-- Use employees;

-- 1. Liệt kê 10 nhân viên bắt đầu làm việc từ năm 1999
Select *
From employees
Where year(employees.hire_date) = 1999
Limit 10;

-- 2. Đếm số nhân viên nữ có ngày sinh từ năm 1950 đến năm 1960 mà last_name có 3 chữ cái đầu là “Mon”
Select COUNT(*) as Number_Female_Emp
From employees
Where year(employees.birth_date) between 1950 And 1960
	AND employees.last_name LIKE 'Mon%'
    AND employees.gender = 'F';

-- 3. Lấy ra các nội dung sau của nhân viên có id = 10005: first_name, last_name, hire_date, salary_total.
-- Trong đó salary_total là tổng lương của nhân viên 10005 trong toàn bộ thời gian anh ta giữ chức vụ “Staff” – trong bảng titles.

Select emp.first_name, emp.last_name, emp.hire_date, salary_total_table.salary_total
From employees as emp
Inner Join (
	Select SUM(salaries.salary) as salary_total
	From salaries
	Inner Join titles
	On salaries.emp_no = '10005'
		AND salaries.emp_no = titles.emp_no
		AND titles.from_date <= salaries.from_date
		AND salaries.to_date <= titles.to_date
		AND titles.title = 'Staff'
) as salary_total_table
Where emp.emp_no = '10005';

-- 4. Tìm xem người quản lý có tên là Margareta Markovitch trong thời gian giữ chức quản lý 
-- thì đã quản lý bao nhiêu nhân viên

Select COUNT(*) as Number_Emp
From employees
Inner Join dept_manager
Inner Join dept_emp
On employees.emp_no = dept_manager.emp_no
    AND dept_emp.dept_no = dept_manager.dept_no
Where employees.first_name = 'Margareta'
	AND employees.last_name = 'Markovitch'
    AND dept_emp.from_date <= dept_manager.to_date
    AND dept_manager.from_date <= dept_emp.to_date
    AND employees.emp_no != dept_emp.emp_no;

-- 5. Tìm xem tổng lương phải trả của mỗi phòng ban trong khoản thời gian from_date = 1988-06-25
-- đến to_date 1989-06-25 (from_date, to_date từ bảng salaries) là bao nhiêu 
-- và lọc những phòng ban trả tổng lương cao hơn 3 triệu$

Select dept_emp.dept_no, SUM(salaries.salary) as salary_total
From salaries
Inner Join dept_emp
On salaries.emp_no = dept_emp.emp_no
Where salaries.from_date >= '1988-06-26'
	AND salaries.to_date <= '1989-06-25'
Group by dept_emp.dept_no
HAVING salary_total > 3000000;

