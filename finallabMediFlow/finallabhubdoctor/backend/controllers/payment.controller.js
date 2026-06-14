const db = require('../db');

const uploadPayment = async (req, res) => {
  try {
    const { appointment_id } = req.body;

    if (!req.file) {
      return res.status(400).json({ message: 'Please upload a screenshot' });
    }

    const screenshot_url = `/uploads/${req.file.filename}`;

    await db.query(
      'INSERT INTO payments (appointment_id, screenshot_url) VALUES ($1, $2)',
      [appointment_id, screenshot_url]
    );

    res.status(201).json({ message: 'Payment screenshot uploaded successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

const getPendingPayments = async (req, res) => {
  try {
    const { rows: payments } = await db.query(`
      SELECT p.*, a.date, a.time, pa.blood_group, u.name as patient_name
      FROM payments p
      JOIN appointments a ON p.appointment_id = a.id
      JOIN patients pa ON a.patient_id = pa.id
      JOIN users u ON pa.user_id = u.id
      WHERE p.verified_by_assistant IS NULL AND a.status = 'Pending'
    `);

    res.json(payments);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

const onlinePayment = async (req, res) => {
  try {
    const { appointment_id } = req.body;
    
    // Confirm instantly
    await db.query('UPDATE appointments SET status = $1, payment_verified = $2 WHERE id = $3', ['Confirmed', true, appointment_id]);
    
    // Insert dummy record to satisfy references if any
    await db.query(
      'INSERT INTO payments (appointment_id, screenshot_url, verified_by_assistant, verified_at) VALUES ($1, $2, $3, CURRENT_TIMESTAMP)',
      [appointment_id, 'online_payment', req.user.id]
    );

    res.status(201).json({ message: 'Online payment successful. Appointment confirmed instantly!' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = { uploadPayment, getPendingPayments, onlinePayment };
