// Script query AQL dan pengujian indeks pada transport_db (arangosh)
db._useDatabase("transport_db");

const query = `
  FOR t IN trips
    FILTER t.route_id == 12 AND t.started_at >= "2026-11-01"
    FOR r IN routes
      FILTER t.route_id == r.route_id
      RETURN {
        trip_id: t.trip_id,
        started_at: t.started_at,
        route_name: r.route_name
      }
`;

// 1. Eksekusi query utama
print("=== Hasil Query Transportasi ===");
print(db._query(query).toArray());

// 2. Explain sebelum penambahan Persistent Index
print("=== Explain Sebelum Index ===");
print(db._explain(query));

// 3. Pembuatan Composite Persistent Index pada trips
db.trips.ensureIndex({
  type: "persistent",
  fields: ["route_id", "started_at"]
});

// 4. Explain sesudah penambahan Persistent Index
print("=== Explain Sesudah Index ===");
print(db._explain(query));
