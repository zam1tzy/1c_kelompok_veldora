---MEMBUAT DATABASE---



---MEMBUAT TABEL USER---







---MEMBUAT TABEL PETUGAS---






---MEMBUAT TABEL FASILITAS---







---MEMBUAT TABEL KATEGORI KERUSAKAN---






---MEMBUAT TABEL LAPORAN BESERTA FOREIGN KEY/RELASI ANTAR TABEL---






















---MEMBUAT TABEL PENANGANAN BESERTA RELASI ANTAR TABEL---


















---MEMERIKSA RELASI TABEL/STRUKTUR TABEL---





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
START TRANSACTION;
INSERT INTO laporan
  (id_user, id_fasilitas, id_kategori, lokasi_detail, deskripsi, tanggal_lapor, status)
VALUES (1, 1, 2, 'Bilik 4', 'Proyektor tidak menyala (uji rollback)', '2026-10-07', 'Diproses');
SET @id_batal = LAST_INSERT_ID();
INSERT INTO penanganan (id_laporan, id_petugas, tanggal_penugasan, catatan)
VALUES (@id_batal, 2, '2026-10-07', 'Uji rollback');
ROLLBACK;
---PERIKSA HASIL---
SELECT * FROM laporan    WHERE id_laporan = @id_batal;
SELECT * FROM penanganan WHERE id_laporan = @id_batal;

---===Tahap 5 – Analisis Performa Database===---

 ---PEMBUATAN TABEL BANTU ANGKA 0-9---
CREATE TABLE digit (d TINYINT UNSIGNED PRIMARY KEY) ENGINE=InnoDB;
INSERT INTO digit VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);
---FASILITAS TAMBAHAN---
INSERT INTO fasilitas (nama_fasilitas, jenis_fasilitas, lokasi) VALUES
  ('Toilet Gedung B',     'Toilet',            'Gedung B Lt.1'),
  ('AC Ruang 101',        'Pendingin Ruangan', 'Gedung A'),
  ('Proyektor Ruang 102', 'Proyektor',         'Gedung A'),
  ('Lift Gedung C',       'Lift',              'Gedung C'),
  ('Parkiran Motor',      'Parkir',            'Area Parkir'),
  ('Perpustakaan',        'Ruang Baca',        'Gedung D'),
  ('Aula',                'Ruang Serbaguna',   'Gedung E');
---MENAMBAHKAN 10.000 USER TAMBAHAN---
INSERT INTO user (nama, nomor_induk, kategori_pengguna, email, password)
SELECT CONCAT('User ', n),
       CONCAT('9', LPAD(n, 8, '0')),
       ELT(1 + FLOOR(RAND()*3), 'Mahasiswa', 'Dosen', 'Tendik'),
       CONCAT('user', n, '@example.test'),
       'hash_dummy'
FROM (
  SELECT a.d + 10*b.d + 100*c.d + 1000*e.d AS n
  FROM digit a, digit b, digit c, digit e
) x;
---MENAMBAHKAN TOTAL 1.000.000 LAPORAN---
SET autocommit = 0;
INSERT INTO laporan
  (id_user, id_fasilitas, id_kategori, lokasi_detail, deskripsi, tanggal_lapor, status)
SELECT 1 + FLOOR(RAND()*10002),
       1 + FLOOR(RAND()*10),
       1 + FLOOR(RAND()*3),
       CONCAT('Ruang ', 1 + FLOOR(RAND()*50)),
       CONCAT('Kerusakan simulasi ', FLOOR(RAND()*100000)),
       DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND()*1035) DAY),
       ELT(1 + FLOOR(RAND()*3), 'Menunggu', 'Diproses', 'Selesai')
FROM digit a, digit b, digit c, digit d, digit e, digit f;
COMMIT;
---PENANGANAN UNTUK LAPORAN SIMULASI---
INSERT INTO penanganan
  (id_laporan, id_petugas, tanggal_penugasan, tanggal_selesai, catatan)
SELECT id_laporan,
       1 + FLOOR(RAND()*2),
       DATE_ADD(tanggal_lapor, INTERVAL 1 DAY),
       IF(status = 'Selesai', DATE_ADD(tanggal_lapor, INTERVAL 3 DAY), NULL),
       'Penanganan simulasi'
FROM laporan
WHERE status <> 'Menunggu'
  AND deskripsi LIKE 'Kerusakan simulasi%';
COMMIT;
SET autocommit = 1;
---PERBARUI STATISTIK TABEL---
ANALYZE TABLE laporan, penanganan, user;
---CEK JUMLAH DATA---
SELECT COUNT(*) AS total_user       FROM user;
SELECT COUNT(*) AS total_laporan    FROM laporan;
SELECT COUNT(*) AS total_penanganan FROM penanganan;

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


