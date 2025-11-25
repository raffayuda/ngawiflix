package com.cinemax.servlet;

import com.cinemax.dao.BookingDAO;
import com.cinemax.dao.ScheduleDAO;
import com.cinemax.model.Booking;
import com.cinemax.model.Schedule;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/api/bookings")
public class BookingServlet extends HttpServlet {
    private BookingDAO bookingDAO;
    private ScheduleDAO scheduleDAO;
    private Gson gson;
    
    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        scheduleDAO = new ScheduleDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Read JSON from request body
            BufferedReader reader = request.getReader();
            JsonObject jsonObject = gson.fromJson(reader, JsonObject.class);
            
            int scheduleId = jsonObject.get("scheduleId").getAsInt();
            String customerName = jsonObject.get("customerName").getAsString();
            String customerEmail = jsonObject.get("customerEmail").getAsString();
            String customerPhone = jsonObject.get("customerPhone").getAsString();
            
            List<Integer> seatIds = gson.fromJson(jsonObject.get("seatIds"), List.class)
                    .stream()
                    .map(obj -> ((Double) obj).intValue())
                    .collect(Collectors.toList());
            
            // Get schedule to calculate price
            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
            
            if (schedule == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Schedule not found\"}");
                return;
            }
            
            // Create booking object
            Booking booking = new Booking();
            booking.setScheduleId(scheduleId);
            booking.setCustomerName(customerName);
            booking.setCustomerEmail(customerEmail);
            booking.setCustomerPhone(customerPhone);
            booking.setTotalSeats(seatIds.size());
            booking.setTotalPrice(schedule.getPrice().multiply(new BigDecimal(seatIds.size())));
            
            // Save booking
            String bookingCode = bookingDAO.createBooking(booking, seatIds);
            
            // Return booking code
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("bookingCode", bookingCode);
            result.addProperty("message", "Booking berhasil dibuat!");
            
            out.print(gson.toJson(result));
            
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject error = new JsonObject();
            error.addProperty("success", false);
            error.addProperty("error", e.getMessage());
            out.print(gson.toJson(error));
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            String bookingCode = request.getParameter("bookingCode");
            String email = request.getParameter("email");
            
            if (bookingCode != null) {
                Booking booking = bookingDAO.getBookingByCode(bookingCode);
                out.print(gson.toJson(booking));
            } else if (email != null) {
                List<Booking> bookings = bookingDAO.getBookingsByEmail(email);
                out.print(gson.toJson(bookings));
            }
            
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}
