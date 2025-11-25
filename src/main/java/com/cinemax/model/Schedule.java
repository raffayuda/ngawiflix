package com.cinemax.model;

import java.sql.Date;
import java.sql.Time;
import java.math.BigDecimal;

public class Schedule {
    private int scheduleId;
    private int movieId;
    private int theaterId;
    private Date showDate;
    private Time showTime;
    private BigDecimal price;
    
    // Additional info from joins
    private String movieTitle;
    private String posterUrl;
    private int duration;
    private String rated;
    private String theaterName;
    private String location;
    private int totalSeats;
    private int availableSeats;
    
    // Constructors
    public Schedule() {}
    
    // Getters and Setters
    public int getScheduleId() {
        return scheduleId;
    }
    
    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }
    
    public int getMovieId() {
        return movieId;
    }
    
    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }
    
    public int getTheaterId() {
        return theaterId;
    }
    
    public void setTheaterId(int theaterId) {
        this.theaterId = theaterId;
    }
    
    public Date getShowDate() {
        return showDate;
    }
    
    public void setShowDate(Date showDate) {
        this.showDate = showDate;
    }
    
    public Time getShowTime() {
        return showTime;
    }
    
    public void setShowTime(Time showTime) {
        this.showTime = showTime;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public String getMovieTitle() {
        return movieTitle;
    }
    
    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }
    
    public String getPosterUrl() {
        return posterUrl;
    }
    
    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }
    
    public int getDuration() {
        return duration;
    }
    
    public void setDuration(int duration) {
        this.duration = duration;
    }
    
    public String getRated() {
        return rated;
    }
    
    public void setRated(String rated) {
        this.rated = rated;
    }
    
    public String getTheaterName() {
        return theaterName;
    }
    
    public void setTheaterName(String theaterName) {
        this.theaterName = theaterName;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public int getTotalSeats() {
        return totalSeats;
    }
    
    public void setTotalSeats(int totalSeats) {
        this.totalSeats = totalSeats;
    }
    
    public int getAvailableSeats() {
        return availableSeats;
    }
    
    public void setAvailableSeats(int availableSeats) {
        this.availableSeats = availableSeats;
    }
}
