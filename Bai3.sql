-- Use employees;
-- 
-- Viết một Stored Procedure với input là tên nhân viên. Cần trả lại 2 result - kết quả :
-- 3.1. Kết quả 1: Lấy ra id, full name, giới tính, title (hay  chức vụ), tên phòng ban
-- 3.2. Kết quả 2: Tính tổng lương của từng người có tên đó trong khoảng thời gian từ lúc nhận lương đến thời điểm hiện tại

DELIMITER //
Create Procedure sp_bai3 (IN first_name Varchar(14))
Begin
	
	Create Temporary Table result1_bai3
	Select employees.emp_no, concat(employees.first_name, " ", employees.last_name) as full_name,
		employees.gender, titles.title, departments.dept_name
    From employees
	Inner Join titles
	Inner Join departments
	Inner Join dept_emp
	On employees.emp_no = titles.emp_no
		AND employees.emp_no = dept_emp.emp_no
		AND dept_emp.dept_no = departments.dept_no
	Where employees.first_name = first_name
		AND titles.to_date = '9999-01-01'
        AND dept_emp.to_date = '9999-01-01';  
	
    Create Temporary Table result2_bai3
    Select employees.emp_no, concat(employees.first_name, " ", employees.last_name) as full_name,
		SUM(salaries.salary) as salary_total
    From employees
    Inner Join salaries
    ON employees.emp_no = salaries.emp_no
    Where employees.first_name = first_name
		-- AND salaries.to_date != '9999-01-01'
    Group by employees.emp_no, employees.first_name, employees.last_name;
    
End//
DELIMITER ;

CALL sp_bai3('Mary'); 

