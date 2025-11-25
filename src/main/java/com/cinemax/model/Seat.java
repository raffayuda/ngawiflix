package com.cinemax.model;

public class Seat {
    private int seatId;
    private int scheduleId;
    private String rowLetter;
    private int seatNumber;
    private String status; // available, selected, occupied
    
    // Constructors
    public Seat() {}
    
    public Seat(int seatId, int scheduleId, String rowLetter, int seatNumber, String status) {
        this.seatId = seatId;
        this.scheduleId = scheduleId;
        this.rowLetter = rowLetter;
        this.seatNumber = seatNumber;
        this.status = status;
    }
    
    // Getters and Setters
    public int getSeatId() {
        return seatId;
    }
    
    public void setSeatId(int seatId) {
        this.seatId = seatId;
    }
    
    public int getScheduleId() {
        return scheduleId;
    }
    
    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }
    
    public String getRowLetter() {
        return rowLetter;
    }
    
    public void setRowLetter(String rowLetter) {
        this.rowLetter = rowLetter;
    }
    
    public int getSeatNumber() {
        return seatNumber;
    }
    
    public void setSeatNumber(int seatNumber) {
        this.seatNumber = seatNumber;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getSeatCode() {
        return rowLetter + seatNumber;
    }
}
