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
    
    public boolean createMovie(Movie movie) throws SQLException {
        String sql = "INSERT INTO movies (title, description, poster_url, backdrop_url, trailer_url, " +
                     "director, duration, rating, rated, release_year, is_new, is_featured) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) RETURNING movie_id";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, movie.getTitle());
            pstmt.setString(2, movie.getDescription());
            pstmt.setString(3, movie.getPosterUrl());
            pstmt.setString(4, movie.getBackdropUrl());
            pstmt.setString(5, movie.getTrailerUrl());
            pstmt.setString(6, movie.getDirector());
            pstmt.setInt(7, movie.getDuration());
            pstmt.setDouble(8, movie.getRating());
            pstmt.setString(9, movie.getRated());
            pstmt.setInt(10, movie.getReleaseYear());
            pstmt.setBoolean(11, movie.isNew());
            pstmt.setBoolean(12, movie.isFeatured());
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                int movieId = rs.getInt("movie_id");
                
                // Insert movie categories if provided
                if (movie.getCategories() != null && !movie.getCategories().isEmpty()) {
                    insertMovieCategories(conn, movieId, movie.getCategories());
                }
                
                return true;
            }
        }
        
        return false;
    }
    
    public boolean updateMovie(Movie movie) throws SQLException {
        String sql = "UPDATE movies SET title = ?, description = ?, poster_url = ?, backdrop_url = ?, " +
                     "trailer_url = ?, director = ?, duration = ?, rating = ?, rated = ?, " +
                     "release_year = ?, is_new = ?, is_featured = ? WHERE movie_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, movie.getTitle());
            pstmt.setString(2, movie.getDescription());
            pstmt.setString(3, movie.getPosterUrl());
            pstmt.setString(4, movie.getBackdropUrl());
            pstmt.setString(5, movie.getTrailerUrl());
            pstmt.setString(6, movie.getDirector());
            pstmt.setInt(7, movie.getDuration());
            pstmt.setDouble(8, movie.getRating());
            pstmt.setString(9, movie.getRated());
            pstmt.setInt(10, movie.getReleaseYear());
            pstmt.setBoolean(11, movie.isNew());
            pstmt.setBoolean(12, movie.isFeatured());
            pstmt.setInt(13, movie.getMovieId());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Update movie categories
                deleteMovieCategories(conn, movie.getMovieId());
                if (movie.getCategories() != null && !movie.getCategories().isEmpty()) {
                    insertMovieCategories(conn, movie.getMovieId(), movie.getCategories());
                }
                return true;
            }
        }
        
        return false;
    }
    
    public boolean deleteMovie(int movieId) throws SQLException {
        String sql = "DELETE FROM movies WHERE movie_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            // First delete movie categories
            deleteMovieCategories(conn, movieId);
            
            pstmt.setInt(1, movieId);
            int rowsAffected = pstmt.executeUpdate();
            
            return rowsAffected > 0;
        }
    }
    
    private void insertMovieCategories(Connection conn, int movieId, List<Integer> categoryIds) throws SQLException {
        String sql = "INSERT INTO movie_categories (movie_id, category_id) VALUES (?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (Integer categoryId : categoryIds) {
                pstmt.setInt(1, movieId);
                pstmt.setInt(2, categoryId);
                pstmt.addBatch();
            }
            pstmt.executeBatch();
        }
    }
    
    private void deleteMovieCategories(Connection conn, int movieId) throws SQLException {
        String sql = "DELETE FROM movie_categories WHERE movie_id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, movieId);
            pstmt.executeUpdate();
        }
    }
}
