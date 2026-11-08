SELECT
    f.id_fasilitas,
    f.nama_fasilitas,
    COUNT(l.id_laporan) AS total_laporan,
    SUM(
        CASE
            WHEN k.nama_kategori = 'Berat' THEN 1
            ELSE 0
        END
    ) AS total_berat
FROM fasilitas AS f
JOIN laporan AS l
    ON l.id_fasilitas = f.id_fasilitas
JOIN kategori_kerusakan AS k
    ON k.id_kategori = l.id_kategori
GROUP BY
    f.id_fasilitas,
    f.nama_fasilitas
ORDER BY total_laporan DESC;
