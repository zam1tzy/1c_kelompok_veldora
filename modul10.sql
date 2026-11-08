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
INSERT INTO user (nama, nomor_induk, kategori_pengguna, email, password) VALUES
  ('Adam',    '264311060', 'Mahasiswa', 'adam@email.com',    'adam123*123'),
  ('Iltizam', '264311071', 'Mahasiswa', 'iltizam@yahoo.com', 'ijul098*761');

INSERT INTO petugas (nama, jabatan, email, password) VALUES
  ('Pak Udin',  'Teknisi',             'udin22@email.com',   'udin123321'),
  ('Pak Setiawan', 'Pengelola Fasilitas', 'set1awan@email.com', 'setiawan91872');

INSERT INTO fasilitas (nama_fasilitas, jenis_fasilitas, lokasi) VALUES
  ('Toilet Gedung A', 'Toilet',                'Gedung A Lt.1'),
  ('WiFi Gedung B',   'Jaringan Internet',     'Gedung B'),
  ('Lab Komputer 1',  'Laboratorium Komputer', 'Gedung C');

INSERT INTO kategori_kerusakan (nama_kategori, deskripsi) VALUES
  ('Ringan', 'Gangguan kecil, fasilitas masih bisa dipakai'),
  ('Sedang', 'Fungsi fasilitas terganggu sebagian'),
  ('Berat',  'Fasilitas tidak dapat digunakan');

INSERT INTO laporan
  (id_user, id_fasilitas, id_kategori, lokasi_detail, deskripsi, tanggal_lapor, status) VALUES
  (1, 1, 3, 'Bilik 2',  'Kran patah',       '2026-10-01', 'Menunggu'),
  (2, 1, 1, 'Bilik 1',  'Lampu redup',      '2026-10-02', 'Diproses'),
  (1, 2, 2, 'Lantai 2', 'WiFi putus-putus', '2026-10-03', 'Selesai'),
  (2, 1, 3, 'Bilik 3',  'Pintu rusak',      '2026-10-04', 'Menunggu'),
  (1, 3, 2, 'Meja 5',   'Monitor mati',     '2026-10-05', 'Diproses');

INSERT INTO penanganan
  (id_laporan, id_petugas, tanggal_penugasan, tanggal_selesai, catatan) VALUES
  (2, 1, '2026-10-03', NULL,         'Ganti lampu'),
  (3, 1, '2026-10-04', '2026-10-06', 'Router direset'),
  (5, 1, '2026-10-06', NULL,         'Cek unit monitor');

---===Praktik Operasi Database CRUD===---

---CREATE – Menambahkan Data---
INSERT INTO user (nama, nomor_induk, kategori_pengguna, email, password)
VALUES ('Andi', '264311099', 'Mahasiswa', 'andi@example.test', 'hash_dummy');

SELECT * FROM user;

---READ – Membaca Data---
SELECT l.id_laporan, u.nama AS pelapor, f.nama_fasilitas,
       k.nama_kategori, l.deskripsi, l.tanggal_lapor, l.status
FROM laporan l
JOIN user u               ON u.id_user = l.id_user
JOIN fasilitas f          ON f.id_fasilitas = l.id_fasilitas
JOIN kategori_kerusakan k ON k.id_kategori = l.id_kategori
ORDER BY l.tanggal_lapor;
SELECT * FROM laporan WHERE status = 'Menunggu';

---UPDATE – Memperbarui Data---
UPDATE laporan SET status = 'Diproses' WHERE id_laporan = 1;
SELECT * FROM laporan WHERE id_laporan = 1;

---DELETE – Menghapus Data---
DELETE FROM user WHERE email = 'andi@example.test';
SELECT * FROM user;

---MENGUJI INTEGRITAS REFERENSIAL---
INSERT INTO laporan
  (id_user, id_fasilitas, id_kategori, deskripsi, tanggal_lapor)
VALUES (9999999, 1, 1, 'Uji FK user tidak ada', '2026-10-07');
---DAN JUGA---
DELETE FROM user WHERE id_user = 1;

---===PENGUJIAN TRANSAKSI DATABASE===---

---PENGUJIAN COMMIT---
START TRANSACTION;
INSERT INTO laporan
  (id_user, id_fasilitas, id_kategori, lokasi_detail, deskripsi, tanggal_lapor, status)
VALUES (2, 3, 3, 'Meja 2', 'Keyboard tidak berfungsi', '2026-10-06', 'Diproses');
SET @id_baru = LAST_INSERT_ID();
INSERT INTO penanganan (id_laporan, id_petugas, tanggal_penugasan, catatan)
VALUES (@id_baru, 1, '2026-10-06', 'Dijadwalkan pengecekan');
COMMIT;
---PERIKSA HASIL---
SELECT * FROM laporan    WHERE id_laporan = @id_baru;
SELECT * FROM penanganan WHERE id_laporan = @id_baru;

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


