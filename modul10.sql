-- =====================================================================
-- modul10.sql
-- Praktikum Modul 10: DBMS dan Aplikasi Basis Data
-- Proyek: Sistem Pelaporan Kerusakan Fasilitas Kampus
-- Jalankan BERURUTAN, bagian demi bagian (jangan lupa screenshot hasilnya).
-- Gunakan data fiktif saja. Jangan commit password/kredensial asli ke Git.
-- =====================================================================


-- =====================================================================
-- TAHAP 1: IDENTIFIKASI DBMS
-- =====================================================================
SELECT VERSION();
SELECT @@version_comment;
SHOW ENGINES;
SHOW DATABASES;


-- =====================================================================
-- TAHAP 2: IMPLEMENTASI SKEMA (DDL)
-- =====================================================================
CREATE DATABASE IF NOT EXISTS campus_facility_report
  CHARACTER SET utf8mb4;
USE campus_facility_report;

CREATE TABLE user (
  id_user           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nama              VARCHAR(100) NOT NULL,
  nomor_induk       VARCHAR(20)  NOT NULL UNIQUE,
  kategori_pengguna ENUM('Mahasiswa','Dosen','Tendik') NOT NULL,
  email             VARCHAR(100) NOT NULL UNIQUE,
  password          VARCHAR(255) NOT NULL          -- simpan HASH, bukan teks asli
) ENGINE=InnoDB;

CREATE TABLE petugas (
  id_petugas INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nama       VARCHAR(100) NOT NULL,
  jabatan    ENUM('Teknisi','Pengelola Fasilitas') NOT NULL,
  email      VARCHAR(100) NOT NULL UNIQUE,
  password   VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE fasilitas (
  id_fasilitas    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nama_fasilitas  VARCHAR(100) NOT NULL,
  jenis_fasilitas VARCHAR(50)  NOT NULL,
  lokasi          VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE kategori_kerusakan (
  id_kategori   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nama_kategori ENUM('Ringan','Sedang','Berat') NOT NULL UNIQUE,
  deskripsi     VARCHAR(200)
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

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
  -- CHECK butuh MySQL >= 8.0.16 atau MariaDB >= 10.2.1
  CONSTRAINT chk_tanggal_penanganan
    CHECK (tanggal_selesai IS NULL OR tanggal_selesai >= tanggal_penugasan)
) ENGINE=InnoDB;

-- Periksa struktur, PK, FK, constraint
SHOW TABLES;
SHOW CREATE TABLE user;
SHOW CREATE TABLE laporan;
SHOW CREATE TABLE penanganan;

-- ---------------------------------------------------------------------
-- Data awal
-- ---------------------------------------------------------------------
INSERT INTO user (nama, nomor_induk, kategori_pengguna, email, password) VALUES
  ('Adam',    '264311060', 'Mahasiswa', 'adam@example.test',    'hash_dummy'),
  ('Iltizam', '264311071', 'Mahasiswa', 'iltizam@example.test', 'hash_dummy');

INSERT INTO petugas (nama, jabatan, email, password) VALUES
  ('Pak Teknisi',  'Teknisi',             'teknisi@example.test',   'hash_dummy'),
  ('Bu Pengelola', 'Pengelola Fasilitas', 'pengelola@example.test', 'hash_dummy');

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


-- =====================================================================
-- TAHAP 3: CRUD
-- =====================================================================

-- CREATE
INSERT INTO user (nama, nomor_induk, kategori_pengguna, email, password)
VALUES ('Andi', '264311099', 'Mahasiswa', 'andi@example.test', 'hash_dummy');
SELECT * FROM user;

-- READ (join laporan + user + fasilitas + kategori)
SELECT l.id_laporan, u.nama AS pelapor, f.nama_fasilitas,
       k.nama_kategori, l.deskripsi, l.tanggal_lapor, l.status
FROM laporan l
JOIN user u               ON u.id_user = l.id_user
JOIN fasilitas f          ON f.id_fasilitas = l.id_fasilitas
JOIN kategori_kerusakan k ON k.id_kategori = l.id_kategori
ORDER BY l.tanggal_lapor;

SELECT * FROM laporan WHERE status = 'Menunggu';

-- UPDATE
UPDATE laporan SET status = 'Diproses' WHERE id_laporan = 1;
SELECT * FROM laporan WHERE id_laporan = 1;

-- DELETE (user Andi belum punya laporan, jadi boleh dihapus)
DELETE FROM user WHERE email = 'andi@example.test';
SELECT * FROM user;

-- Rapikan counter AUTO_INCREMENT supaya id user berikutnya = 3
ALTER TABLE user AUTO_INCREMENT = 3;


-- =====================================================================
-- TAHAP 3b: PENGUJIAN INTEGRITAS
-- Jalankan SATU PER SATU. Semua harus GAGAL (ERROR). Screenshot pesan error-nya.
-- =====================================================================

-- 1) FK: laporan dengan user yang tidak ada -> ERROR 1452
INSERT INTO laporan
  (id_user, id_fasilitas, id_kategori, deskripsi, tanggal_lapor)
VALUES (9999999, 1, 1, 'Uji FK user tidak ada', '2026-10-07');

-- 2) FK: laporan dengan kategori yang tidak ada -> ERROR 1452
INSERT INTO laporan
  (id_user, id_fasilitas, id_kategori, deskripsi, tanggal_lapor)
VALUES (1, 1, 99, 'Uji FK kategori tidak ada', '2026-10-07');

-- 3) ON DELETE RESTRICT: hapus user yang sudah punya laporan -> ERROR 1451
DELETE FROM user WHERE id_user = 1;

-- 4) UNIQUE: email duplikat -> ERROR 1062
INSERT INTO user (nama, nomor_induk, kategori_pengguna, email, password)
VALUES ('Dobel', '264311098', 'Dosen', 'adam@example.test', 'hash_dummy');

-- 5) ENUM: status tidak valid -> ERROR 1265 (jika sql_mode strict, default MySQL 8)
INSERT INTO laporan
  (id_user, id_fasilitas, id_kategori, deskripsi, tanggal_lapor, status)
VALUES (1, 1, 1, 'Uji ENUM status', '2026-10-07', 'Rusak');

-- 6) CHECK: tanggal selesai lebih awal dari tanggal penugasan -> ERROR (check constraint violated)
INSERT INTO penanganan
  (id_laporan, id_petugas, tanggal_penugasan, tanggal_selesai, catatan)
VALUES (1, 1, '2026-10-10', '2026-10-01', 'Uji CHECK');


-- =====================================================================
-- TAHAP 4: TRANSAKSI
-- =====================================================================

-- 1) COMMIT: laporan baru + penugasan teknisi, disimpan sebagai satu kesatuan
START TRANSACTION;

INSERT INTO laporan
  (id_user, id_fasilitas, id_kategori, lokasi_detail, deskripsi, tanggal_lapor, status)
VALUES (2, 3, 3, 'Meja 2', 'Keyboard tidak berfungsi', '2026-10-06', 'Diproses');

SET @id_baru = LAST_INSERT_ID();

INSERT INTO penanganan (id_laporan, id_petugas, tanggal_penugasan, catatan)
VALUES (@id_baru, 1, '2026-10-06', 'Dijadwalkan pengecekan');

COMMIT;

SELECT * FROM laporan    WHERE id_laporan = @id_baru;
SELECT * FROM penanganan WHERE id_laporan = @id_baru;
-- Harapan: kedua data tersimpan.

-- 2) ROLLBACK: semua dibatalkan
START TRANSACTION;

INSERT INTO laporan
  (id_user, id_fasilitas, id_kategori, lokasi_detail, deskripsi, tanggal_lapor, status)
VALUES (1, 1, 2, 'Bilik 4', 'Proyektor tidak menyala (uji rollback)', '2026-10-07', 'Diproses');

SET @id_batal = LAST_INSERT_ID();

INSERT INTO penanganan (id_laporan, id_petugas, tanggal_penugasan, catatan)
VALUES (@id_batal, 2, '2026-10-07', 'Uji rollback');

ROLLBACK;

SELECT * FROM laporan    WHERE id_laporan = @id_batal;
SELECT * FROM penanganan WHERE id_laporan = @id_batal;
-- Harapan: kedua query mengembalikan 0 baris.


-- =====================================================================
-- TAHAP 5: ANALISIS PERFORMA (DATA MASSAL)
-- =====================================================================

-- Tabel bantu angka 0-9. Cross join 6x = 1.000.000 baris.
CREATE TABLE digit (d TINYINT UNSIGNED PRIMARY KEY) ENGINE=InnoDB;
INSERT INTO digit VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

-- 7 fasilitas tambahan (total 10)
INSERT INTO fasilitas (nama_fasilitas, jenis_fasilitas, lokasi) VALUES
  ('Toilet Gedung B',     'Toilet',            'Gedung B Lt.1'),
  ('AC Ruang 101',        'Pendingin Ruangan', 'Gedung A'),
  ('Proyektor Ruang 102', 'Proyektor',         'Gedung A'),
  ('Lift Gedung C',       'Lift',              'Gedung C'),
  ('Parkiran Motor',      'Parkir',            'Area Parkir'),
  ('Perpustakaan',        'Ruang Baca',        'Gedung D'),
  ('Aula',                'Ruang Serbaguna',   'Gedung E');

-- 10.000 user tambahan (id 3 s.d. 10002)
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

-- 1.000.000 laporan, tanggal tersebar 2024-01-01 s.d. sekitar akhir Nov 2026
-- (Oktober 2026 kira-kira 3% dari seluruh data, jadi cukup selektif untuk index)
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

-- Penanganan untuk laporan simulasi yang sudah diproses/selesai (~666 ribu baris)
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

-- Perbarui statistik tabel supaya optimizer punya data yang akurat
ANALYZE TABLE laporan, penanganan, user;

-- Cek jumlah data
SELECT COUNT(*) AS total_user       FROM user;
SELECT COUNT(*) AS total_laporan    FROM laporan;
SELECT COUNT(*) AS total_penanganan FROM penanganan;

-- ---------------------------------------------------------------------
-- 5a. SEBELUM INDEX
-- ---------------------------------------------------------------------
-- Query A: laporan bulan Oktober 2026
EXPLAIN
SELECT id_laporan, id_user, id_fasilitas, tanggal_lapor, status
FROM laporan
WHERE tanggal_lapor >= '2026-10-01'
  AND tanggal_lapor <  '2026-11-01';

-- Query B: JOIN + agregasi, jumlah laporan 'Menunggu' per fasilitas bulan Oktober 2026
EXPLAIN
SELECT f.nama_fasilitas, COUNT(*) AS jumlah
FROM laporan l
JOIN fasilitas f ON f.id_fasilitas = l.id_fasilitas
WHERE l.tanggal_lapor >= '2026-10-01'
  AND l.tanggal_lapor <  '2026-11-01'
  AND l.status = 'Menunggu'
GROUP BY f.nama_fasilitas;

-- Waktu eksekusi nyata (MySQL 8.0.18+). Di MariaDB pakai: ANALYZE SELECT ...
EXPLAIN ANALYZE
SELECT id_laporan, id_user, id_fasilitas, tanggal_lapor, status
FROM laporan
WHERE tanggal_lapor >= '2026-10-01'
  AND tanggal_lapor <  '2026-11-01';

-- Catatan: kolom FK (id_user, id_fasilitas, id_kategori) otomatis diberi index oleh InnoDB,
-- tetapi tanggal_lapor belum punya index.
SHOW INDEX FROM laporan;

-- ---------------------------------------------------------------------
-- 5b. BUAT INDEX
-- ---------------------------------------------------------------------
CREATE INDEX idx_laporan_tanggal ON laporan(tanggal_lapor);
SHOW INDEX FROM laporan;

-- ---------------------------------------------------------------------
-- 5c. SESUDAH INDEX (jalankan ulang query yang sama)
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- 5d. (Opsional, nilai tambah) COMPOSITE INDEX untuk filter status + tanggal
-- ---------------------------------------------------------------------
CREATE INDEX idx_laporan_status_tanggal ON laporan(status, tanggal_lapor);

EXPLAIN
SELECT f.nama_fasilitas, COUNT(*) AS jumlah
FROM laporan l
JOIN fasilitas f ON f.id_fasilitas = l.id_fasilitas
WHERE l.tanggal_lapor >= '2026-10-01'
  AND l.tanggal_lapor <  '2026-11-01'
  AND l.status = 'Menunggu'
GROUP BY f.nama_fasilitas;

-- (Opsional) contoh index TIDAK terpakai: fungsi pada kolom membuat index tak bisa dipakai
EXPLAIN
SELECT COUNT(*) FROM laporan
WHERE YEAR(tanggal_lapor) = 2026 AND MONTH(tanggal_lapor) = 10;


-- =====================================================================
-- TAHAP 6: BACKUP & RESTORE
-- =====================================================================
-- Jalankan di terminal / command prompt (BUKAN di dalam MySQL client):
--
--   Backup (MySQL)  :  mysqldump -u root -p campus_facility_report > backup_modul10.sql
--   Backup (MariaDB):  mariadb-dump -u root -p campus_facility_report > backup_modul10.sql
--
--   Buat database tujuan kosong:
--   mysql -u root -p -e "CREATE DATABASE campus_facility_report_restore CHARACTER SET utf8mb4"
--
--   Restore (MySQL)  :  mysql -u root -p campus_facility_report_restore < backup_modul10.sql
--   Restore (MariaDB):  mariadb -u root -p campus_facility_report_restore < backup_modul10.sql
--
-- Validasi hasil restore (jalankan di MySQL client):
USE campus_facility_report_restore;
SHOW TABLES;
SELECT COUNT(*) FROM user;
SELECT COUNT(*) FROM petugas;
SELECT COUNT(*) FROM fasilitas;
SELECT COUNT(*) FROM kategori_kerusakan;
SELECT COUNT(*) FROM laporan;
SELECT COUNT(*) FROM penanganan;
-- Bandingkan dengan database asli:
USE campus_facility_report;
SELECT COUNT(*) FROM laporan;
SELECT COUNT(*) FROM penanganan;
