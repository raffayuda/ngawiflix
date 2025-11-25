<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cinemax.model.User" %>
<%
    // Check if user is logged in and is admin
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"admin".equals(currentUser.getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel - CinemaX</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Alpine.js -->
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        [x-cloak] { display: none !important; }
    </style>
</head>
<body class="bg-gray-100" x-data="adminApp()">
    
    <!-- Sidebar -->
    <div class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <div class="w-64 bg-slate-900 text-white">
            <div class="p-6">
                <h1 class="text-2xl font-bold text-red-500">
                    <i class="fas fa-film mr-2"></i>CinemaX Admin
                </h1>
                <p class="text-sm text-gray-400 mt-1">Welcome, <%= currentUser.getUsername() %></p>
            </div>
            
            <nav class="mt-6">
                <a @click="currentTab = 'movies'" 
                   :class="currentTab === 'movies' ? 'bg-red-600' : 'hover:bg-slate-800'"
                   class="flex items-center px-6 py-3 cursor-pointer transition">
                    <i class="fas fa-film w-5"></i>
                    <span class="ml-3">Movies</span>
                </a>
                <a @click="currentTab = 'schedules'" 
                   :class="currentTab === 'schedules' ? 'bg-red-600' : 'hover:bg-slate-800'"
                   class="flex items-center px-6 py-3 cursor-pointer transition">
                    <i class="fas fa-calendar w-5"></i>
                    <span class="ml-3">Schedules</span>
                </a>
                <a @click="currentTab = 'theaters'" 
                   :class="currentTab === 'theaters' ? 'bg-red-600' : 'hover:bg-slate-800'"
                   class="flex items-center px-6 py-3 cursor-pointer transition">
                    <i class="fas fa-building w-5"></i>
                    <span class="ml-3">Theaters</span>
                </a>
                <a @click="currentTab = 'categories'" 
                   :class="currentTab === 'categories' ? 'bg-red-600' : 'hover:bg-slate-800'"
                   class="flex items-center px-6 py-3 cursor-pointer transition">
                    <i class="fas fa-tags w-5"></i>
                    <span class="ml-3">Categories</span>
                </a>
                
                <div class="border-t border-slate-700 my-4"></div>
                
                <a href="index.jsp" class="flex items-center px-6 py-3 hover:bg-slate-800 transition">
                    <i class="fas fa-home w-5"></i>
                    <span class="ml-3">Back to Home</span>
                </a>
            </nav>
        </div>
        
        <!-- Main Content -->
        <div class="flex-1 overflow-auto">
            <!-- Header -->
            <header class="bg-white shadow-sm">
                <div class="px-6 py-4 flex justify-between items-center">
                    <h2 class="text-2xl font-bold text-gray-800" x-text="getTabTitle()"></h2>
                    <div class="flex items-center space-x-4">
                        <span class="text-gray-600">Role: <span class="font-semibold text-red-600">Admin</span></span>
                        <form action="api/auth?action=logout" method="POST">
                            <button type="submit" class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition">
                                <i class="fas fa-sign-out-alt mr-2"></i>Logout
                            </button>
                        </form>
                    </div>
                </div>
            </header>
            
            <!-- Content Area -->
            <div class="p-6">
                <!-- Movies Tab -->
                <div x-show="currentTab === 'movies'" x-cloak>
                    <div class="bg-white rounded-lg shadow p-6">
                        <div class="flex justify-between items-center mb-6">
                            <h3 class="text-xl font-semibold">Movies Management</h3>
                            <button class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition">
                                <i class="fas fa-plus mr-2"></i>Add Movie
                            </button>
                        </div>
                        <p class="text-gray-600">Movie management features coming soon...</p>
                    </div>
                </div>
                
                <!-- Schedules Tab -->
                <div x-show="currentTab === 'schedules'" x-cloak>
                    <div class="bg-white rounded-lg shadow p-6">
                        <div class="flex justify-between items-center mb-6">
                            <h3 class="text-xl font-semibold">Schedules Management</h3>
                            <button class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition">
                                <i class="fas fa-plus mr-2"></i>Add Schedule
                            </button>
                        </div>
                        <p class="text-gray-600">Schedule management features coming soon...</p>
                    </div>
                </div>
                
                <!-- Theaters Tab -->
                <div x-show="currentTab === 'theaters'" x-cloak>
                    <div class="bg-white rounded-lg shadow p-6">
                        <div class="flex justify-between items-center mb-6">
                            <h3 class="text-xl font-semibold">Theaters Management</h3>
                            <button class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition">
                                <i class="fas fa-plus mr-2"></i>Add Theater
                            </button>
                        </div>
                        <p class="text-gray-600">Theater management features coming soon...</p>
                    </div>
                </div>
                
                <!-- Categories Tab -->
                <div x-show="currentTab === 'categories'" x-cloak>
                    <div class="bg-white rounded-lg shadow p-6">
                        <div class="flex justify-between items-center mb-6">
                            <h3 class="text-xl font-semibold">Categories Management</h3>
                            <button class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition">
                                <i class="fas fa-plus mr-2"></i>Add Category
                            </button>
                        </div>
                        <p class="text-gray-600">Category management features coming soon...</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function adminApp() {
            return {
                currentTab: 'movies',
                
                getTabTitle() {
                    const titles = {
                        'movies': 'Movies Management',
                        'schedules': 'Schedules Management',
                        'theaters': 'Theaters Management',
                        'categories': 'Categories Management'
                    };
                    return titles[this.currentTab] || 'Dashboard';
                }
            }
        }
    </script>
</body>
</html>
