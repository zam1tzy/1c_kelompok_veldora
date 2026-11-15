-- ===== DATABASE =====
CREATE DATABASE IF NOT EXISTS campus_facility_report;
USE campus_facility_report;

-- ===== TABEL =====
CREATE TABLE user (
  id_user INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100), nomor_induk VARCHAR(20),
  kategori_pengguna ENUM('Mahasiswa','Dosen','Tendik'),
  email VARCHAR(100), password VARCHAR(255)
);
CREATE TABLE petugas (
  id_petugas INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100), jabatan ENUM('Teknisi','Pengelola Fasilitas'),
  email VARCHAR(100), password VARCHAR(255)
);
CREATE TABLE fasilitas (
  id_fasilitas INT AUTO_INCREMENT PRIMARY KEY,
  nama_fasilitas VARCHAR(100), jenis_fasilitas VARCHAR(50), lokasi VARCHAR(100)
);
CREATE TABLE kategori_kerusakan (
  id_kategori INT AUTO_INCREMENT PRIMARY KEY,
  nama_kategori ENUM('Ringan','Sedang','Berat'), deskripsi VARCHAR(200)
);
CREATE TABLE laporan (
  id_laporan INT AUTO_INCREMENT PRIMARY KEY,
  id_user INT, id_fasilitas INT, id_kategori INT,
  lokasi_detail VARCHAR(150), deskripsi TEXT, foto_bukti VARCHAR(255),
  tanggal_lapor DATE, status ENUM('Menunggu','Diproses','Selesai') DEFAULT 'Menunggu',
  FOREIGN KEY (id_user) REFERENCES user(id_user),
  FOREIGN KEY (id_fasilitas) REFERENCES fasilitas(id_fasilitas),
  FOREIGN KEY (id_kategori) REFERENCES kategori_kerusakan(id_kategori)
);
CREATE TABLE penanganan (
  id_penanganan INT AUTO_INCREMENT PRIMARY KEY,
  id_laporan INT, id_petugas INT,
  tanggal_penugasan DATE, tanggal_selesai DATE, catatan TEXT,
  FOREIGN KEY (id_laporan) REFERENCES laporan(id_laporan),
  FOREIGN KEY (id_petugas) REFERENCES petugas(id_petugas)
);

-- ===== DATA AWAL (DUMMY) =====
INSERT INTO user (nama, nomor_induk, kategori_pengguna) VALUES
 ('Mahasiswa A','0000001','Mahasiswa'),('Mahasiswa B','0000002','Mahasiswa');
INSERT INTO fasilitas (nama_fasilitas, jenis_fasilitas, lokasi) VALUES
 ('Toilet Gedung A','Toilet','Gedung A Lt.1'),
 ('WiFi Gedung B','Jaringan Internet','Gedung B'),
 ('Lab Komputer 1','Laboratorium Komputer','Gedung C');
INSERT INTO kategori_kerusakan (nama_kategori) VALUES ('Ringan'),('Sedang'),('Berat');
INSERT INTO laporan (id_user,id_fasilitas,id_kategori,lokasi_detail,deskripsi,tanggal_lapor,status) VALUES
 (1,1,3,'Bilik 2','Kran patah','2026-10-01','Menunggu'),
 (2,1,1,'Bilik 1','Lampu redup','2026-10-02','Diproses'),
 (1,2,2,'Lantai 2','WiFi putus-putus','2026-10-03','Selesai'),
 (2,1,3,'Bilik 3','Pintu rusak','2026-10-04','Menunggu'),
 (1,3,2,'Meja 5','Monitor mati','2026-10-05','Diproses');

-- ===== PENGUJIAN JSON =====
ALTER TABLE fasilitas ADD COLUMN spesifikasi JSON NULL;

UPDATE fasilitas SET spesifikasi = '{"jumlah_bilik":3,"jenis_kloset":"duduk","air_bersih":true}' WHERE id_fasilitas = 1;
UPDATE fasilitas SET spesifikasi = '{"ssid":"Campus-WiFi-B","jumlah_access_point":4,"bandwidth":"100 Mbps","frekuensi":["2.4GHz","5GHz"]}' WHERE id_fasilitas = 2;
UPDATE fasilitas SET spesifikasi = '{"jumlah_pc":40,"ram":"16GB","prosesor":"Intel Core i5","software":["VS Code","MySQL","XAMPP"]}' WHERE id_fasilitas = 3;

-- Baca
SELECT nama_fasilitas, JSON_EXTRACT(spesifikasi,'$.jumlah_bilik') AS jumlah_bilik FROM fasilitas WHERE id_fasilitas = 1;
SELECT nama_fasilitas, JSON_UNQUOTE(JSON_EXTRACT(spesifikasi,'$.ssid')) AS ssid FROM fasilitas WHERE id_fasilitas = 2;

-- Ubah, tambah, hapus atribut
UPDATE fasilitas SET spesifikasi = JSON_SET(spesifikasi,'$.jumlah_pc',45) WHERE nama_fasilitas = 'Lab Komputer 1';
UPDATE fasilitas SET spesifikasi = JSON_SET(spesifikasi,'$.tahun_pengadaan',2023) WHERE nama_fasilitas = 'Lab Komputer 1';
UPDATE fasilitas SET spesifikasi = JSON_REMOVE(spesifikasi,'$.tahun_pengadaan') WHERE nama_fasilitas = 'Lab Komputer 1';

-- Cari
SELECT nama_fasilitas FROM fasilitas WHERE JSON_UNQUOTE(JSON_EXTRACT(spesifikasi,'$.ram')) = '16GB';
SELECT nama_fasilitas FROM fasilitas WHERE JSON_CONTAINS(spesifikasi,'"MySQL"','$.software');
SELECT nama_fasilitas FROM fasilitas WHERE JSON_EXTRACT(spesifikasi,'$.jumlah_bilik') > 2;
