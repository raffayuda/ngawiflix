<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.cinemax.util.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Schedules - CinemaX</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background: #1a1a1a; color: #fff; }
        h1 { color: #ef4444; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: #2a2a2a; }
        th, td { padding: 12px; text-align: left; border: 1px solid #444; }
        th { background: #ef4444; }
        .success { background: #10b981; color: white; padding: 10px; border-radius: 5px; }
        .error { background: #ef4444; color: white; padding: 10px; border-radius: 5px; }
        .info { background: #3b82f6; color: white; padding: 10px; border-radius: 5px; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>🎬 Database Schedules Test</h1>
    
    <%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    try {
        conn = DatabaseConnection.getConnection();
        
        if (conn != null && !conn.isClosed()) {
            out.println("<div class='success'>✅ Database Connected Successfully!</div>");
            
            // Test 1: Check total schedules
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT COUNT(*) as total FROM schedules");
            if (rs.next()) {
                int total = rs.getInt("total");
                out.println("<div class='info'>📊 Total Schedules in Database: <strong>" + total + "</strong></div>");
            }
            rs.close();
            
            // Test 2: Check schedules per movie
            out.println("<h2>Schedules per Movie:</h2>");
            out.println("<table>");
            out.println("<tr><th>Movie ID</th><th>Movie Title</th><th>Total Schedules</th></tr>");
            
            rs = stmt.executeQuery(
                "SELECT m.movie_id, m.title, COUNT(s.schedule_id) as total_schedules " +
                "FROM movies m " +
                "LEFT JOIN schedules s ON m.movie_id = s.movie_id " +
                "GROUP BY m.movie_id, m.title " +
                "ORDER BY m.movie_id"
            );
            
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("movie_id") + "</td>");
                out.println("<td>" + rs.getString("title") + "</td>");
                out.println("<td><strong>" + rs.getInt("total_schedules") + "</strong></td>");
                out.println("</tr>");
            }
            out.println("</table>");
            rs.close();
            
            // Test 3: Show all schedules with details
            out.println("<h2>All Schedules Details:</h2>");
            out.println("<table>");
            out.println("<tr><th>Schedule ID</th><th>Movie</th><th>Theater</th><th>Date</th><th>Time</th><th>Price</th></tr>");
            
            rs = stmt.executeQuery(
                "SELECT s.schedule_id, m.title, t.theater_name, s.show_date, s.show_time, s.price " +
                "FROM schedules s " +
                "JOIN movies m ON s.movie_id = m.movie_id " +
                "JOIN theaters t ON s.theater_id = t.theater_id " +
                "ORDER BY s.show_date, s.show_time"
            );
            
            int count = 0;
            while (rs.next()) {
                count++;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("schedule_id") + "</td>");
                out.println("<td>" + rs.getString("title") + "</td>");
                out.println("<td>" + rs.getString("theater_name") + "</td>");
                out.println("<td>" + rs.getDate("show_date") + "</td>");
                out.println("<td>" + rs.getTime("show_time") + "</td>");
                out.println("<td>Rp " + String.format("%,d", rs.getInt("price")) + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            if (count == 0) {
                out.println("<div class='error'>⚠️ No schedules found in database! Please run add-schedules.sql in pgAdmin.</div>");
            } else {
                out.println("<div class='success'>✅ Found " + count + " schedules in database</div>");
            }
            
            // Test 4: Test API endpoint
            out.println("<h2>Test API Endpoint:</h2>");
            out.println("<div class='info'>");
            out.println("<p>Try these URLs in your browser:</p>");
            out.println("<ul>");
            out.println("<li><a href='api/schedules?movieId=1' target='_blank'>api/schedules?movieId=1</a> (Should return schedules for movie 1)</li>");
            out.println("<li><a href='api/schedules?movieId=7' target='_blank'>api/schedules?movieId=7</a> (Should return schedules for movie 7 - Silent Whispers)</li>");
            out.println("<li><a href='api/schedules' target='_blank'>api/schedules</a> (Should return today's schedules)</li>");
            out.println("</ul>");
            out.println("</div>");
            
        } else {
            out.println("<div class='error'>❌ Failed to connect to database</div>");
        }
        
    } catch (Exception e) {
        out.println("<div class='error'>❌ Error: " + e.getMessage() + "</div>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
    }
    %>
    
    <br><br>
    <a href="index.jsp" style="color: #ef4444; font-size: 18px;">← Back to Home</a>
</body>
</html>
