const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../db');

const register = async (req, res) => {
  try {
    const { name, email, password, role, ...additionalData } = req.body;

    // Check if user exists
    const { rows: existingRows } = await db.query('SELECT * FROM users WHERE email = $1', [email]);
    if (existingRows.length > 0) {
      return res.status(400).json({ message: 'User already exists' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const { rows: result } = await db.query(
      'INSERT INTO users (name, email, password, role) VALUES ($1, $2, $3, $4) RETURNING id',
      [name, email, hashedPassword, role]
    );

    const userId = result[0].id;

    // Handle role specific tables
    if (role === 'Doctor') {
      await db.query(
        'INSERT INTO doctors (user_id, specialization, treatment_type, fee) VALUES ($1, $2, $3, $4)',
        [userId, additionalData.specialization || '', additionalData.treatment_type || 'Allopathic', additionalData.fee || 0]
      );
    } else if (role === 'Patient') {
      await db.query(
        'INSERT INTO patients (user_id, date_of_birth, blood_group) VALUES ($1, $2, $3)',
        [userId, additionalData.date_of_birth || null, additionalData.blood_group || '']
      );
    } else if (role === 'Assistant') {
      await db.query(
        'INSERT INTO assistants (user_id, assigned_admin_id) VALUES ($1, $2)',
        [userId, additionalData.assigned_admin_id || null]
      );
    }

    res.status(201).json({ message: 'User registered successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error during registration' });
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const { rows: uRows } = await db.query('SELECT * FROM users WHERE email = $1', [email]);
    if (uRows.length === 0) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }
    const user = uRows[0];

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign(
      { id: user.id, role: user.role },
      process.env.JWT_SECRET || 'secret_key',
      { expiresIn: '1d' }
    );

    let userResponse = {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role
    };

    if (user.role === 'Patient') {
      const { rows: pRows } = await db.query('SELECT * FROM patients WHERE user_id = $1', [user.id]);
      const patientData = pRows[0];
      if (patientData) {
        userResponse = {
          ...userResponse,
          patient_id: patientData.id,
          date_of_birth: patientData.date_of_birth,
          blood_group: patientData.blood_group
        };
      }
    } else if (user.role === 'Doctor') {
      const { rows: dRows } = await db.query('SELECT * FROM doctors WHERE user_id = $1', [user.id]);
      const doctorData = dRows[0];
      if (doctorData) {
        userResponse = {
          ...userResponse,
          doctor_id: doctorData.id,
          specialization: doctorData.specialization,
          treatment_type: doctorData.treatment_type,
          about: doctorData.about,
          fee: doctorData.fee
        };
      }
    }

    res.json({
      token,
      user: userResponse
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error during login' });
  }
};

const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    const { rows: uRows } = await db.query('SELECT * FROM users WHERE email = $1', [email]);
    const user = uRows[0];

    if (!user) {
      return res.json({ message: 'If that email is registered, we have sent a reset link.' });
    }

    const resetToken = Math.random().toString(36).substring(2, 12);
    await db.query('UPDATE users SET reset_token = $1 WHERE id = $2', [resetToken, user.id]);

    res.json({ message: 'Password reset token generated. Use the token to reset your password.', resetToken });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = { register, login, forgotPassword };
