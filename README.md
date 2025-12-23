# FILMPEDIA

FILMPEDIA adalah aplikasi mobile berbasis Flutter yang berfungsi sebagai katalog film digital. Aplikasi ini memanfaatkan **TMDB (The Movie Database) API** untuk menampilkan informasi film secara dinamis, dilengkapi dengan fitur autentikasi pengguna, manajemen favorit, pencarian, filter, serta antarmuka modern yang responsif.

Aplikasi ini dikembangkan sebagai bagian dari tugas akademik dan dirancang dengan pendekatan arsitektur yang terstruktur serta pengalaman pengguna (User Experience) yang optimal.

---

## 🎯 Tujuan Aplikasi

Tujuan utama pengembangan FILMPEDIA adalah:
- Menyediakan platform pencarian dan eksplorasi film yang informatif
- Mengimplementasikan konsep **API Integration**, **State Management**, dan **Firebase Authentication**
- Menerapkan praktik pengembangan aplikasi mobile yang baik dan terstruktur
- Menghasilkan aplikasi Flutter yang siap digunakan dan mudah dikembangkan lebih lanjut

---

## 🚀 Fitur Utama

### 🔐 Autentikasi Pengguna
- Login dan register menggunakan Firebase Authentication
- Sistem sesi otomatis (auto-login)
- Setiap akun memiliki data favorit masing-masing

### 🏠 Halaman Home
- Menampilkan daftar film dari TMDB API
- Infinite scroll (pagination)
- Skeleton loading (Shimmer)
- Pull to refresh
- Tombol “Scroll to Top”

### 🔍 Pencarian & Filter
- Pencarian film secara real-time
- Filter berdasarkan:
  - Popular
  - Top Rated
  - Upcoming
  - Now Playing
- Filter genre film
- Kombinasi filter dan sort yang saling terintegrasi

###  Favorit Film
- Menambahkan dan menghapus film dari daftar favorit
- Data favorit disimpan di Firebase Firestore
- Favorit bersifat spesifik per akun pengguna

###  Halaman Detail Film
- Informasi lengkap film (judul, tahun, rating, sinopsis)
- Trailer film (YouTube)
- Tombol favorit langsung dari halaman detail

###  Profil Pengguna
- Menampilkan username dan email
- Edit username
- Logout dan switch account

### ℹ️ About
- Informasi pengembang
- Informasi aplikasi

---

## 🧠 Teknologi yang Digunakan

- **Flutter** – Framework utama pengembangan aplikasi
- **Dart** – Bahasa pemrograman
- **Firebase Authentication** – Autentikasi pengguna
- **Firebase Firestore** – Penyimpanan data favorit dan profil pengguna
- **TMDB API** – Sumber data film
- **Provider** – State management
- **YouTube Player Flutter** – Pemutar trailer
- **Shimmer** – Skeleton loading UI

---

## 📂 Struktur Proyek (Ringkas)

lib/
├── core/ # Konstanta & konfigurasi
├── providers/ # State management (Theme, Favorite)
├── services/ # API & Firebase service
├── screens/ # Halaman aplikasi
├── widgets/ # Reusable UI components
└── main.dart # Entry point aplikasi

yaml
Copy code

---

## ⚙️ Cara Menjalankan Proyek

1. Pastikan Flutter sudah terinstal
2. Clone repository ini
   ```bash
   git clone https://github.com/username/filmpedia.git
Masuk ke direktori proyek

bash
Copy code
cd filmpedia
Install dependency

bash
Copy code
flutter pub get
Jalankan aplikasi

bash
Copy code
flutter run
📦 Build APK (Release)
bash
Copy code
flutter build apk --release
File APK akan berada di:


build/app/outputs/flutter-apk/app-release.apk
🔒 Catatan API & Keamanan
API Key TMDB disimpan dalam file konfigurasi (tidak disarankan untuk production)

Firebase Rules digunakan untuk membatasi akses data berdasarkan user ID

Aplikasi ini ditujukan untuk keperluan pembelajaran dan akademik

📌 Sumber Data
The Movie Database (TMDB)
https://www.themoviedb.org/

👨‍💻 Pengembang
Nama: Rizqi Akbar Hernawan
Program Studi: Teknik Komputer
Platform: Flutter (Android)

📄 Lisensi
Proyek ini dibuat untuk keperluan akademik dan pembelajaran.
Tidak digunakan untuk tujuan komersial.

© 2025 – FILMPEDIA
