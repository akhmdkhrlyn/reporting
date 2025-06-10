const sqlite3 = require('sqlite3').verbose();
// Menggunakan file database agar data tidak hilang saat server mati
const db = new sqlite3.Database('reporting.db');

db.serialize(() => {
  // Membuat tabel tasks jika belum ada
  db.run(`
    CREATE TABLE IF NOT EXISTS tasks (
      id TEXT PRIMARY KEY,
      title TEXT,
      time TEXT,
      date TEXT,
      status TEXT,
      type TEXT
    )
  `);

  // Membuat tabel users untuk autentikasi jika belum ada
  db.run(`
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
    )
  `);
});

module.exports = db;