package edu.cvtc.rezzzerv.daos;

import edu.cvtc.rezzzerv.db.DbConnection;
import edu.cvtc.rezzzerv.model.users.Administrator;
import edu.cvtc.rezzzerv.model.users.Customer;
import edu.cvtc.rezzzerv.model.users.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao {

    public void insertUser(User user) {
        String sql = "INSERT INTO users (name, lastName, phone, email, password, userType) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = DbConnection.getConnection();
        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            prepareUserStatement(pstmt, user);
            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    user.setId(rs.getLong(1));  // Assign id
                }
            }

            System.out.println("User Created: " + user.getName());
        } catch (SQLException e) {
            System.out.println("Error Creating user user");
            e.printStackTrace();
        }
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users";
        Connection conn = DbConnection.getConnection();
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                users.add(resultSetForUser(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error retrieving users");
            e.printStackTrace();
        }
        return users;
    }

    public User getUserById(Long id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        User user = null;
        Connection conn = DbConnection.getConnection();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = resultSetForUser(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving user by id");
            e.printStackTrace();
        }
        return user;
    }

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        Connection conn = DbConnection.getConnection();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return resultSetForUser(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error finding user by email");
            e.printStackTrace();
        }
        return null;
    }

    public void updateUser(User user) {
        String sql = "UPDATE users SET name = ?, lastName = ?, phone = ?, email = ?, password = ?, userType = ? WHERE id = ?";
        Connection conn = DbConnection.getConnection();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            prepareUserStatement(pstmt, user);
            pstmt.setLong(7, user.getId());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("User updated: " + user.getName());
            } else {
                System.out.println("No user found with id: " + user.getId());
            }
        } catch (SQLException e) {
            System.out.println("Error updating user");
            e.printStackTrace();
        }
    }

    public void deleteUser(Long id) {
        String sql = "DELETE FROM users WHERE id = ?";
        Connection conn = DbConnection.getConnection();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, id);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("User deleted with id: " + id);
            } else {
                System.out.println("No user found with id: " + id);
            }
        } catch (SQLException e) {
            System.out.println("Error deleting user");
            e.printStackTrace();
        }
    }

    private User resultSetForUser(ResultSet rs) throws SQLException {
        String userType = rs.getString("userType");
        User user;

        if ("Administrator".equals(userType)) {
            user = new Administrator();
        } else if ("Customer".equals(userType)) {
            user = new Customer();
        } else {
            throw new IllegalArgumentException("unknown user type: " + userType);
        }

        user.setId(rs.getLong("id"));
        user.setName(rs.getString("name"));
        user.setLastName(rs.getString("lastName"));
        user.setPhone(rs.getString("phone"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));

        return user;
    }

    private void prepareUserStatement(PreparedStatement pstmt, User user) throws SQLException {
        pstmt.setString(1, user.getName());
        pstmt.setString(2, user.getLastName());
        pstmt.setString(3, user.getPhone());
        pstmt.setString(4, user.getEmail());
        pstmt.setString(5, user.getPassword());
        pstmt.setString(6, user instanceof Administrator ? "Administrator" : "Customer");
    }

}
