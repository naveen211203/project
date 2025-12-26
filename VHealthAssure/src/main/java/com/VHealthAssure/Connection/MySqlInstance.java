package com.VHealthAssure.Connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MySqlInstance {
	private static MySqlInstance instance;
	Connection con;
	private MySqlInstance() {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con=DriverManager.getConnection("jdbc:mysql://localhost:3306/InsuranceDB","root","naveen");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static MySqlInstance getinstance() throws SQLException {
		if(instance==null || instance.getConnection().isClosed()) {
			instance=new MySqlInstance();
		}
		return instance;
	}
	public Connection getConnection() {
		return con;
	}
}
