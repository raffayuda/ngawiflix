package com.cinemax.servlet;

import com.cinemax.dao.SeatDAO;
import com.cinemax.model.Seat;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/api/seats")
public class SeatServlet extends HttpServlet {
    private SeatDAO seatDAO;
    private Gson gson;
    
    @Override
    public void init() {
        seatDAO = new SeatDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            String scheduleIdParam = request.getParameter("scheduleId");
            
            if (scheduleIdParam != null) {
                int scheduleId = Integer.parseInt(scheduleIdParam);
                List<Seat> seats = seatDAO.getSeatsByScheduleId(scheduleId);
                
                // Group seats by row
                Map<String, List<Map<String, Object>>> groupedSeats = new LinkedHashMap<>();
                
                for (Seat seat : seats) {
                    String row = seat.getRowLetter();
                    
                    if (!groupedSeats.containsKey(row)) {
                        groupedSeats.put(row, new ArrayList<>());
                    }
                    
                    Map<String, Object> seatMap = new HashMap<>();
                    seatMap.put("seatId", seat.getSeatId());
                    seatMap.put("number", seat.getSeatNumber());
                    seatMap.put("status", seat.getStatus());
                    
                    groupedSeats.get(row).add(seatMap);
                }
                
                // Convert to list of row objects
                List<Map<String, Object>> result = new ArrayList<>();
                for (Map.Entry<String, List<Map<String, Object>>> entry : groupedSeats.entrySet()) {
                    Map<String, Object> rowMap = new HashMap<>();
                    rowMap.put("row", entry.getKey());
                    rowMap.put("seats", entry.getValue());
                    result.add(rowMap);
                }
                
                out.print(gson.toJson(result));
            }
            
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}
