package service;

import daos.PaymentDao;
import daos.ReserveDao;
import model.payment.Payment;
import model.reserve.Reserve;

import java.time.LocalDate;

public class PaymentService {

    private PaymentDao paymentDao;
    private ReserveDao reserveDao;

    public PaymentService() {
        this.paymentDao = new PaymentDao();
        this.reserveDao = new ReserveDao();
    }

    public Payment payByReserveId(String carNumber, Double amount, LocalDate paidDate, Long reserveId) throws Exception {

        Reserve reserve = reserveDao.getReserveById(reserveId);
        if (reserve == null) throw new Exception("Reservation not found: " + reserveId);

        Payment payment = new Payment();

        payment.setCardNumber(carNumber);
        payment.setAmount(amount);
        payment.setPaidDate(paidDate);
        payment.setReserve(reserve);

        paymentDao.insertPayment(payment);

        reserve.setStatus("Confirmed and Paid");
        reserveDao.updateReserve(reserve);

        return payment;
    }
}
