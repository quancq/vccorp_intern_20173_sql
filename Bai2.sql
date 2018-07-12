Use employees_2;

-- 1. Thăng chức cho nhân viên 10002 từ “Staff” lên “Senior Staff”. 
-- Lưu ý, phải dừng chức vụ hiện tại mới được chuyển chức vụ mới.

-- Dừng chức vụ hiện tại
-- Update titles
-- Set to_date = curdate()
-- Where titles.emp_no = '10002' AND to_date = '9999-01-01';

-- Thêm chức vụ 'Senior Staff'
-- Insert Into titles
-- Values ('10002', 'Senior Staff', curdate(), '9999-01-01')


-- =============================================================

-- 2. Hãy xóa phòng ban Production cùng toàn bộ nhân viên của phòng này,
-- cùng với tất cả các dữ liệu có liên quan.

-- Xóa các nhân viên thuộc phòng ban Production
Delete From employees
Where employees.emp_no IN (
	Select dept_emp.emp_no
    From departments Inner Join dept_emp
    On departments.dept_no = dept_emp.dept_no
    Where departments.dept_name = 'Production'
);


-- Xóa phòng ban Production
Delete From departments
Where dept_name = 'Production';


-- =============================================================

-- 3. Thêm phòng ban mới “Bigdata & ML” và bổ nhiệm nhân viên có ID = 10173 lên làm quản lý.

-- Thêm phòng ban mới
Insert Into departments
Values ('d010', 'Bigdata & ML');

-- Kết thúc quá trình làm việc của nhân viên ID = 10173 ở phòng ban hiện tại
Update dept_emp
Set to_date = curdate()
Where emp_no = '10173' AND to_date = '9999-01-01';

-- Dừng chức vụ hiện tại trong bảng titles
Update titles
Set to_date = curdate()
Where emp_no = '10173' AND to_date = '9999-01-01';

-- Thêm bản ghi vào bảng liên kết dept_emp va dept_manager
Insert Into dept_emp
Values ('d010', '10173', curdate(), '9999-01-01');

Insert Into dept_manager
Values ('d010', '10173', curdate(), '9999-01-01');

-- Thêm chức vụ mới trong bảng titles
Insert Into titles
Values ('10173', 'Manager', curdate(), '9999-01-01');

-- =============================================================