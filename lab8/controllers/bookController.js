const pool = require('../db');

// CREATE - เพิ่มข้อมูล
exports.createBook = async (req, res) => {
  try {
    const { title, author, published_year } = req.body;
    const result = await pool.query(
      'INSERT INTO books (title, author, published_year) VALUES ($1, $2, $3) RETURNING *',
      [title, author, published_year]
    );
    res.status(201).json(result.rows[0]); // 201 Created
  } catch (err) {
    res.status(500).json({ error: err.message }); // 500 Server Error
  }
};

// READ - ดูทั้งหมด
exports.getBooks = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM books');
    res.status(200).json(result.rows); // 200 OK
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// READ - ดูตาม id
exports.getBookById = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM books WHERE id = $1', [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Book not found' }); // 404 Not Found
    }

    res.status(200).json(result.rows[0]); // 200 OK
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// UPDATE - แก้ไข
exports.updateBook = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, author, published_year } = req.body;

    const result = await pool.query(
      'UPDATE books SET title=$1, author=$2, published_year=$3 WHERE id=$4 RETURNING *',
      [title, author, published_year, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Book not found' });
    }

    res.status(200).json(result.rows[0]); // 200 OK
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// DELETE - ลบ
exports.deleteBook = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM books WHERE id = $1 RETURNING *', [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Book not found' });
    }

    res.sendStatus(204); // 204 No Content
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
