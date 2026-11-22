// Script pengujian DCL & Least Privilege pada ArangoDB (arangosh)
const users = require("@arangodb/users");

// 1. Membuat user baru dan memberi hak akses Read-Only (ro)
users.save("report_user", "<PASSWORD_KUAT>", true);
users.grantDatabase("report_user", "transport_db", "ro");
users.grantCollection("report_user", "transport_db", "routes", "ro");
users.grantCollection("report_user", "transport_db", "trips", "ro");

// 2. Memeriksa status hak akses user
print("Permission trips (awal):", users.permission("report_user", "transport_db", "trips"));

// 3. Mencabut hak akses collection trips (revoke menjadi none)
users.grantCollection("report_user", "transport_db", "trips", "none");
print("Permission trips (setelah revoke):", users.permission("report_user", "transport_db", "trips"));
