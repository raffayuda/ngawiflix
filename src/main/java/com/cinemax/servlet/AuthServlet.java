package com.cinemax.servlet;

import com.cinemax.dao.UserDAO;
import com.cinemax.model.User;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/auth")
public class AuthServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private Gson gson;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String action = request.getParameter("action");
        
        System.out.println("AuthServlet - POST request received");
        System.out.println("Action: " + action);
        
        if (action == null) {
            action = "login"; // default action
        }
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            switch (action) {
                case "login":
                    handleLogin(request, response, result);
                    break;
                case "register":
                    handleRegister(request, response, result);
                    break;
                case "logout":
                    handleLogout(request, response, result);
                    break;
                case "check":
                    handleCheckSession(request, response, result);
                    break;
                default:
                    result.put("success", false);
                    result.put("error", "Invalid action");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            e.printStackTrace();
        }
        
        String jsonResponse = gson.toJson(result);
        System.out.println("Response: " + jsonResponse);
        out.print(jsonResponse);
        out.flush();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String action = request.getParameter("action");
        Map<String, Object> result = new HashMap<>();
        
        if ("check".equals(action)) {
            handleCheckSession(request, response, result);
        } else {
            result.put("success", false);
            result.put("error", "Invalid action");
        }
        
        out.print(gson.toJson(result));
        out.flush();
    }
    
    private void handleLogin(HttpServletRequest request, HttpServletResponse response, Map<String, Object> result) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        System.out.println("Login attempt - Username: " + username);
        
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            result.put("success", false);
            result.put("error", "Username dan password harus diisi");
            return;
        }
        
        User user = userDAO.login(username.trim(), password);
        
        System.out.println("Login result - User found: " + (user != null));
        
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(3600); // 1 hour
            
            result.put("success", true);
            result.put("message", "Login berhasil");
            
            Map<String, Object> userData = new HashMap<>();
            userData.put("userId", user.getUserId());
            userData.put("username", user.getUsername());
            userData.put("email", user.getEmail());
            userData.put("fullName", user.getFullName());
            userData.put("phone", user.getPhone());
            userData.put("role", user.getRole());
            
            result.put("user", userData);
        } else {
            result.put("success", false);
            result.put("error", "Username/email atau password salah");
        }
    }
    
    private void handleRegister(HttpServletRequest request, HttpServletResponse response, Map<String, Object> result) {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        
        // Validation
        if (username == null || username.trim().isEmpty()) {
            result.put("success", false);
            result.put("error", "Username harus diisi");
            return;
        }
        
        if (email == null || email.trim().isEmpty()) {
            result.put("success", false);
            result.put("error", "Email harus diisi");
            return;
        }
        
        if (password == null || password.trim().isEmpty()) {
            result.put("success", false);
            result.put("error", "Password harus diisi");
            return;
        }
        
        if (password.length() < 6) {
            result.put("success", false);
            result.put("error", "Password minimal 6 karakter");
            return;
        }
        
        // Check if username exists
        if (userDAO.usernameExists(username.trim())) {
            result.put("success", false);
            result.put("error", "Username sudah digunakan");
            return;
        }
        
        // Check if email exists
        if (userDAO.emailExists(email.trim())) {
            result.put("success", false);
            result.put("error", "Email sudah terdaftar");
            return;
        }
        
        // Create new user
        User user = new User();
        user.setUsername(username.trim());
        user.setEmail(email.trim());
        user.setPassword(password); // In production, hash this password!
        user.setFullName(fullName != null ? fullName.trim() : "");
        user.setPhone(phone != null ? phone.trim() : "");
        user.setRole("user"); // Default role
        
        if (userDAO.register(user)) {
            // Auto login after registration
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(3600);
            
            result.put("success", true);
            result.put("message", "Registrasi berhasil");
            
            Map<String, Object> userData = new HashMap<>();
            userData.put("userId", user.getUserId());
            userData.put("username", user.getUsername());
            userData.put("email", user.getEmail());
            userData.put("fullName", user.getFullName());
            userData.put("phone", user.getPhone());
            userData.put("role", user.getRole());
            
            result.put("user", userData);
        } else {
            result.put("success", false);
            result.put("error", "Registrasi gagal, silakan coba lagi");
        }
    }
    
    private void handleLogout(HttpServletRequest request, HttpServletResponse response, Map<String, Object> result) {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            session.invalidate();
        }
        
        result.put("success", true);
        result.put("message", "Logout berhasil");
    }
    
    private void handleCheckSession(HttpServletRequest request, HttpServletResponse response, Map<String, Object> result) {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            
            result.put("success", true);
            result.put("loggedIn", true);
            
            Map<String, Object> userData = new HashMap<>();
            userData.put("userId", user.getUserId());
            userData.put("username", user.getUsername());
            userData.put("email", user.getEmail());
            userData.put("fullName", user.getFullName());
            userData.put("phone", user.getPhone());
            userData.put("role", user.getRole());
            
            result.put("user", userData);
        } else {
            result.put("success", true);
            result.put("loggedIn", false);
            result.put("user", null);
        }
    }
}
