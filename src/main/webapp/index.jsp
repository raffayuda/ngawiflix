<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="id" class="scroll-smooth">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CineGO - Pesan Tiket Bioskop Online</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
            rel="stylesheet">
        <style>
            body {
                font-family: 'Inter', sans-serif;
            }

            [x-cloak] {
                display: none !important;
            }

            .hero-gradient {
                background: linear-gradient(135deg, rgba(0, 0, 0, 0.9) 0%, rgba(0, 0, 0, 0.4) 50%, rgba(0, 0, 0, 0.9) 100%);
            }

            .feature-card {
                transition: all 0.3s ease;
            }

            .feature-card:hover {
                transform: translateY(-10px);
            }

            .btn-primary {
                background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
                transition: all 0.3s;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(239, 68, 68, 0.4);
            }

            .glow-text {
                text-shadow: 0 0 40px rgba(239, 68, 68, 0.5);
            }

            @keyframes float {

                0%,
                100% {
                    transform: translateY(0);
                }

                50% {
                    transform: translateY(-20px);
                }
            }

            .float-animation {
                animation: float 6s ease-in-out infinite;
            }
        </style>
    </head>

    <body class="bg-slate-950 text-white" x-data="berandaApp()">

        <!-- Include Navbar -->
        <jsp:include page="component/navbar.jsp" />

        <!-- Hero Section -->
        <section class="min-h-screen flex items-center relative overflow-hidden">
            <!-- Background Image -->
            <div class="absolute inset-0">
                <div class="absolute inset-0 bg-gradient-to-r from-slate-950 via-slate-950/80 to-slate-950"></div>
                <div class="absolute inset-0 bg-gradient-to-t from-slate-950 via-transparent to-slate-950/50"></div>
            </div>

            <div class="container mx-auto px-4 lg:px-8 relative z-10">
                <div class="grid lg:grid-cols-2 gap-12 items-center">
                    <!-- Left Content -->
                    <div class="text-center lg:text-left">
                        <div
                            class="inline-flex items-center px-4 py-2 bg-red-500/20 rounded-full text-red-400 text-sm font-medium mb-6">
                            <i class="fas fa-star mr-2"></i>
                            Platform Pemesanan Tiket #1
                        </div>

                        <h1 class="text-5xl md:text-6xl lg:text-7xl font-black mb-6 leading-tight">
                            Nikmati
                            <span
                                class="bg-gradient-to-r from-red-500 to-red-700 bg-clip-text text-transparent glow-text">
                                Pengalaman
                            </span>
                            <br>Bioskop Terbaik
                        </h1>

                        <p class="text-xl text-gray-300 mb-8 max-w-xl">
                            Pesan tiket bioskop favorit Anda dengan mudah dan cepat. Pilih film, jadwal, dan kursi dalam
                            hitungan detik.
                        </p>

                        <div class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
                            <a href="film.jsp"
                                class="btn-primary px-8 py-4 rounded-xl text-lg font-bold inline-flex items-center justify-center">
                                <i class="fas fa-film mr-3"></i>
                                Lihat Film
                            </a>
                            <a href="tentang-kami.jsp"
                                class="px-8 py-4 bg-slate-800 hover:bg-slate-700 rounded-xl text-lg font-semibold inline-flex items-center justify-center transition">
                                <i class="fas fa-info-circle mr-3"></i>
                                Tentang Kami
                            </a>
                        </div>

                        <!-- Stats -->
                        <div class="grid grid-cols-3 gap-6 mt-12">
                            <div class="text-center lg:text-left">
                                <div class="text-3xl font-bold text-red-500">100+</div>
                                <div class="text-sm text-gray-400">Film Tersedia</div>
                            </div>
                            <div class="text-center lg:text-left">
                                <div class="text-3xl font-bold text-red-500">50K+</div>
                                <div class="text-sm text-gray-400">Pengguna Aktif</div>
                            </div>
                            <div class="text-center lg:text-left">
                                <div class="text-3xl font-bold text-red-500">4.9</div>
                                <div class="text-sm text-gray-400">Rating Aplikasi</div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Content - Floating Cards -->
                    <div class="hidden lg:block relative">
                        <div class="relative w-full h-[500px]">
                            <!-- Main Card -->
                            <div
                                class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-72 bg-slate-900 rounded-2xl shadow-2xl overflow-hidden float-animation">
                                <div
                                    class="aspect-[2/3] bg-gradient-to-br from-red-600 to-red-900 flex items-center justify-center">
                                    <img src="assets/amba.png" alt="">
                                </div>
                                <div class="p-4">
                                    <h3 class="font-bold text-lg">Film Terbaru</h3>
                                    <p class="text-gray-400 text-sm">Tersedia di CineGO</p>
                                </div>
                            </div>

                            <!-- Floating Elements -->
                            <div class="absolute top-10 left-10 bg-slate-800 p-4 rounded-xl shadow-lg"
                                style="animation: float 4s ease-in-out infinite;">
                                <i class="fas fa-ticket-alt text-red-500 text-2xl"></i>
                            </div>
                            <div class="absolute bottom-20 left-20 bg-slate-800 p-4 rounded-xl shadow-lg"
                                style="animation: float 5s ease-in-out infinite 1s;">
                                <i class="fas fa-couch text-red-500 text-2xl"></i>
                            </div>
                            <div class="absolute top-20 right-10 bg-slate-800 p-4 rounded-xl shadow-lg"
                                style="animation: float 4.5s ease-in-out infinite 0.5s;">
                                <i class="fas fa-popcorn text-red-500 text-2xl"></i>
                            </div>
                            <div class="absolute bottom-10 right-20 bg-slate-800 p-4 rounded-xl shadow-lg"
                                style="animation: float 5.5s ease-in-out infinite 1.5s;">
                                <i class="fas fa-star text-yellow-500 text-2xl"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Features Section -->
        <section class="py-20 bg-slate-900/50">
            <div class="container mx-auto px-4 lg:px-8">
                <div class="text-center mb-16">
                    <h2 class="text-4xl font-bold mb-4">Kenapa Pilih <span class="text-red-500">CineGO</span>?</h2>
                    <p class="text-gray-400 max-w-2xl mx-auto">Kami menyediakan pengalaman pemesanan tiket bioskop yang
                        mudah, cepat, dan aman</p>
                </div>

                <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
                    <!-- Feature 1 -->
                    <div class="feature-card bg-slate-900 p-8 rounded-2xl border border-slate-800 text-center">
                        <div class="w-16 h-16 bg-red-500/20 rounded-2xl flex items-center justify-center mx-auto mb-6">
                            <i class="fas fa-bolt text-red-500 text-2xl"></i>
                        </div>
                        <h3 class="text-xl font-bold mb-3">Cepat & Mudah</h3>
                        <p class="text-gray-400">Pesan tiket dalam hitungan detik tanpa ribet</p>
                    </div>

                    <!-- Feature 2 -->
                    <div class="feature-card bg-slate-900 p-8 rounded-2xl border border-slate-800 text-center">
                        <div class="w-16 h-16 bg-red-500/20 rounded-2xl flex items-center justify-center mx-auto mb-6">
                            <i class="fas fa-shield-alt text-red-500 text-2xl"></i>
                        </div>
                        <h3 class="text-xl font-bold mb-3">Aman & Terpercaya</h3>
                        <p class="text-gray-400">Transaksi aman dengan berbagai metode pembayaran</p>
                    </div>

                    <!-- Feature 3 -->
                    <div class="feature-card bg-slate-900 p-8 rounded-2xl border border-slate-800 text-center">
                        <div class="w-16 h-16 bg-red-500/20 rounded-2xl flex items-center justify-center mx-auto mb-6">
                            <i class="fas fa-chair text-red-500 text-2xl"></i>
                        </div>
                        <h3 class="text-xl font-bold mb-3">Pilih Kursi</h3>
                        <p class="text-gray-400">Pilih sendiri kursi favorit Anda dengan mudah</p>
                    </div>

                    <!-- Feature 4 -->
                    <div class="feature-card bg-slate-900 p-8 rounded-2xl border border-slate-800 text-center">
                        <div class="w-16 h-16 bg-red-500/20 rounded-2xl flex items-center justify-center mx-auto mb-6">
                            <i class="fas fa-clock text-red-500 text-2xl"></i>
                        </div>
                        <h3 class="text-xl font-bold mb-3">Real-time</h3>
                        <p class="text-gray-400">Jadwal dan ketersediaan kursi selalu update</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- How It Works Section -->
        <section class="py-20">
            <div class="container mx-auto px-4 lg:px-8">
                <div class="text-center mb-16">
                    <h2 class="text-4xl font-bold mb-4">Cara <span class="text-red-500">Pemesanan</span></h2>
                    <p class="text-gray-400 max-w-2xl mx-auto">Ikuti langkah mudah berikut untuk memesan tiket bioskop
                    </p>
                </div>

                <div class="grid md:grid-cols-3 gap-8 max-w-4xl mx-auto">
                    <!-- Step 1 -->
                    <div class="text-center">
                        <div
                            class="w-20 h-20 bg-gradient-to-br from-red-500 to-red-700 rounded-full flex items-center justify-center mx-auto mb-6 text-3xl font-bold">
                            1
                        </div>
                        <h3 class="text-xl font-bold mb-3">Pilih Film</h3>
                        <p class="text-gray-400">Telusuri koleksi film dan pilih yang ingin Anda tonton</p>
                    </div>

                    <!-- Step 2 -->
                    <div class="text-center">
                        <div
                            class="w-20 h-20 bg-gradient-to-br from-red-500 to-red-700 rounded-full flex items-center justify-center mx-auto mb-6 text-3xl font-bold">
                            2
                        </div>
                        <h3 class="text-xl font-bold mb-3">Pilih Jadwal & Kursi</h3>
                        <p class="text-gray-400">Tentukan jadwal tayang dan kursi yang tersedia</p>
                    </div>

                    <!-- Step 3 -->
                    <div class="text-center">
                        <div
                            class="w-20 h-20 bg-gradient-to-br from-red-500 to-red-700 rounded-full flex items-center justify-center mx-auto mb-6 text-3xl font-bold">
                            3
                        </div>
                        <h3 class="text-xl font-bold mb-3">Bayar & Nikmati</h3>
                        <p class="text-gray-400">Lakukan pembayaran dan nikmati film favorit Anda!</p>
                    </div>
                </div>

                <div class="text-center mt-12">
                    <a href="film.jsp"
                        class="btn-primary px-10 py-4 rounded-xl text-lg font-bold inline-flex items-center">
                        <i class="fas fa-play mr-3"></i>
                        Mulai Pesan Sekarang
                    </a>
                </div>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="py-20 bg-gradient-to-r from-red-900/30 to-slate-900">
            <div class="container mx-auto px-4 lg:px-8 text-center">
                <h2 class="text-4xl font-bold mb-6">Siap Menonton Film Favorit?</h2>
                <p class="text-xl text-gray-300 mb-8 max-w-2xl mx-auto">
                    Jangan lewatkan film-film terbaru yang sedang tayang di bioskop. Pesan tiket sekarang!
                </p>
                <a href="film.jsp" class="btn-primary px-10 py-4 rounded-xl text-lg font-bold inline-flex items-center">
                    <i class="fas fa-ticket-alt mr-3"></i>
                    Pesan Tiket Sekarang
                </a>
            </div>
        </section>

        <!-- Footer -->
        <footer class="bg-slate-900 border-t border-slate-800 py-12">
            <div class="container mx-auto px-4 lg:px-8">
                <div class="grid md:grid-cols-4 gap-8 mb-8">
                    <!-- Brand -->
                    <div class="md:col-span-2">
                        <div class="flex items-center space-x-2 mb-4">
                            <div class="bg-gradient-to-br from-red-500 to-red-700 p-2 rounded-lg">
                                <i class="fas fa-film text-2xl"></i>
                            </div>
                            <span
                                class="text-2xl font-bold bg-gradient-to-r from-red-500 to-red-700 bg-clip-text text-transparent">
                                CineGO
                            </span>
                        </div>
                        <p class="text-gray-400 max-w-md">
                            Platform pemesanan tiket bioskop online terdepan di Indonesia. Mudah, cepat, dan aman.
                        </p>
                    </div>

                    <!-- Links -->
                    <div>
                        <h4 class="font-bold mb-4">Menu</h4>
                        <ul class="space-y-2 text-gray-400">
                            <li><a href="index.jsp" class="hover:text-red-500 transition">Beranda</a></li>
                            <li><a href="film.jsp" class="hover:text-red-500 transition">Film</a></li>
                            <li><a href="tentang-kami.jsp" class="hover:text-red-500 transition">Tentang Kami</a></li>
                            <li><a href="galeri.jsp" class="hover:text-red-500 transition">Galeri</a></li>
                        </ul>
                    </div>

                    <!-- Contact -->
                    <div>
                        <h4 class="font-bold mb-4">Kontak</h4>
                        <ul class="space-y-2 text-gray-400">
                            <li><i class="fas fa-envelope mr-2"></i>info@cinego.id</li>
                            <li><i class="fas fa-phone mr-2"></i>(021) 123-4567</li>
                            <li><i class="fas fa-map-marker-alt mr-2"></i>Jakarta, Indonesia</li>
                        </ul>
                    </div>
                </div>

                <div class="border-t border-slate-800 pt-8 flex flex-col md:flex-row justify-between items-center">
                    <p class="text-gray-400">&copy; 2025 CineGO. All rights reserved.</p>
                    <div class="flex space-x-4 mt-4 md:mt-0">
                        <a href="#" class="text-gray-400 hover:text-red-500 transition text-xl"><i
                                class="fab fa-facebook"></i></a>
                        <a href="#" class="text-gray-400 hover:text-red-500 transition text-xl"><i
                                class="fab fa-twitter"></i></a>
                        <a href="#" class="text-gray-400 hover:text-red-500 transition text-xl"><i
                                class="fab fa-instagram"></i></a>
                        <a href="#" class="text-gray-400 hover:text-red-500 transition text-xl"><i
                                class="fab fa-youtube"></i></a>
                    </div>
                </div>
            </div>
        </footer>

        <script>
            function berandaApp() {
                return {
                    // Add any Alpine.js data/methods if needed
                }
            }
        </script>
    </body>

    </html>