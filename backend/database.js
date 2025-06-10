const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database(':memory:');

db.serialize(() => {
  db.run(`
    CREATE TABLE tasks (
      id TEXT PRIMARY KEY,
      title TEXT,
      time TEXT,
      date TEXT,
      status TEXT,
      type TEXT
    )
  `);
});

module.exports = db;