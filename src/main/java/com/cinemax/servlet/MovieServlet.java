package com.cinemax.servlet;

import com.cinemax.dao.MovieDAO;
import com.cinemax.model.Movie;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

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
            String movieIdParam = request.getParameter("movieId");
            
            List<Movie> movies;
            
            if ("featured".equals(action)) {
                movies = movieDAO.getFeaturedMovies();
            } else if (movieIdParam != null) {
                int movieId = Integer.parseInt(movieIdParam);
                Movie movie = movieDAO.getMovieById(movieId);
                out.print(gson.toJson(movie));
                return;
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
        }
    }
}
