// Membuat user dan memheri hak akses hany  a baca (ro= read-only)
const users = require("@arangodb/users");
users save("report.user". "<PASSWORD_KUAT>", true);
users grantDatabase("report_user", "transport_db", "ro");

ers grantCollection("report_user", "transport_db", "trips", "ro");

// Memeriksa status hak akses user
users.permission("report_user", "transport_db", "trips");

// Mencabut hak akses (revoke menjadi none) users.grantDatabase("report_user","transpart_db", "none"); users.grantCollection("report_user","transport_db","trips", "none");
