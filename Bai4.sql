-- Viết một Store Procedure để thuyên chuyển phòng ban cho một nhân viên nào đó, với chức vụ mới 
-- (không chuyển lên làm quản lý). Đồng thời trả lại một kết quả bao gồm:
-- ra id, full name, giới tính, title (hay  chức vụ), tên phòng ban

-- SP này để gọi bằng Callable Statement trong Java
-- DELIMITER //
-- Create Procedure sp_bai4 (
-- 	IN emp_id Int(11),
--     IN new_dept_id Varchar(4),
--     IN new_title Varchar(50),
--     OUT out_emp_id Int(11),
--     OUT out_full_name Varchar(31),
--     OUT out_gender Char(6),
--     OUT out_new_title Varchar(50),
--     OUT out_dept_name Varchar(40)
-- )    
-- Begin
-- 	-- Thực hiện thuyên chuyển phòng ban cho nhân viên
--     
--     -- Kết thúc quá trình làm việc của nhân viên ở phòng ban hiện tại
-- 	Update dept_emp
-- 	Set to_date = curdate()
-- 	Where emp_no = emp_id AND to_date = '9999-01-01';
-- 
-- 	-- Dừng chức vụ hiện tại trong bảng titles
-- 	Update titles
-- 	Set to_date = curdate()
-- 	Where emp_no = emp_id AND to_date = '9999-01-01';
-- 
-- 	-- Thêm bản ghi vào bảng liên kết dept_emp
-- 	Insert Into dept_emp
-- 	Values (emp_id, new_dept_id, curdate(), '9999-01-01');
-- 
-- 	-- Thêm chức vụ mới trong bảng titles
-- 	Insert Into titles
-- 	Values (emp_id, new_title, curdate(), '9999-01-01');
--    
--     -- Tính toán kết quả trả về
--     SET out_emp_id = emp_id;
--     
--     Select concat(employees.first_name, " ", employees.last_name) 
--     Into out_full_name
--     From employees
--     Where employees.emp_no = emp_id;
--     
--     Select gender
--     Into out_gender
--     From employees
--     Where employees.emp_no = emp_id;
--     
--     SET out_new_title = new_title;
--     
--     Select dept_name
--     Into out_dept_name
--     From departments
--     Where dept_no = new_dept_id;
-- 
-- End//
-- DELIMITER ;

-- ========================================

-- SP này để gọi bằng Prepared Statement trong Java
DELIMITER //
Create Procedure sp_bai4_prep (
	IN emp_id Int(11),
    IN new_dept_id Varchar(4),
    IN new_title Varchar(50)
)    
Begin
	-- Thực hiện thuyên chuyển phòng ban cho nhân viên
    
    -- Kết thúc quá trình làm việc của nhân viên ở phòng ban hiện tại
	Update dept_emp
	Set to_date = curdate()
	Where emp_no = emp_id AND to_date = '9999-01-01';

	-- Dừng chức vụ hiện tại trong bảng titles
	Update titles
	Set to_date = curdate()
	Where emp_no = emp_id AND to_date = '9999-01-01';

	-- Thêm bản ghi vào bảng liên kết dept_emp
	Insert Into dept_emp
	Values (emp_id, new_dept_id, curdate(), '9999-01-01');

	-- Thêm chức vụ mới trong bảng titles
	Insert Into titles
	Values (emp_id, new_title, curdate(), '9999-01-01');
   
    -- Tính toán kết quả trả về

--     Select emp_id as out_emp_id;
    
    Select emp_id as out_emp_id, 
		concat(employees.first_name, " ", employees.last_name) as out_full_name,
        gender as out_gender,
        new_title as out_new_title,
        departments.dept_name as out_dept_name
	From employees
    Inner Join departments
    Where employees.emp_no = emp_id
		AND departments.dept_no = new_dept_id;
        
		
 --    From employees
--     Where employees.emp_no = emp_id;
--     
--     Select gender as out_gender
--     From employees
--     Where employees.emp_no = emp_id;
--     
--     Select new_title as out_new_title;
--     
--     Select dept_name as out_dept_name
--     From departments
--     Where dept_no = new_dept_id;

End//
DELIMITER ;
