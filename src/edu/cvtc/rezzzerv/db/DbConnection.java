package edu.cvtc.rezzzerv.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnection {

    private static final String URL = "jdbc:sqlite:ReZZZerv.db";
    private static Connection connection = null;

    private DbConnection() {
    }

    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                connection = DriverManager.getConnection(URL);
                System.out.println("Connection established");
            }
        } catch (SQLException e) {
            System.out.println("Error trying to connect to the database");
            e.printStackTrace();
        }
        return connection;
    }

    public static void closeConnection() {
        if (connection != null) {
            try {
                if (!connection.isClosed()) {
                    connection.close();
                    System.out.println("Connection closed");
                }
            } catch (SQLException e) {
                System.out.println("Error closing the connection");
                e.printStackTrace();
            }
        }
    }
}
