<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="id" class="scroll-smooth">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Galeri - CineGO</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
        <style>
            .gallery-item {
                transition: all 0.3s ease;
            }

            .gallery-item:hover {
                transform: translateY(-8px);
            }

            .gallery-overlay {
                transition: opacity 0.3s ease;
            }

            .gallery-item:hover .gallery-overlay {
                opacity: 1;
            }
        </style>
    </head>

    <body class="bg-slate-950 text-white" x-data="galleryApp()">

        <!-- Include Navbar -->
        <jsp:include page="component/navbar.jsp" />

        <!-- Hero Section -->
        <section class="pt-32 pb-20 relative overflow-hidden">
            <div class="absolute inset-0 bg-gradient-to-b from-red-900/20 to-transparent"></div>
            <div class="container mx-auto px-4 lg:px-8 relative z-10">
                <div class="text-center max-w-4xl mx-auto">
                    <h1
                        class="text-5xl md:text-6xl font-bold mb-6 bg-gradient-to-r from-red-500 to-red-700 bg-clip-text text-transparent">
                        Galeri CineGO
                    </h1>

                </div>
            </div>
        </section>


        <!-- Gallery Grid -->
        <section class="py-20">
            <div class="container mx-auto px-4 lg:px-8">
                <!-- 2-Column Grid for 2 Images -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 max-w-5xl mx-auto">
                    <template x-for="item in filteredGallery" :key="item.id">
                        <div class="gallery-item group cursor-pointer" @click="openLightbox(item)">
                            <div
                                class="relative overflow-hidden rounded-2xl bg-slate-900 border border-slate-800 shadow-2xl">
                                <!-- Actual Image Display -->
                                <div class="aspect-[4/3] overflow-hidden">
                                    <img :src="item.image" :alt="item.title"
                                        class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110">
                                </div>
                                <!-- Hover Overlay -->
                                <div
                                    class="gallery-overlay absolute inset-0 bg-black/70 opacity-0 flex items-center justify-center">
                                    <div class="text-center p-6">
                                        <i class="fas fa-search-plus text-4xl mb-3 text-red-500"></i>
                                        <p class="text-lg font-semibold" x-text="item.title"></p>
                                    </div>
                                </div>
                                <!-- Title Overlay -->
                                <div
                                    class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/90 to-transparent p-6">
                                    <h3 class="font-bold text-xl mb-2" x-text="item.title"></h3>
                                    <p class="text-sm text-gray-300" x-text="item.description"></p>
                                    <div class="mt-3 flex items-center text-sm text-red-400">
                                        <i :class="item.icon" class="mr-2"></i>
                                        <span x-text="item.category"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </template>
                </div>

                <!-- Empty State -->
                <div x-show="filteredGallery.length === 0" class="text-center py-20">
                    <i class="fas fa-images text-6xl text-gray-600 mb-4"></i>
                    <p class="text-xl text-gray-400">Tidak ada gambar dalam kategori ini</p>
                </div>
            </div>
        </section>

        <!-- Lightbox Modal -->
        <div x-show="lightboxOpen" x-transition @click="closeLightbox()"
            class="fixed inset-0 bg-black/95 z-50 flex items-center justify-center p-4" style="display: none;">
            <div class="relative max-w-4xl w-full" @click.stop>
                <button @click="closeLightbox()"
                    class="absolute -top-12 right-0 text-white hover:text-red-500 transition">
                    <i class="fas fa-times text-3xl"></i>
                </button>

                <template x-if="selectedItem">
                    <div class="bg-slate-900 rounded-2xl overflow-hidden max-h-[90vh] overflow-y-auto">
                        <!-- Actual Image in Lightbox -->
                        <div class="flex items-center justify-center">
                            <img :src="selectedItem.image" :alt="selectedItem.title" class="w-full h-auto">
                        </div>
                        <div class="p-6">
                            <h2 class="text-2xl font-bold mb-2" x-text="selectedItem.title"></h2>
                            <p class="text-gray-300 mb-4" x-text="selectedItem.description"></p>
                            <div class="flex items-center text-sm text-red-400">
                                <i :class="selectedItem.icon" class="mr-2"></i>
                                <span x-text="selectedItem.category"></span>
                            </div>
                        </div>
                    </div>
                </template>
            </div>
        </div>

        <!-- Footer -->
        <footer class="bg-slate-900 border-t border-slate-800 py-12">
            <div class="container mx-auto px-4 lg:px-8">
                <div class="flex flex-col md:flex-row justify-between items-center">
                    <div class="flex items-center space-x-2 mb-4 md:mb-0">
                        <div class="bg-gradient-to-br from-red-500 to-red-700 p-2 rounded-lg">
                            <i class="fas fa-film text-2xl"></i>
                        </div>
                        <span
                            class="text-2xl font-bold bg-gradient-to-r from-red-500 to-red-700 bg-clip-text text-transparent">
                            CineGO
                        </span>
                    </div>
                    <div class="text-gray-400">
                        <p>&copy; 2025 CineGO. All rights reserved.</p>
                    </div>
                </div>
            </div>
        </footer>

        <script>
            function galleryApp() {
                return {
                    currentFilter: 'all',
                    lightboxOpen: false,
                    selectedItem: null,
                    gallery: [
                        {
                            id: 1,
                            title: 'Skema Database',
                            description: 'Struktur database aplikasi pemesanan tiket bioskop CineGO',
                            category: 'Database',
                            image: 'assets/skema.png',
                            icon: 'fas fa-database'
                        },
                        {
                            id: 2,
                            title: 'Dokumentasi Proyek',
                            description: 'Dokumentasi pengembangan aplikasi CineGO',
                            category: 'Dokumentasi',
                            image: 'assets/dok.png',
                            icon: 'fas fa-file-alt'
                        }
                    ],
                    get filteredGallery() {
                        if (this.currentFilter === 'all') {
                            return this.gallery;
                        }
                        return this.gallery.filter(item => item.category === this.currentFilter);
                    },

                    filterGallery(category) {
                        this.currentFilter = category;
                    },

                    openLightbox(item) {
                        this.selectedItem = item;
                        this.lightboxOpen = true;
                        document.body.style.overflow = 'hidden';
                    },

                    closeLightbox() {
                        this.lightboxOpen = false;
                        this.selectedItem = null;
                        document.body.style.overflow = 'auto';
                    },

                    getCategoryName(category) {
                        const categories = {
                            'cinema': 'Interior Bioskop',
                            'movies': 'Film',
                            'events': 'Event'
                        };
                        return categories[category] || category;
                    }
                }
            }
        </script>

    </body>

    </html>