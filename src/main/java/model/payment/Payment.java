package model.payment;

import model.reserve.Reserve;

import java.time.LocalDate;

public class Payment {

    private Long id;
    private String cardNumber;
    private double amount;
    private LocalDate paidDate;
    private Reserve reserve;

    public Payment() {
    }

    public Payment(Long id, String cardNumber, double amount,
                   LocalDate paidDate, Reserve reserve) {
        this.id = id;
        this.cardNumber = cardNumber;
        this.amount = amount;
        this.paidDate = paidDate;
        this.reserve = reserve;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public LocalDate getPaidDate() {
        return paidDate;
    }

    public void setPaidDate(LocalDate paidDate) {
        this.paidDate = paidDate;
    }

    public Reserve getReserve() {
        return reserve;
    }

    public void setReserve(Reserve reserve) {
        this.reserve = reserve;
    }

    @Override
    public String toString() {
        return "Payment{" +
                "id=" + id +
                ", cardNumber='" + cardNumber + '\'' +
                ", amount=" + amount +
                ", paidDate=" + paidDate +
                ", reserve=" + reserve +
                '}';
    }

}
