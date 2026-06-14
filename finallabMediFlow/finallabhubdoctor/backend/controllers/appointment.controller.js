const db = require('../db');

const createAppointment = async (req, res) => {
  try {
    const { doctor_id, date, time } = req.body;

    if (req.user.role !== 'Patient') {
      return res.status(403).json({ message: 'Only patients can book appointments' });
    }

    const { rows: patientRows } = await db.query('SELECT * FROM patients WHERE user_id = $1', [req.user.id]);
    const patient = patientRows[0];
    if (!patient) return res.status(404).json({ message: 'Patient profile not found' });

    const { rows: result } = await db.query(
      'INSERT INTO appointments (patient_id, doctor_id, date, time, status) VALUES ($1, $2, $3, $4, $5) RETURNING id',
      [patient.id, doctor_id, date, time, 'Pending']
    );

    res.status(201).json({ message: 'Appointment created successfully', appointmentId: result[0].id });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

const getAppointments = async (req, res) => {
  try {
    let query = '';
    let params = [];

    if (req.user.role === 'Patient') {
      const { rows: pRows } = await db.query('SELECT * FROM patients WHERE user_id = $1', [req.user.id]);
      if(pRows.length === 0) return res.json([]);
      const patient = pRows[0];
      query = `
        SELECT a.*, d.specialization, u.name as doctor_name, u.id as doctor_user_id
        FROM appointments a
        JOIN doctors d ON a.doctor_id = d.id
        JOIN users u ON d.user_id = u.id
        WHERE a.patient_id = $1
      `;
      params = [patient.id];
    } else if (req.user.role === 'Doctor') {
      const { rows: dRows } = await db.query('SELECT * FROM doctors WHERE user_id = $1', [req.user.id]);
      if(dRows.length === 0) return res.json([]);
      const doctor = dRows[0];
      query = `
        SELECT a.*, p.blood_group, u.name as patient_name, u.id as patient_user_id
        FROM appointments a
        JOIN patients p ON a.patient_id = p.id
        JOIN users u ON p.user_id = u.id
        WHERE a.doctor_id = $1
      `;
      params = [doctor.id];
    } else if (req.user.role === 'Assistant' || req.user.role === 'Admin' || req.user.role === 'Super Admin') {
      query = `
        SELECT a.*, p.blood_group, up.name as patient_name, ud.name as doctor_name
        FROM appointments a
        JOIN patients p ON a.patient_id = p.id
        JOIN users up ON p.user_id = up.id
        JOIN doctors d ON a.doctor_id = d.id
        JOIN users ud ON d.user_id = ud.id
      `;
    }

    const { rows: appointments } = await db.query(query, params);
    res.json(appointments);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

const verifyAppointment = async (req, res) => {
  try {
    const { id } = req.params;

    await db.query('UPDATE appointments SET status = $1, payment_verified = $2 WHERE id = $3', ['Confirmed', true, id]);
    
    // Log the verification
    await db.query('UPDATE payments SET verified_by_assistant = $1, verified_at = CURRENT_TIMESTAMP WHERE appointment_id = $2', [req.user.id, id]);

    res.json({ message: 'Appointment verified and confirmed' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

const rejectAppointment = async (req, res) => {
  try {
    const { id } = req.params;

    // Delete the payment associated with this appointment
    await db.query('DELETE FROM payments WHERE appointment_id = $1', [id]);

    res.json({ message: 'Payment rejected. Patient needs to re-upload.' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = { createAppointment, getAppointments, verifyAppointment, rejectAppointment };
