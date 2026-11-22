// Rancangan struktur dan indeks migrasi PjBL campus_facility_report ke ArangoDB
db._useDatabase("_system");

if (!db._databases().includes("campus_facility_report")) {
  db._createDatabase("campus_facility_report");
}
db._useDatabase("campus_facility_report");

// Pembuatan collections utama
["users", "petugas", "fasilitas", "laporan"].forEach((col) => {
  if (!db._collection(col)) {
    db._create(col);
  }
});

// Contoh dokumen fasilitas dengan nested object spesifikasi (pengganti kolom JSON MySQL)
db.fasilitas.save({
  _key: "F001",
  id_fasilitas: 1,
  nama_fasilitas: "Lab Komputer 1",
  jenis_fasilitas: "Laboratorium",
  lokasi: "Gedung C Lantai 2",
  spesifikasi: {
    jumlah_pc: 45,
    ram: "16GB",
    prosesor: "Intel Core i5",
    software: ["VS Code", "MySQL", "XAMPP"]
  }
}, { overwriteMode: "replace" });

// Contoh dokumen laporan dengan embedded kategori & riwayat penanganan
db.laporan.save({
  _key: "L001",
  id_laporan: 1,
  id_user: "U001",
  id_fasilitas: "F001",
  kategori: {
    nama_kategori: "Sedang",
    deskripsi: "Perbaikan komponen atau perangkat"
  },
  lokasi_detail: "Meja PC 12",
  deskripsi: "Monitor tidak menyala",
  tanggal_lapor: "2026-11-20 09:00:00",
  status: "Diproses",
  penanganan: [
    {
      id_petugas: "P001",
      tanggal_penugasan: "2026-11-20 10:00:00",
      tanggal_selesai: null,
      catatan: "Pengecekan kabel power"
    }
  ]
}, { overwriteMode: "replace" });

// Indeks untuk optimasi query filter status dan pencarian per fasilitas
db.laporan.ensureIndex({ type: "persistent", fields: ["status", "tanggal_lapor"] });
db.laporan.ensureIndex({ type: "persistent", fields: ["id_fasilitas"] });

print("Inisialisasi rancangan PjBL campus_facility_report selesai.");
