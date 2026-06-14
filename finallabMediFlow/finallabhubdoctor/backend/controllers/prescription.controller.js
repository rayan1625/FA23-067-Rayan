const db = require('../db');

const addPrescription = async (req, res) => {
  try {
    const { appointment_id, patient_id, medicines, notes } = req.body;

    const { rows: dRows } = await db.query('SELECT * FROM doctors WHERE user_id = $1', [req.user.id]);
    const doctor = dRows[0];
    if (!doctor) return res.status(404).json({ message: 'Doctor profile not found' });

    // Validate appointment belongs to doctor
    const { rows: apptRows } = await db.query('SELECT * FROM appointments WHERE id = $1 AND doctor_id = $2', [appointment_id, doctor.id]);
    const appointment = apptRows[0];
    if (!appointment) return res.status(400).json({ message: 'Invalid appointment' });

    await db.query(
      'INSERT INTO prescriptions (appointment_id, doctor_id, patient_id, medicines, notes) VALUES ($1, $2, $3, $4, $5)',
      [appointment_id, doctor.id, patient_id, medicines, notes || null]
    );

    // Also add to medical history automatically
    await db.query(
      'INSERT INTO medical_history (patient_id, doctor_id, record_text) VALUES ($1, $2, $3)',
      [patient_id, doctor.id, `Prescription added: ${medicines}. Notes: ${notes || ''}`]
    );

    await db.query('UPDATE appointments SET status = $1 WHERE id = $2', ['Completed', appointment_id]);

    res.status(201).json({ message: 'Prescription added successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

const getPrescriptions = async (req, res) => {
  try {
    let query = '';
    let params = [];

    if (req.user.role === 'Patient') {
      const { rows: pRows } = await db.query('SELECT * FROM patients WHERE user_id = $1', [req.user.id]);
      if(pRows.length === 0) return res.json([]);
      const patient = pRows[0];
      query = `
        SELECT p.*, d.specialization, u.name as doctor_name
        FROM prescriptions p
        JOIN doctors d ON p.doctor_id = d.id
        JOIN users u ON d.user_id = u.id
        WHERE p.patient_id = $1
        ORDER BY p.created_at DESC
      `;
      params = [patient.id];
    } else if (req.user.role === 'Doctor') {
      const { rows: dRows } = await db.query('SELECT * FROM doctors WHERE user_id = $1', [req.user.id]);
      if(dRows.length === 0) return res.json([]);
      const doctor = dRows[0];
      query = `
        SELECT p.*, pa.blood_group, u.name as patient_name
        FROM prescriptions p
        JOIN patients pa ON p.patient_id = pa.id
        JOIN users u ON pa.user_id = u.id
        WHERE p.doctor_id = $1
        ORDER BY p.created_at DESC
      `;
      params = [doctor.id];
    }

    const { rows: prescriptions } = await db.query(query, params);
    res.json(prescriptions);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = { addPrescription, getPrescriptions };
