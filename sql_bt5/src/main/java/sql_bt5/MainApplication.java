package sql_bt5;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

public class MainApplication {

	private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
	private static final String DB_CONNECTION = "jdbc:mysql://localhost:3306/employees_2";
	private static final String DB_USER = "root";
	private static final String DB_PASSWORD = "root";

	public static void main(String[] args) throws SQLException {
		int emp_id = 100129;
		String new_dept_id = "d007";
		String new_title = "QA";

		// useCallableStatement(emp_id, new_dept_id, new_title);
//		usePreparedStatement(emp_id, new_dept_id, new_title);
		createTransaction(emp_id, new_title);

	}

	private static void useCallableStatement(int emp_id, String new_dept_id, String new_title) throws SQLException {
		Connection dbConnection = null;
		CallableStatement stmt = null;

		try {
			dbConnection = getDBConnection();
			if (dbConnection != null) {
				System.out.println("Use Callable Statement");

				String sql = "{Call sp_bai4(?,?,?,?,?,?,?,?)}";
				stmt = dbConnection.prepareCall(sql);

				stmt.registerOutParameter(4, Types.INTEGER);
				stmt.registerOutParameter(5, Types.VARCHAR);
				stmt.registerOutParameter(6, Types.CHAR);
				stmt.registerOutParameter(7, Types.VARCHAR);
				stmt.registerOutParameter(8, Types.VARCHAR);

				stmt.setInt(1, emp_id);
				stmt.setString(2, new_dept_id);
				stmt.setString(3, new_title);

				stmt.executeQuery();

				Integer out_emp_id = stmt.getInt("out_emp_id");
				String out_full_name = stmt.getString("out_full_name");
				String out_gender = stmt.getString("out_gender");
				String out_new_title = stmt.getString("out_new_title");
				String out_dept_name = stmt.getString("out_dept_name");

				System.out.println("\n======= Result retrieve from calling sp_bai4 =======");

				System.out.println("Out emp id    : " + out_emp_id);
				System.out.println("Out full name : " + out_full_name);
				System.out.println("Out gender    : " + out_gender);
				System.out.println("Out new title : " + out_new_title);
				System.out.println("Out dept name : " + out_dept_name);

				System.out.println("=======================");

			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (dbConnection != null) {
				if (stmt != null) {
					stmt.close();
				}
				dbConnection.close();
			}
		}
	}

	private static void usePreparedStatement(int emp_id, String new_dept_id, String new_title) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement stmt = null;

		try {
			dbConnection = getDBConnection();
			if (dbConnection != null) {
				System.out.println("Use Prepared Statement");

				String sql = "Call sp_bai4_prep(?,?,?)";
				stmt = dbConnection.prepareStatement(sql);

				stmt.setInt(1, emp_id);
				stmt.setString(2, new_dept_id);
				stmt.setString(3, new_title);

				ResultSet rs = stmt.executeQuery();
				rs.next();

				int out_emp_id = rs.getInt("out_emp_id");
				System.out.println("Out emp id    : " + out_emp_id);
				String out_full_name = rs.getString("out_full_name");
				String out_gender = rs.getString("out_gender");
				String out_new_title = rs.getString("out_new_title");
				String out_dept_name = rs.getString("out_dept_name");

				System.out.println("\n======= Result retrieve from calling sp_bai4 =======");

				System.out.println("Out emp id    : " + out_emp_id);
				System.out.println("Out full name : " + out_full_name);
				System.out.println("Out gender    : " + out_gender);
				System.out.println("Out new title : " + out_new_title);
				System.out.println("Out dept name : " + out_dept_name);

				System.out.println("=======================");

			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (dbConnection != null) {
				if (stmt != null) {
					stmt.close();
				}
				dbConnection.close();
			}
		}
	}

	private static void createTransaction(int emp_id, String new_title) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement stmt = null;
		String sql = "";

		try {
			dbConnection = getDBConnection();
			if (dbConnection != null) {
				System.out.println("Create transaction ...");

				// Start transaction
				stmt = dbConnection.prepareStatement("Start Transaction");
				stmt.executeQuery();
				stmt.executeQuery("Savepoint sv_point");
				
				try {
					sql = "Update titles Set to_date = curdate() "
							+ "Where titles.emp_no = ? AND to_date = '9999-01-01'";
					stmt = dbConnection.prepareStatement(sql);
					stmt.setInt(1, emp_id);
					stmt.executeUpdate();

					sql = "Insert Into titles\n" + "Values (?, ?, curdate(), '9999-01-01')";
					stmt = dbConnection.prepareStatement(sql);
					stmt.setInt(1, emp_id);
					stmt.setString(2, new_title);
					stmt.executeUpdate();
					
					// Commit transaction
					stmt.executeQuery("Commit");
					System.out.println("Commit transaction done");

				} catch (SQLException ex) {
					System.out.println("Rollback !!");
					ex.printStackTrace();
					
					// Rollback
					stmt.executeQuery("Rollback to sv_point");
					stmt.executeQuery("Release Savepoint sv_point");
					
				} 
				

			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (dbConnection != null) {
				if (stmt != null) {
					stmt.close();
				}
				dbConnection.close();
			}
		}
	}

	private static Connection getDBConnection() {

		Connection dbConnection = null;

		try {
			Class.forName(DB_DRIVER);
		} catch (ClassNotFoundException e) {
			System.out.println(e.getMessage());
		}

		try {
			dbConnection = DriverManager.getConnection(DB_CONNECTION, DB_USER, DB_PASSWORD);
			System.out.println("Connect database is successfull");
			return dbConnection;
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		return dbConnection;

	}
}
