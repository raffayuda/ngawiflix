package com.cinemax.model;

import java.sql.Timestamp;
import java.util.List;

public class Movie {
    private int movieId;
    private String title;
    private String description;
    private String posterUrl;
    private String backdropUrl;
    private String trailerUrl;
    private String director;
    private int duration;
    private double rating;
    private String rated;
    private int releaseYear;
    private boolean isNew;
    private boolean isFeatured;
    private List<String> genres;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Constructors
    public Movie() {}
    
    public Movie(int movieId, String title, String description, String posterUrl, 
                 String backdropUrl, String director, int duration, double rating, 
                 String rated, int releaseYear, boolean isNew, boolean isFeatured) {
        this.movieId = movieId;
        this.title = title;
        this.description = description;
        this.posterUrl = posterUrl;
        this.backdropUrl = backdropUrl;
        this.director = director;
        this.duration = duration;
        this.rating = rating;
        this.rated = rated;
        this.releaseYear = releaseYear;
        this.isNew = isNew;
        this.isFeatured = isFeatured;
    }
    
    // Getters and Setters
    public int getMovieId() {
        return movieId;
    }
    
    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getPosterUrl() {
        return posterUrl;
    }
    
    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }
    
    public String getBackdropUrl() {
        return backdropUrl;
    }
    
    public void setBackdropUrl(String backdropUrl) {
        this.backdropUrl = backdropUrl;
    }
    
    public String getTrailerUrl() {
        return trailerUrl;
    }
    
    public void setTrailerUrl(String trailerUrl) {
        this.trailerUrl = trailerUrl;
    }
    
    public String getDirector() {
        return director;
    }
    
    public void setDirector(String director) {
        this.director = director;
    }
    
    public int getDuration() {
        return duration;
    }
    
    public void setDuration(int duration) {
        this.duration = duration;
    }
    
    public double getRating() {
        return rating;
    }
    
    public void setRating(double rating) {
        this.rating = rating;
    }
    
    public String getRated() {
        return rated;
    }
    
    public void setRated(String rated) {
        this.rated = rated;
    }
    
    public int getReleaseYear() {
        return releaseYear;
    }
    
    public void setReleaseYear(int releaseYear) {
        this.releaseYear = releaseYear;
    }
    
    public boolean isNew() {
        return isNew;
    }
    
    public void setNew(boolean isNew) {
        this.isNew = isNew;
    }
    
    public boolean isFeatured() {
        return isFeatured;
    }
    
    public void setFeatured(boolean isFeatured) {
        this.isFeatured = isFeatured;
    }
    
    public List<String> getGenres() {
        return genres;
    }
    
    public void setGenres(List<String> genres) {
        this.genres = genres;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public String getDurationFormatted() {
        int hours = duration / 60;
        int minutes = duration % 60;
        return hours + "h " + minutes + "m";
    }
}
