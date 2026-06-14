const db = require('../db');

const getDoctors = async (req, res) => {
  try {
    const { disease, treatment_type } = req.query;

    let query = `
      SELECT d.*, u.name, u.email 
      FROM doctors d
      JOIN users u ON d.user_id = u.id
      WHERE u.role = 'Doctor'
    `;
    const params = [];
    let paramIndex = 1;

    if (disease) {
      query += ` AND (d.specialization ILIKE $${paramIndex} OR d.about ILIKE $${paramIndex+1})`;
      params.push(`%${disease}%`, `%${disease}%`);
      paramIndex += 2;
    }

    if (treatment_type) {
      query += ` AND d.treatment_type = $${paramIndex}`;
      params.push(treatment_type);
      paramIndex += 1;
    }

    const { rows: doctors } = await db.query(query, params);
    res.json(doctors);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

const getDoctorSchedule = async (req, res) => {
  try {
    const { doctorId } = req.params;

    const { rows: clinics } = await db.query('SELECT * FROM clinics WHERE doctor_id = $1', [doctorId]);
    
    const { rows: appointments } = await db.query('SELECT date, time, status FROM appointments WHERE doctor_id = $1 AND status != \'Cancelled\'', [doctorId]);

    res.json({ clinics, booked_appointments: appointments });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

const addClinic = async (req, res) => {
  try {
    const { clinic_name, address, start_time, end_time } = req.body;

    const { rows: dRows } = await db.query('SELECT * FROM doctors WHERE user_id = $1', [req.user.id]);
    const doctor = dRows[0];
    if (!doctor) return res.status(404).json({ message: 'Doctor profile not found' });

    await db.query(
      'INSERT INTO clinics (doctor_id, clinic_name, address, start_time, end_time) VALUES ($1, $2, $3, $4, $5)',
      [doctor.id, clinic_name, address, start_time, end_time]
    );

    res.status(201).json({ message: 'Clinic availability added successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = { getDoctors, getDoctorSchedule, addClinic };
