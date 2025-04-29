package db;

import io.github.cdimascio.dotenv.Dotenv;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DbConnection {

    private static Connection connection = null;

    private DbConnection() {
    }

    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                //Dotenv dotenv = Dotenv.load();

                Dotenv dotenv = Dotenv.configure()
                        .directory("/etc/secrets") // for render
                        .ignoreIfMalformed()
                        .ignoreIfMissing()
                        .load();

                if (dotenv.get("DB_HOST") == null) {
                    // if the file is not in /etc/secrets, load the local one
                    dotenv = Dotenv.load();
                }

                String DB_HOST = dotenv.get("DB_HOST");
                String DB_NAME = dotenv.get("DB_NAME");
                String USER = dotenv.get("DB_USER");
                String PASSWORD = dotenv.get("DB_PASSWORD");

                Properties properties = new Properties();
                properties.setProperty("user", USER);
                properties.setProperty("password", PASSWORD);

                String url = "jdbc:mysql://" + DB_HOST + ":3306/" + DB_NAME + "?serverTimezone=UTC";

                Class.forName("com.mysql.cj.jdbc.Driver");

                connection = DriverManager.getConnection(url, properties);
                System.out.println("Local MySQL connection established");

            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error trying to connect to the database");
            e.printStackTrace();
            throw new RuntimeException("Database connection failed.", e);
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
