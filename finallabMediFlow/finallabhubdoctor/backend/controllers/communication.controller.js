const db = require('../db');

const sendMessage = async (req, res) => {
  try {
    const { receiver_id, content } = req.body;
    const sender_id = req.user.id;

    const { rows: result } = await db.query(
      'INSERT INTO messages (sender_id, receiver_id, content) VALUES ($1, $2, $3) RETURNING *',
      [sender_id, receiver_id, content]
    );

    const messageRecord = result[0];

    const io = req.app.get('io');
    const connectedUsers = req.app.get('connectedUsers');
    const receiverSocketId = connectedUsers.get(Number(receiver_id));
    if (receiverSocketId && io) {
      io.to(receiverSocketId).emit('new_message', messageRecord);
    }

    res.status(201).json({ message: 'Message sent successfully', data: messageRecord });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

const getMessages = async (req, res) => {
  try {
    const { userId } = req.params;
    const currentUserId = req.user.id;

    const { rows: messages } = await db.query(
      `SELECT * FROM messages 
       WHERE (sender_id = $1 AND receiver_id = $2) 
          OR (sender_id = $3 AND receiver_id = $4)
       ORDER BY created_at ASC`,
      [currentUserId, userId, userId, currentUserId]
    );

    res.json(messages);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = { sendMessage, getMessages };
