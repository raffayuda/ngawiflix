package com.cinemax.dao;

import com.cinemax.model.Schedule;
import com.cinemax.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDAO {
    
    public List<Schedule> getSchedulesByMovieId(int movieId) throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        // Temporarily remove date filter for development - show all schedules
        String sql = "SELECT * FROM v_schedule_details WHERE movie_id = ? ORDER BY show_date, show_time";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, movieId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Schedule schedule = extractScheduleFromResultSet(rs);
                    schedules.add(schedule);
                }
            }
        }
        
        return schedules;
    }
    
    public Schedule getScheduleById(int scheduleId) throws SQLException {
        String sql = "SELECT * FROM v_schedule_details WHERE schedule_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, scheduleId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractScheduleFromResultSet(rs);
                }
            }
        }
        
        return null;
    }
    
    public List<Schedule> getTodaySchedules() throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM v_schedule_details WHERE show_date = CURRENT_DATE ORDER BY show_time";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Schedule schedule = extractScheduleFromResultSet(rs);
                schedules.add(schedule);
            }
        }
        
        return schedules;
    }
    
    private Schedule extractScheduleFromResultSet(ResultSet rs) throws SQLException {
        Schedule schedule = new Schedule();
        schedule.setScheduleId(rs.getInt("schedule_id"));
        schedule.setMovieId(rs.getInt("movie_id"));
        schedule.setTheaterId(rs.getInt("theater_id"));
        schedule.setShowDate(rs.getDate("show_date"));
        schedule.setShowTime(rs.getTime("show_time"));
        schedule.setPrice(rs.getBigDecimal("price"));
        schedule.setMovieTitle(rs.getString("movie_title"));
        schedule.setPosterUrl(rs.getString("poster_url"));
        schedule.setDuration(rs.getInt("duration"));
        schedule.setRated(rs.getString("rated"));
        schedule.setTheaterName(rs.getString("theater_name"));
        schedule.setLocation(rs.getString("location"));
        schedule.setTotalSeats(rs.getInt("total_seats"));
        schedule.setAvailableSeats(rs.getInt("available_seats"));
        return schedule;
    }
}
