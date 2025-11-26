package com.cinemax.servlet;

import com.cinemax.dao.MovieDAO;
import com.cinemax.model.Movie;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/api/movies")
public class MovieServlet extends HttpServlet {
    private MovieDAO movieDAO;
    private Gson gson;
    
    @Override
    public void init() {
        movieDAO = new MovieDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            String action = request.getParameter("action");
            String category = request.getParameter("category");
            String search = request.getParameter("search");
            String movieIdParam = request.getParameter("id");
            
            List<Movie> movies;
            
            if (movieIdParam != null) {
                int movieId = Integer.parseInt(movieIdParam);
                Movie movie = movieDAO.getMovieById(movieId);
                out.print(gson.toJson(movie));
                return;
            } else if ("featured".equals(action)) {
                movies = movieDAO.getFeaturedMovies();
            } else if (category != null && !category.isEmpty() && !"all".equals(category)) {
                movies = movieDAO.getMoviesByCategory(category);
            } else if (search != null && !search.isEmpty()) {
                movies = movieDAO.searchMovies(search);
            } else {
                movies = movieDAO.getAllMovies();
            }
            
            out.print(gson.toJson(movies));
            
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid movie ID\"}");
        }
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
            String json = reader.lines().collect(Collectors.joining());
            
            // Parse JSON to Movie object
            Movie movie = gson.fromJson(json, Movie.class);
            
            // Create movie in database
            boolean success = movieDAO.createMovie(movie);
            
            if (success) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                out.print("{\"success\": true, \"message\": \"Movie created successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\": false, \"error\": \"Failed to create movie\"}");
            }
            
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Invalid request data\"}");
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Get movie ID from parameter
            String movieIdParam = request.getParameter("id");
            if (movieIdParam == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"error\": \"Movie ID is required\"}");
                return;
            }
            
            int movieId = Integer.parseInt(movieIdParam);
            
            // Read JSON from request body
            BufferedReader reader = request.getReader();
            String json = reader.lines().collect(Collectors.joining());
            
            // Parse JSON to Movie object
            Movie movie = gson.fromJson(json, Movie.class);
            movie.setMovieId(movieId);
            
            // Update movie in database
            boolean success = movieDAO.updateMovie(movie);
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Movie updated successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\": false, \"error\": \"Failed to update movie\"}");
            }
            
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Invalid movie ID\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Invalid request data\"}");
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            String movieIdParam = request.getParameter("id");
            if (movieIdParam == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"error\": \"Movie ID is required\"}");
                return;
            }
            
            int movieId = Integer.parseInt(movieIdParam);
            
            // Delete movie from database
            boolean success = movieDAO.deleteMovie(movieId);
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Movie deleted successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\": false, \"error\": \"Failed to delete movie\"}");
            }
            
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Invalid movie ID\"}");
        }
    }
}
