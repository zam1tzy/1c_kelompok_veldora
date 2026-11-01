ata contoh
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
 (1,3,2,'Meja 5','Monitor mati','2026-10-05','Diproses')
