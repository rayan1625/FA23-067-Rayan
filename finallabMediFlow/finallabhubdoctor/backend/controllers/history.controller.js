const db = require('../db');

const getHistory = async (req, res) => {
  try {
    let query = '';
    let params = [];

    if (req.user.role === 'Patient') {
      const { rows: pRows } = await db.query('SELECT * FROM patients WHERE user_id = $1', [req.user.id]);
      if(pRows.length === 0) return res.json([]);
      const patient = pRows[0];
      query = `
        SELECT h.*, d.specialization, d.treatment_type, u.name as doctor_name
        FROM medical_history h
        JOIN doctors d ON h.doctor_id = d.id
        JOIN users u ON d.user_id = u.id
        WHERE h.patient_id = $1
        ORDER BY h.created_at DESC
      `;
      params = [patient.id];
    } else if (req.user.role === 'Doctor') {
      const { rows: dRows } = await db.query('SELECT * FROM doctors WHERE user_id = $1', [req.user.id]);
      if(dRows.length === 0) return res.json([]);
      const doctor = dRows[0];
      
      const { patient_id } = req.query;
      if (!patient_id) return res.status(400).json({ message: 'Patient ID required' });
      
      query = `
        SELECT h.*, d.specialization, d.treatment_type, u.name as doctor_name
        FROM medical_history h
        JOIN doctors d ON h.doctor_id = d.id
        JOIN users u ON d.user_id = u.id
        WHERE h.patient_id = $1
        ORDER BY h.created_at DESC
      `;
      params = [patient_id];
    }

    const { rows: history } = await db.query(query, params);
    res.json(history);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

const addHistory = async (req, res) => {
  try {
    const { patient_id, record_text, file_url } = req.body;

    const { rows: dRows } = await db.query('SELECT * FROM doctors WHERE user_id = $1', [req.user.id]);
    const doctor = dRows[0];
    if (!doctor) return res.status(404).json({ message: 'Doctor profile not found' });

    await db.query(
      'INSERT INTO medical_history (patient_id, doctor_id, record_text, file_url) VALUES ($1, $2, $3, $4)',
      [patient_id, doctor.id, record_text, file_url || null]
    );

    res.status(201).json({ message: 'Medical history record added successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = { getHistory, addHistory };
