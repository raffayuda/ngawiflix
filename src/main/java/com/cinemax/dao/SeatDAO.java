package com.cinemax.dao;

import com.cinemax.model.Seat;
import com.cinemax.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SeatDAO {
    
    public List<Seat> getSeatsByScheduleId(int scheduleId) throws SQLException {
        List<Seat> seats = new ArrayList<>();
        String sql = "SELECT * FROM seats WHERE schedule_id = ? ORDER BY row_letter, seat_number";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, scheduleId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Seat seat = new Seat();
                    seat.setSeatId(rs.getInt("seat_id"));
                    seat.setScheduleId(rs.getInt("schedule_id"));
                    seat.setRowLetter(rs.getString("row_letter"));
                    seat.setSeatNumber(rs.getInt("seat_number"));
                    seat.setStatus(rs.getString("status"));
                    seats.add(seat);
                }
            }
        }
        
        return seats;
    }
    
    public boolean updateSeatStatus(int seatId, String status) throws SQLException {
        String sql = "UPDATE seats SET status = ? WHERE seat_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, seatId);
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    public boolean updateMultipleSeatsStatus(List<Integer> seatIds, String status) throws SQLException {
        String sql = "UPDATE seats SET status = ? WHERE seat_id = ANY(?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            Array array = conn.createArrayOf("INTEGER", seatIds.toArray());
            pstmt.setString(1, status);
            pstmt.setArray(2, array);
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    public Seat getSeatById(int seatId) throws SQLException {
        String sql = "SELECT * FROM seats WHERE seat_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, seatId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Seat seat = new Seat();
                    seat.setSeatId(rs.getInt("seat_id"));
                    seat.setScheduleId(rs.getInt("schedule_id"));
                    seat.setRowLetter(rs.getString("row_letter"));
                    seat.setSeatNumber(rs.getInt("seat_number"));
                    seat.setStatus(rs.getString("status"));
                    return seat;
                }
            }
        }
        
        return null;
    }
}
