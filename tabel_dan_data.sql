CREATE DATABASE campus_facility_report;
USE campus_facility_report;

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

-- Data contoh
INSERT INTO user (nama, nomor_induk, kategori_pengguna) VALUES
 ('Adam','264311060','Mahasiswa'),('Iltizam','264311071','Mahasiswa');
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
