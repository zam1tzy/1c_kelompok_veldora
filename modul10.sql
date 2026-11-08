---MEMBUAT DATABASE---
CREATE DATABASE praktikum_modul10;
USE praktikum_modul10;

---MEMBUAT TABEL USER---
CREATE TABLE user (
  id_user INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100), nomor_induk VARCHAR(20),
  kategori_pengguna ENUM('Mahasiswa','Dosen','Tendik'),
  email VARCHAR(100), password VARCHAR(255)
);

---MEMBUAT TABEL PETUGAS---
CREATE TABLE petugas (
  id_petugas INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100), jabatan ENUM('Teknisi','Pengelola Fasilitas'),
  email VARCHAR(100), password VARCHAR(255)
);

---MEMBUAT TABEL FASILITAS---
CREATE TABLE fasilitas (
  id_fasilitas    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nama_fasilitas  VARCHAR(100) NOT NULL,
  jenis_fasilitas VARCHAR(50)  NOT NULL,
  lokasi          VARCHAR(100) NOT NULL
);

---MEMBUAT TABEL KATEGORI KERUSAKAN---
CREATE TABLE kategori_kerusakan (
  id_kategori   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nama_kategori ENUM('Ringan','Sedang','Berat') NOT NULL UNIQUE,
  deskripsi     VARCHAR(200)
);

---MEMBUAT TABEL LAPORAN BESERTA FOREIGN KEY/RELASI ANTAR TABEL---
CREATE TABLE laporan (
  id_laporan    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_user       INT UNSIGNED NOT NULL,
  id_fasilitas  INT UNSIGNED NOT NULL,
  id_kategori   INT UNSIGNED NOT NULL,
  lokasi_detail VARCHAR(150),
  deskripsi     TEXT NOT NULL,
  foto_bukti    VARCHAR(255),
  tanggal_lapor DATE NOT NULL,
  status        ENUM('Menunggu','Diproses','Selesai') NOT NULL DEFAULT 'Menunggu',

  CONSTRAINT fk_laporan_user
    FOREIGN KEY (id_user) REFERENCES user(id_user)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_laporan_fasilitas
    FOREIGN KEY (id_fasilitas) REFERENCES fasilitas(id_fasilitas)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_laporan_kategori
    FOREIGN KEY (id_kategori) REFERENCES kategori_kerusakan(id_kategori)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

---MEMBUAT TABEL PENANGANAN BESERTA RELASI ANTAR TABEL---
CREATE TABLE penanganan (
  id_penanganan     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_laporan        INT UNSIGNED NOT NULL,
  id_petugas        INT UNSIGNED NOT NULL,
  tanggal_penugasan DATE NOT NULL,
  tanggal_selesai   DATE NULL,
  catatan           TEXT,

  CONSTRAINT fk_penanganan_laporan
    FOREIGN KEY (id_laporan) REFERENCES laporan(id_laporan)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_penanganan_petugas
    FOREIGN KEY (id_petugas) REFERENCES petugas(id_petugas)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_tanggal_penanganan
    CHECK (tanggal_selesai IS NULL OR tanggal_selesai >= tanggal_penugasan)
);

---MEMERIKSA RELASI TABEL/STRUKTUR TABEL---
SHOW TABLES;
SHOW CREATE TABLE user;
SHOW CREATE TABLE laporan;
SHOW CREATE TABLE penanganan;

---MENGISI DATA AWAL---
































---===Praktik Operasi Database CRUD===---

---CREATE – Menambahkan Data---





---READ – Membaca Data---









---UPDATE – Memperbarui Data---



---DELETE – Menghapus Data---



---MENGUJI INTEGRITAS REFERENSIAL---






---===PENGUJIAN TRANSAKSI DATABASE===---

---PENGUJIAN COMMIT---








---PERIKSA HASIL---



---PENGUJIAN ROLLBACK---








---PERIKSA HASIL---



---===Tahap 5 – Analisis Performa Database===---

 ---PEMBUATAN TABEL BANTU ANGKA 0-9---











---MENAMBAHKAN 10.000 USER TAMBAHAN---










---MENAMBAHKAN TOTAL 1.000.000 LAPORAN---












---PENANGANAN UNTUK LAPORAN SIMULASI---












---PERBARUI STATISTIK TABEL---

---CEK JUMLAH DATA---




---PENGUJIAN QUERY SEBELUM INDEX---




---JOIN+AGREGASI---








---WAKTU EKSEKUSI NYATA---





---MENAMPILKAN HASIL---


---MEMBUAT INDEX---



---PENGUJIAN QUERY SETELAH INDEX---



















---COMPOSITE INDEX UNTUK FILTER STATUS---











---CONTOH INDEX TIDAK TERPAKAI---




---VALIDASI HASIL RESTORE---








---PERBANDINGAN DENGAN DATABASE ASLI---


