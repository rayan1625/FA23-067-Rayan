const db = require('../db');

const addMetric = async (req, res) => {
  try {
    const { bp_systolic, bp_diastolic, heart_rate, weight_kg } = req.body;

    const { rows: pRows } = await db.query('SELECT * FROM patients WHERE user_id = $1', [req.user.id]);
    const patient = pRows[0];
    if (!patient) return res.status(404).json({ message: 'Patient profile not found' });

    await db.query(
      'INSERT INTO health_metrics (patient_id, bp_systolic, bp_diastolic, heart_rate, weight_kg) VALUES ($1, $2, $3, $4, $5)',
      [patient.id, bp_systolic, bp_diastolic, heart_rate, weight_kg]
    );

    res.status(201).json({ message: 'Health metric added successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

const getMetrics = async (req, res) => {
  try {
    const { rows: pRows } = await db.query('SELECT * FROM patients WHERE user_id = $1', [req.user.id]);
    const patient = pRows[0];
    if (!patient) return res.status(404).json({ message: 'Patient profile not found' });

    const { rows: metrics } = await db.query(
      'SELECT * FROM health_metrics WHERE patient_id = $1 ORDER BY recorded_at ASC',
      [patient.id]
    );

    res.json(metrics);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = { addMetric, getMetrics };
