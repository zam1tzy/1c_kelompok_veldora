ALTER TABLE fasilitas
  ADD COLUMN total_laporan INT NOT NULL DEFAULT 0,
  ADD COLUMN total_berat   INT NOT NULL DEFAULT 0;
UPDATE fasilitas f
SET total_laporan = (SELECT COUNT(*) FROM laporan l WHERE l.id_fasilitas = f.id_fasilitas),
    total_berat   = (SELECT COUNT(*) FROM laporan l
                     JOIN kategori_kerusakan k ON k.id_kategori = l.id_kategori
                     WHERE l.id_fasilitas = f.id_fasilitas AND k.nama_kategori = 'Berat');
