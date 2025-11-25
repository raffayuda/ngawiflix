<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cinemax.util.DatabaseConnection" %>
<%@ page import="java.sql.Connection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Database Connection Test</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .status {
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        .success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
            padding: 15px;
            border-radius: 5px;
            margin: 10px 0;
        }
        h1 {
            color: #333;
        }
        code {
            background: #f4f4f4;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
        }
        pre {
            background: #f4f4f4;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
        }
    </style>
</head>
<body>
    <h1>🔧 CinemaX - Database Connection Test</h1>
    
    <%
        boolean isConnected = false;
        String errorMessage = "";
        Connection conn = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            isConnected = (conn != null && !conn.isClosed());
        } catch (Exception e) {
            errorMessage = e.getMessage();
            e.printStackTrace();
        }
    %>
    
    <% if (isConnected) { %>
        <div class="status success">
            <h2>✅ Database Connected Successfully!</h2>
            <p>Koneksi ke database PostgreSQL berhasil!</p>
        </div>
        
        <div class="info">
            <h3>Next Steps:</h3>
            <ol>
                <li>Pastikan schema sudah di-import ke database</li>
                <li>Kembali ke halaman utama: <a href="index.jsp">index.jsp</a></li>
                <li>Test API endpoints di browser</li>
            </ol>
        </div>
        
        <div class="info">
            <h3>Test API Endpoints:</h3>
            <ul>
                <li><a href="api/movies" target="_blank">api/movies</a> - Get all movies</li>
                <li><a href="api/movies?action=featured" target="_blank">api/movies?action=featured</a> - Featured movies</li>
                <li><a href="api/categories" target="_blank">api/categories</a> - Get categories</li>
                <li><a href="api/schedules" target="_blank">api/schedules</a> - Get today's schedules</li>
            </ul>
        </div>
    <% } else { %>
        <div class="status error">
            <h2>❌ Database Connection Failed</h2>
            <p><strong>Error:</strong> <%= errorMessage %></p>
        </div>
        
        <div class="info">
            <h3>Troubleshooting Steps:</h3>
            <ol>
                <li><strong>PostgreSQL Service</strong>
                    <ul>
                        <li>Pastikan PostgreSQL service sedang running</li>
                        <li>Buka Services → cari "postgresql" → Start jika belum running</li>
                    </ul>
                </li>
                
                <li><strong>Database Configuration</strong>
                    <p>Edit file: <code>src/main/java/com/cinemax/util/DatabaseConnection.java</code></p>
                    <pre>private static final String URL = "jdbc:postgresql://localhost:5432/cinemax_db";
private static final String USER = "postgres";
private static final String PASSWORD = "your_password"; // Ganti dengan password Anda</pre>
                </li>
                
                <li><strong>Database Exists?</strong>
                    <ul>
                        <li>Buka pgAdmin</li>
                        <li>Pastikan database <code>cinemax_db</code> sudah dibuat</li>
                        <li>Jalankan file <code>database/schema.sql</code></li>
                    </ul>
                </li>
                
                <li><strong>PostgreSQL JDBC Driver</strong>
                    <ul>
                        <li>Pastikan file <code>postgresql-42.7.1.jar</code> ada di folder <code>WEB-INF/lib/</code></li>
                        <li>Refresh project di Eclipse (F5)</li>
                        <li>Clean and rebuild project</li>
                    </ul>
                </li>
                
                <li><strong>Port Configuration</strong>
                    <ul>
                        <li>PostgreSQL default port: 5432</li>
                        <li>Pastikan tidak ada firewall yang memblokir</li>
                    </ul>
                </li>
            </ol>
        </div>
    <% } %>
    
    <div class="info">
        <h3>📚 Documentation:</h3>
        <ul>
            <li><a href="README.md">README.md</a> - Complete setup guide</li>
            <li><a href="DEPENDENCIES.md">DEPENDENCIES.md</a> - How to download dependencies</li>
            <li><a href="database/schema.sql">database/schema.sql</a> - Database schema</li>
        </ul>
    </div>
    
    <hr>
    <p style="text-align: center; color: #666;">
        <small>CinemaX © 2025 - Modern Cinema Ticket Booking System</small>
    </p>
</body>
</html>
