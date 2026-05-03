package com.civicwatch.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.io.File;

public class DBConnection {
    private static String DB_URL;
    private static String DB_USER;
    private static String DB_PASSWORD;
    private static String DB_DRIVER;

    static {
        loadConfiguration();
    }

    private static void loadConfiguration() {
        Properties props = new Properties();

        try {
            File configFile = new File("src/db.properties");
            if (configFile.exists()) {
                try (FileInputStream fis = new FileInputStream(configFile)) {
                    props.load(fis);
                    DB_URL = props.getProperty("db.url", "jdbc:mysql://localhost:3306/civicwatch?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
                    DB_USER = props.getProperty("db.user", "root");
                    DB_PASSWORD = props.getProperty("db.password", "");
                    DB_DRIVER = props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
                    return;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        try (InputStream input = DBConnection.class.getClassLoader()
                .getResourceAsStream("db.properties")) {
            if (input != null) {
                props.load(input);
                DB_URL = props.getProperty("db.url", "jdbc:mysql://localhost:3306/civicwatch?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
                DB_USER = props.getProperty("db.user", "root");
                DB_PASSWORD = props.getProperty("db.password", "");
                DB_DRIVER = props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
                return;
            }
        } catch (IOException e) {
        }

        setDefaultConfiguration();
    }

    private static void setDefaultConfiguration() {
        DB_URL = "jdbc:mysql://localhost:3306/civicwatch?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        DB_USER = "root";
        DB_PASSWORD = "";
        DB_DRIVER = "com.mysql.cj.jdbc.Driver";
        System.out.println("DB Connection using defaults: URL=" + DB_URL + ", USER=" + DB_USER);
    }

    public static Connection getConnection() throws SQLException {
        System.out.println("Getting connection for: URL=" + DB_URL + ", USER=" + DB_USER + ", PASS_LENGTH=" + (DB_PASSWORD != null ? DB_PASSWORD.length() : "null"));
        try {
            Class.forName(DB_DRIVER);
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found: " + DB_DRIVER, e);
        }
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void rollback(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
