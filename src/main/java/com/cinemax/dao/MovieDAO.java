package com.cinemax.dao;

import com.cinemax.model.Movie;
import com.cinemax.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class MovieDAO {
    
    public List<Movie> getAllMovies() throws SQLException {
        List<Movie> movies = new ArrayList<>();
        String sql = "SELECT * FROM v_movies_with_categories ORDER BY rating DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Movie movie = extractMovieFromResultSet(rs);
                movies.add(movie);
            }
        }
        
        return movies;
    }
    
    public List<Movie> getFeaturedMovies() throws SQLException {
        List<Movie> movies = new ArrayList<>();
        String sql = "SELECT * FROM v_movies_with_categories WHERE is_featured = TRUE ORDER BY rating DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Movie movie = extractMovieFromResultSet(rs);
                movies.add(movie);
            }
        }
        
        return movies;
    }
    
    public List<Movie> getMoviesByCategory(String category) throws SQLException {
        List<Movie> movies = new ArrayList<>();
        String sql = "SELECT * FROM v_movies_with_categories WHERE categories LIKE ? ORDER BY rating DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + category + "%");
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Movie movie = extractMovieFromResultSet(rs);
                    movies.add(movie);
                }
            }
        }
        
        return movies;
    }
    
    public List<Movie> searchMovies(String keyword) throws SQLException {
        List<Movie> movies = new ArrayList<>();
        String sql = "SELECT * FROM v_movies_with_categories WHERE LOWER(title) LIKE ? OR LOWER(categories) LIKE ? ORDER BY rating DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword.toLowerCase() + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Movie movie = extractMovieFromResultSet(rs);
                    movies.add(movie);
                }
            }
        }
        
        return movies;
    }
    
    public Movie getMovieById(int movieId) throws SQLException {
        String sql = "SELECT * FROM v_movies_with_categories WHERE movie_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, movieId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractMovieFromResultSet(rs);
                }
            }
        }
        
        return null;
    }
    
    public List<String> getAllCategories() throws SQLException {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT category_name FROM categories ORDER BY category_name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                categories.add(rs.getString("category_name"));
            }
        }
        
        return categories;
    }
    
    private Movie extractMovieFromResultSet(ResultSet rs) throws SQLException {
        Movie movie = new Movie();
        movie.setMovieId(rs.getInt("movie_id"));
        movie.setTitle(rs.getString("title"));
        movie.setDescription(rs.getString("description"));
        movie.setPosterUrl(rs.getString("poster_url"));
        movie.setBackdropUrl(rs.getString("backdrop_url"));
        movie.setTrailerUrl(rs.getString("trailer_url"));
        movie.setDirector(rs.getString("director"));
        movie.setDuration(rs.getInt("duration"));
        movie.setRating(rs.getDouble("rating"));
        movie.setRated(rs.getString("rated"));
        movie.setReleaseYear(rs.getInt("release_year"));
        movie.setNew(rs.getBoolean("is_new"));
        movie.setFeatured(rs.getBoolean("is_featured"));
        
        String categoriesStr = rs.getString("categories");
        if (categoriesStr != null && !categoriesStr.isEmpty()) {
            movie.setGenres(Arrays.asList(categoriesStr.split(",")));
        } else {
            movie.setGenres(new ArrayList<>());
        }
        
        return movie;
    }
}
