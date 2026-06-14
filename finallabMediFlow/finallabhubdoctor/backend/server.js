const express = require('express');
const cors = require('cors');
const path = require('path');
const http = require('http');
const { Server } = require('socket.io');
require('dotenv').config();
const { setupDatabase } = require('./db');

const authRoutes = require('./routes/auth.routes');
const doctorRoutes = require('./routes/doctor.routes');
const appointmentRoutes = require('./routes/appointment.routes');
const paymentRoutes = require('./routes/payment.routes');
const historyRoutes = require('./routes/history.routes');
const prescriptionRoutes = require('./routes/prescription.routes');
const communicationRoutes = require('./routes/communication.routes');
const adminRoutes = require('./routes/admin.routes');
const healthRoutes = require('./routes/health.routes');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
  }
});

const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

const connectedUsers = new Map();
app.set('io', io);
app.set('connectedUsers', connectedUsers);

io.on('connection', (socket) => {
  socket.on('register', (userId) => {
    connectedUsers.set(Number(userId), socket.id);
  });

  socket.on('disconnect', () => {
    for (const [userId, socketId] of connectedUsers.entries()) {
      if (socketId === socket.id) {
        connectedUsers.delete(userId);
        break;
      }
    }
  });
});

// Static folder for uploaded files
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/doctors', doctorRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/history', historyRoutes);
app.use('/api/prescriptions', prescriptionRoutes);
app.use('/api/communication', communicationRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/health', healthRoutes);

// Database initialization and server start
setupDatabase()
  .then(() => {
    server.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  })
  .catch(err => {
    console.error('Failed to start server:', err);
  });
