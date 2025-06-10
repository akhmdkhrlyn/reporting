const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors'); // Tambahkan CORS
const bcrypt = require('bcrypt'); // Tambahkan bcrypt untuk hashing
const db = require('./database');
const app = express();
const port = 3000;

app.use(cors()); // Gunakan CORS
app.use(bodyParser.json());

// --- AUTHENTICATION ENDPOINTS ---

// Endpoint untuk registrasi user baru
app.post('/register', async (req, res) => {
  const { username, email, password } = req.body;
  if (!username || !email || !password) {
    return res.status(400).json({ error: "Username, email, and password are required." });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const sql = 'INSERT INTO users (username, email, password) VALUES (?, ?, ?)';
    db.run(sql, [username, email, hashedPassword], function (err) {
      if (err) {
        res.status(400).json({ error: err.message });
        return;
      }
      res.status(201).json({ id: this.lastID });
    });
  } catch (error) {
    res.status(500).json({ error: "Server error while hashing password." });
  }
});

// Endpoint untuk login user
app.post('/login', (req, res) => {
  const { email, password } = req.body;
   if (!email || !password) {
    return res.status(400).json({ error: "Email and password are required." });
  }

  const sql = 'SELECT * FROM users WHERE email = ?';
  db.get(sql, [email], async (err, user) => {
    if (err) {
      return res.status(400).json({ error: err.message });
    }
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }

    res.json({ message: 'Login successful', user: { id: user.id, username: user.username, email: user.email } });
  });
});


// --- TASK ENDPOINTS ---

// Get all tasks
app.get('/tasks', (req, res) => {
  db.all('SELECT * FROM tasks', [], (err, rows) => {
    if (err) {
      res.status(400).json({ error: err.message });
      return;
    }
    res.json(rows);
  });
});

// Add a new task
app.post('/tasks', (req, res) => {
  const { id, title, time, date, status, type } = req.body;
  db.run(
    'INSERT INTO tasks (id, title, time, date, status, type) VALUES (?, ?, ?, ?, ?, ?)',
    [id, title, time, date, status, type],
    function (err) {
      if (err) {
        res.status(400).json({ error: err.message });
        return;
      }
      res.status(201).json({ id: this.lastID });
    }
  );
});

// Update an existing task
app.put('/tasks/:id', (req, res) => {
  const { title, status } = req.body;
  const { id } = req.params;
  db.run(
    'UPDATE tasks SET title = ?, status = ? WHERE id = ?',
    [title, status, id],
    function (err) {
      if (err) {
        res.status(400).json({ "error": err.message });
        return;
      }
      res.json({ updated: this.changes });
    }
  );
});

// Delete a task
app.delete('/tasks/:id', (req, res) => {
    const { id } = req.params;
    db.run(
        'DELETE FROM tasks WHERE id = ?',
        id,
        function (err) {
            if (err) {
                res.status(400).json({ "error": err.message });
                return;
            }
            res.json({ deleted: this.changes });
        }
    );
});


app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});