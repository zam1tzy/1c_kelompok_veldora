// 1. Migrasi data ke collection

routes FOR r IN [

{_key: "12", route_id: 12, route_name; "Koridor Pusat-Terminal" },

{_key: "15", route_id: 15, route_name; "Koridor Kampus-Stasiun" },

{_key: "18", route_id: 18, route_name; "Koridor Pasar-Kota" }
]
INSERT r INTO routes

// 2. Migrasi data ke collection
trips FOR t IN [

{_key: "T001", trip_id: "T001", route_id: 12, started_at: "2026-11-02 07:10", status: "completed" },

{_key: "T002", trip_id: "T002", route_id: 15, started_at: "2026-11-02 07:25", status: "completed" },

{_key: "T003", trip_id: "T003", route_id: 12, started_at: "2026-11-03 08:05", status: "delayed" },

{_key: "T004", trip_id: "T004", route_id: 18, started_at: "2026-10-29 06:50", status: "completed" },

{_key: "T005", trip_id: "T005", route_id: 12, started_at: "2026-11-05 17:20", status: "completed" },

{_key: "T006", trip_id: "T006", route_id: 15, started_at: "2026-11-06 09:15", status: "cancelled" }
