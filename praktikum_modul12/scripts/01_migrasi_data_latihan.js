// Script migrasi database transport_db pada ArangoDB (arangosh)
db._useDatabase("_system");

if (!db._databases().includes("transport_db")) {
  db._createDatabase("transport_db");
}
db._useDatabase("transport_db");

if (!db._collection("routes")) {
  db._create("routes");
}
if (!db._collection("trips")) {
  db._create("trips");
}

// Insert data collection routes
db.routes.save([
  { _key: "R12", route_id: 12, route_name: "Koridor Pusat-Terminal" },
  { _key: "R15", route_id: 15, route_name: "Koridor Kampus-Stasiun" },
  { _key: "R18", route_id: 18, route_name: "Koridor Pasar-Kota" }
], { overwriteMode: "replace" });

// Insert data collection trips
db.trips.save([
  { _key: "T001", trip_id: "T001", route_id: 12, started_at: "2026-11-02 07:10", duration_min: 35 },
  { _key: "T002", trip_id: "T002", route_id: 15, started_at: "2026-11-02 07:45", duration_min: 28 },
  { _key: "T003", trip_id: "T003", route_id: 12, started_at: "2026-11-03 08:05", duration_min: 40 },
  { _key: "T004", trip_id: "T004", route_id: 18, started_at: "2026-10-30 16:30", duration_min: 25 },
  { _key: "T005", trip_id: "T005", route_id: 12, started_at: "2026-11-05 17:20", duration_min: 42 },
  { _key: "T006", trip_id: "T006", route_id: 15, started_at: "2026-11-06 09:15", duration_min: 30 }
], { overwriteMode: "replace" });

print("Migrasi data transport_db selesai.");
