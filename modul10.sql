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








---PERIKSA HASIL---



---===Tahap 5 – Analisis Performa Database===---

 ---PEMBUATAN TABEL BANTU ANGKA 0-9---











---MENAMBAHKAN 10.000 USER TAMBAHAN---










---MENAMBAHKAN TOTAL 1.000.000 LAPORAN---












---PENANGANAN UNTUK LAPORAN SIMULASI---












---PERBARUI STATISTIK TABEL---

---CEK JUMLAH DATA---




---PENGUJIAN QUERY SEBELUM INDEX---
EXPLAIN
SELECT COUNT(*) AS total_user       FROM user;
SELECT COUNT(*) AS total_laporan    FROM laporan;
SELECT COUNT(*) AS total_penanganan FROM penanganan;
---JOIN+AGREGASI---
EXPLAIN
SELECT f.nama_fasilitas, COUNT(*) AS jumlah
FROM laporan l
JOIN fasilitas f ON f.id_fasilitas = l.id_fasilitas
WHERE l.tanggal_lapor >= '2026-10-01'
  AND l.tanggal_lapor <  '2026-11-01'
  AND l.status = 'Menunggu'
GROUP BY f.nama_fasilitas;
---WAKTU EKSEKUSI NYATA---
EXPLAIN ANALYZE
SELECT id_laporan, id_user, id_fasilitas, tanggal_lapor, status
FROM laporan
WHERE tanggal_lapor >= '2026-10-01'
  AND tanggal_lapor <  '2026-11-01';
---MENAMPILKAN HASIL---
SHOW INDEX FROM laporan; ---TANGGAL LAPORAN BELUM MEMPUNYAI INDEX---

---MEMBUAT INDEX---
CREATE INDEX idx_laporan_tanggal ON laporan(tanggal_lapor);
SHOW INDEX FROM laporan;

---PENGUJIAN QUERY SETELAH INDEX---
EXPLAIN
SELECT id_laporan, id_user, id_fasilitas, tanggal_lapor, status
FROM laporan
WHERE tanggal_lapor >= '2026-10-01'
  AND tanggal_lapor <  '2026-11-01';
EXPLAIN
SELECT f.nama_fasilitas, COUNT(*) AS jumlah
FROM laporan l
JOIN fasilitas f ON f.id_fasilitas = l.id_fasilitas
WHERE l.tanggal_lapor >= '2026-10-01'
  AND l.tanggal_lapor <  '2026-11-01'
  AND l.status = 'Menunggu'
GROUP BY f.nama_fasilitas;
EXPLAIN ANALYZE
SELECT id_laporan, id_user, id_fasilitas, tanggal_lapor, status
FROM laporan
WHERE tanggal_lapor >= '2026-10-01'
  AND tanggal_lapor <  '2026-11-01';

---COMPOSITE INDEX UNTUK FILTER STATUS---
CREATE INDEX idx_laporan_status_tanggal ON laporan(status, tanggal_lapor);

EXPLAIN
SELECT f.nama_fasilitas, COUNT(*) AS jumlah
FROM laporan l
JOIN fasilitas f ON f.id_fasilitas = l.id_fasilitas
WHERE l.tanggal_lapor >= '2026-10-01'
  AND l.tanggal_lapor <  '2026-11-01'
  AND l.status = 'Menunggu'
GROUP BY f.nama_fasilitas;

---CONTOH INDEX TIDAK TERPAKAI---
EXPLAIN
SELECT COUNT(*) FROM laporan
WHERE YEAR(tanggal_lapor) = 2026 AND MONTH(tanggal_lapor) = 10;

---VALIDASI HASIL RESTORE---
USE campus_facility_report_restore;
SHOW TABLES;
SELECT COUNT(*) FROM user;
SELECT COUNT(*) FROM petugas;
SELECT COUNT(*) FROM fasilitas;
SELECT COUNT(*) FROM kategori_kerusakan;
SELECT COUNT(*) FROM laporan;
SELECT COUNT(*) FROM penanganan;
---PERBANDINGAN DENGAN DATABASE ASLI---
USE campus_facility_report;
SELECT COUNT(*) FROM laporan;
SELECT COUNT(*) FROM penanganan:
