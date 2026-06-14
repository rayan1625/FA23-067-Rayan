const db = require('../db');

const getUsers = async (req, res) => {
  try {
    const { rows: users } = await db.query(`
      SELECT u.id, u.name, u.email, u.role, u.created_at,
        d.specialization, d.treatment_type, p.blood_group, a.assigned_admin_id
      FROM users u
      LEFT JOIN doctors d ON d.user_id = u.id
      LEFT JOIN patients p ON p.user_id = u.id
      LEFT JOIN assistants a ON a.user_id = u.id
      ORDER BY u.created_at DESC
    `);
    res.json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

const updateUserRole = async (req, res) => {
  try {
    const { id } = req.params;
    const { role } = req.body;

    const allowedRoles = ['Patient', 'Doctor', 'Assistant', 'Admin', 'Super Admin'];
    if (!allowedRoles.includes(role)) {
      return res.status(400).json({ message: 'Invalid role' });
    }

    await db.query('UPDATE users SET role = $1 WHERE id = $2', [role, id]);
    res.json({ message: 'User role updated successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = { getUsers, updateUserRole };