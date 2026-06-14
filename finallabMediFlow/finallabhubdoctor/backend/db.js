const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');
const bcrypt = require('bcrypt');
require('dotenv').config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL
});

async function setupDatabase() {
  const client = await pool.connect();
  try {
    const schemaSql = fs.readFileSync(path.join(__dirname, 'schema.sql'), 'utf8');
    await client.query(schemaSql);
    
    // Create default super admin
    const res = await client.query('SELECT * FROM users WHERE email = $1', ['superadmin@mediflow.com']);
    if (res.rows.length === 0) {
      const hashedPassword = await bcrypt.hash('superadmin123', 10);
      await client.query(
        'INSERT INTO users (name, email, password, role) VALUES ($1, $2, $3, $4)',
        ['Super Admin', 'superadmin@mediflow.com', hashedPassword, 'Super Admin']
      );
      console.log('Super Admin created: superadmin@mediflow.com / superadmin123');
    }
  } finally {
    client.release();
  }
}

module.exports = {
  query: (text, params) => pool.query(text, params),
  setupDatabase,
  pool
};
