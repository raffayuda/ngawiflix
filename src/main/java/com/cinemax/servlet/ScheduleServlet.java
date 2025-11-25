package com.cinemax.servlet;

import com.cinemax.dao.ScheduleDAO;
import com.cinemax.model.Schedule;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.List;

@WebServlet("/api/schedules")
public class ScheduleServlet extends HttpServlet {
    private ScheduleDAO scheduleDAO;
    private Gson gson;
    
    @Override
    public void init() {
        scheduleDAO = new ScheduleDAO();
        
        // Create custom Gson with Date and Time serializers
        gson = new GsonBuilder()
            .registerTypeAdapter(Date.class, new JsonSerializer<Date>() {
                @Override
                public JsonElement serialize(Date date, Type type, JsonSerializationContext context) {
                    return new JsonPrimitive(date.toString()); // yyyy-MM-dd format
                }
            })
            .registerTypeAdapter(Time.class, new JsonSerializer<Time>() {
                @Override
                public JsonElement serialize(Time time, Type type, JsonSerializationContext context) {
                    return new JsonPrimitive(time.toString()); // HH:mm:ss format
                }
            })
            .create();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*"); // Allow CORS
        
        PrintWriter out = response.getWriter();
        
        try {
            String movieIdParam = request.getParameter("movieId");
            String scheduleIdParam = request.getParameter("scheduleId");
            
            System.out.println("ScheduleServlet - movieIdParam: " + movieIdParam);
            System.out.println("ScheduleServlet - scheduleIdParam: " + scheduleIdParam);
            
            if (scheduleIdParam != null && !scheduleIdParam.trim().isEmpty()) {
                int scheduleId = Integer.parseInt(scheduleIdParam.trim());
                Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
                out.print(gson.toJson(schedule));
            } else if (movieIdParam != null && !movieIdParam.trim().isEmpty()) {
                int movieId = Integer.parseInt(movieIdParam.trim());
                System.out.println("ScheduleServlet - Fetching schedules for movieId: " + movieId);
                List<Schedule> schedules = scheduleDAO.getSchedulesByMovieId(movieId);
                System.out.println("ScheduleServlet - Found " + schedules.size() + " schedules");
                String json = gson.toJson(schedules);
                System.out.println("ScheduleServlet - JSON response: " + json);
                out.print(json);
            } else {
                System.out.println("ScheduleServlet - No movieId or scheduleId, returning today's schedules");
                List<Schedule> schedules = scheduleDAO.getTodaySchedules();
                out.print(gson.toJson(schedules));
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid parameter format: " + e.getMessage() + "\"}");
            System.err.println("NumberFormatException in ScheduleServlet: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Database error: " + e.getMessage() + "\"}");
            System.err.println("SQLException in ScheduleServlet: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Server error: " + e.getMessage() + "\"}");
            System.err.println("Exception in ScheduleServlet: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
