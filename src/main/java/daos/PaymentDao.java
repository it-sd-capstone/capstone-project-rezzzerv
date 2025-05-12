package daos;

import db.DbConnection;
import model.payment.Payment;
import model.reserve.Reserve;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDao {

    public void insertPayment(Payment payment) {
        String sql = "INSERT INTO payments (cardNumber, amount, paidDate, reserveId) VALUES (?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, payment.getCardNumber());
            pstmt.setDouble(2, payment.getAmount());

            pstmt.setDate(3, Date.valueOf(payment.getPaidDate()));  // turn LocalDate to Date

            pstmt.setLong(4, payment.getReserve().getId());

            pstmt.executeUpdate();

            // Obtener el ID generado
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    payment.setId(rs.getLong(1));
                }
            }

            System.out.println("Payment created with Id: " + payment.getId());
        } catch (SQLException e) {
            System.out.println("Error while creating payment");
            e.printStackTrace();
        }
    }

    //List of Payments
    public List<Payment> getAllPayments() {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments";
        try (Connection conn = DbConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                payments.add(mapRowToPayment(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error trying to get payments list");
            e.printStackTrace();
        }
        return payments;
    }

    // get payment by id
    public Payment getPaymentById(Long id) {
        String sql = "SELECT * FROM payments WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToPayment(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error trying to get payment");
            e.printStackTrace();
        }
        return null;
    }

    // update payment
    public void updatePayment(Payment payment) {
        String sql = "UPDATE payments SET cardNumber = ?, amount = ?, paidDate = ?, reserveId = ? WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, payment.getCardNumber());
            pstmt.setDouble(2, payment.getAmount());

            // date without hours
            pstmt.setDate(3, Date.valueOf(payment.getPaidDate()));
            pstmt.setLong(4, payment.getReserve().getId());
            pstmt.setLong(5, payment.getId());
            int rows = pstmt.executeUpdate();
            System.out.println(rows > 0 ? "Payment Updated" : "Payment Id : " + payment.getId() + " Not found");
        } catch (SQLException e) {
            System.out.println("Error updating Payment");
            e.printStackTrace();
        }
    }

    //Delete payment by ID
    public void deletePayment(Long id) {
        String sql = "DELETE FROM payments WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, id);
            int rows = pstmt.executeUpdate();
            System.out.println(rows > 0 ? "Payment eliminated with ID: " + id : "Payment not found with ID: " + id);
        } catch (SQLException e) {
            System.out.println("Error eliminating payment");
            e.printStackTrace();
        }
    }

    public Payment findPaymentByReserveId(Long reserveId){
        String sql = "SELECT * FROM payments WHERE reserveId = ?";
        Payment payment = null;

        try (Connection conn = DbConnection.getConnection()) {
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setLong(1, reserveId);
            ResultSet rs = pstmt.executeQuery();


            if (rs.next()) {
                payment = new Payment();
                payment.setId(rs.getLong("id"));;

                Reserve reserve = new Reserve();
                reserve.setId(rs.getLong("reserveId"));
                payment.setReserve(reserve);
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return payment;
    }


    private Payment mapRowToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setId(rs.getLong("id"));
        payment.setCardNumber(rs.getString("cardNumber"));
        payment.setAmount(rs.getDouble("amount"));

        payment.setPaidDate(rs.getDate("paidDate").toLocalDate());  // change to LocalDate

        // just set the id of reserve, it won't load the reserve. we need to change the ToString()
        Reserve reserve = new Reserve();
        reserve.setId(rs.getLong("reserveId"));
        payment.setReserve(reserve);

        return payment;
    }

}
