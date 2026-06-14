import React, { useState, useEffect } from 'react';
import { useAuth } from '../../context/AuthContext';
import api from '../../lib/api';
import { Search, Calendar, FileText, Upload, MessageSquare } from 'lucide-react';

const PatientDashboard = () => {
  const { user, logout } = useAuth();
  const [doctors, setDoctors] = useState<any[]>([]);
  const [appointments, setAppointments] = useState<any[]>([]);
  const [history, setHistory] = useState<any[]>([]);
  const [messages, setMessages] = useState<any[]>([]);

  // Filters
  const [diseaseFilter, setDiseaseFilter] = useState('');
  const [treatmentFilter, setTreatmentFilter] = useState('');

  // Booking state
  const [selectedDoctor, setSelectedDoctor] = useState<any>(null);
  const [date, setDate] = useState('');
  const [time, setTime] = useState('');

  // Messaging state
  const [chatDoctor, setChatDoctor] = useState<any>(null);
  const [chatText, setChatText] = useState('');

  // Payment upload state
  const [paymentFile, setPaymentFile] = useState<File | null>(null);
  const [paymentApptId, setPaymentApptId] = useState<number | null>(null);

  useEffect(() => {
    fetchDoctors();
    fetchAppointments();
    fetchHistory();
  }, [diseaseFilter, treatmentFilter]);

  const fetchDoctors = async () => {
    try {
      let url = '/doctors?';
      if (diseaseFilter) url += `disease=${diseaseFilter}&`;
      if (treatmentFilter) url += `treatment_type=${treatmentFilter}`;
      const { data } = await api.get(url);
      setDoctors(data);
    } catch (err) {
      console.error(err);
    }
  };

  const fetchAppointments = async () => {
    try {
      const { data } = await api.get('/appointments');
      setAppointments(data);
    } catch (err) {
      console.error(err);
    }
  };

  const fetchHistory = async () => {
    try {
      const { data } = await api.get('/history');
      setHistory(data);
    } catch (err) {
      console.error(err);
    }
  };

  const fetchMessages = async (doctorUserId: number) => {
    try {
      const { data } = await api.get(`/communication/messages/${doctorUserId}`);
      setMessages(data);
    } catch (err) {
      console.error(err);
    }
  };

  const startChat = (doctor: any) => {
    setChatDoctor(doctor);
    setChatText('');
    fetchMessages(doctor.id);
  };

  const sendMessage = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!chatDoctor || !chatText.trim()) return;

    try {
      await api.post('/communication/message', {
        receiver_id: chatDoctor.id,
        content: chatText
      });
      setChatText('');
      fetchMessages(chatDoctor.id);
    } catch (err) {
      console.error(err);
      alert('Failed to send message.');
    }
  };

  const handleBook = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await api.post('/appointments', {
        doctor_id: selectedDoctor.id,
        date,
        time
      });
      setSelectedDoctor(null);
      setDate('');
      setTime('');
      fetchAppointments();
      alert('Appointment booked successfully. Please upload payment.');
    } catch (err) {
      console.error(err);
      alert('Failed to book appointment.');
    }
  };

  const handleUploadPayment = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!paymentFile || !paymentApptId) return;
    
    const formData = new FormData();
    formData.append('appointment_id', paymentApptId.toString());
    formData.append('screenshot', paymentFile);

    try {
      await api.post('/payments', formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });
      setPaymentFile(null);
      setPaymentApptId(null);
      alert('Payment uploaded successfully. Pending verification.');
      fetchAppointments();
    } catch (err) {
      console.error(err);
      alert('Failed to upload payment.');
    }
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-white shadow-sm px-6 py-4 flex justify-between items-center">
        <h1 className="text-xl font-bold text-blue-600">Doctor Hub - Patient</h1>
        <div className="flex items-center space-x-4">
          <span className="text-gray-600">Welcome, {user?.name}</span>
          <button onClick={logout} className="text-red-500 hover:text-red-700">Logout</button>
        </div>
      </nav>

      <div className="max-w-7xl mx-auto px-4 py-8 grid grid-cols-1 md:grid-cols-3 gap-8">
        
        {/* Doctors List */}
        <div className="md:col-span-2 space-y-6">
          <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
            <h2 className="text-lg font-bold mb-4 flex items-center"><Search className="mr-2"/> Find a Doctor</h2>
            <div className="flex gap-4 mb-6">
              <input 
                type="text" 
                placeholder="Search by disease/specialization..." 
                className="flex-1 px-3 py-2 border rounded-md"
                value={diseaseFilter}
                onChange={(e) => setDiseaseFilter(e.target.value)}
              />
              <select 
                className="px-3 py-2 border rounded-md"
                value={treatmentFilter}
                onChange={(e) => setTreatmentFilter(e.target.value)}
              >
                <option value="">All Types</option>
                <option value="Allopathic">Allopathic</option>
                <option value="Homeopathic">Homeopathic</option>
                <option value="Herbal">Herbal</option>
              </select>
            </div>

            <div className="space-y-4">
              {doctors.map(doc => (
                <div key={doc.id} className="flex justify-between items-center p-4 border rounded-lg hover:shadow-md transition">
                  <div>
                    <h3 className="font-semibold text-lg">{doc.name}</h3>
                    <p className="text-gray-500 text-sm">{doc.specialization} • {doc.treatment_type}</p>
                    <p className="text-blue-600 font-medium mt-1">Fee: ${doc.fee}</p>
                  </div>
                  <div className="flex flex-col gap-2">
                <button 
                  onClick={() => setSelectedDoctor(doc)}
                  className="bg-blue-50 text-blue-600 px-4 py-2 rounded-md hover:bg-blue-100"
                >
                  Book Now
                </button>
                <button
                  onClick={() => startChat(doc)}
                  className="bg-gray-50 text-gray-700 px-4 py-2 rounded-md hover:bg-gray-100"
                >
                  <MessageSquare className="inline mr-2" size={16} /> Chat
                </button>
              </div>
                </div>
              ))}
              {doctors.length === 0 && <p className="text-gray-500">No doctors found.</p>}
            </div>
          </div>

          {/* Book Appointment Form */}
          {selectedDoctor && (
            <div className="bg-white p-6 rounded-xl shadow-sm border border-blue-200">
              <h2 className="text-lg font-bold mb-4">Book with {selectedDoctor.name}</h2>
              <form onSubmit={handleBook} className="flex gap-4 items-end">
                <div className="flex-1">
                  <label className="block text-sm text-gray-600 mb-1">Date</label>
                  <input type="date" required className="w-full px-3 py-2 border rounded-md" value={date} onChange={e => setDate(e.target.value)} />
                </div>
                <div className="flex-1">
                  <label className="block text-sm text-gray-600 mb-1">Time</label>
                  <input type="time" required className="w-full px-3 py-2 border rounded-md" value={time} onChange={e => setTime(e.target.value)} />
                </div>
                <button type="submit" className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700">Confirm Booking</button>
                <button type="button" onClick={() => setSelectedDoctor(null)} className="bg-gray-200 text-gray-700 px-4 py-2 rounded-md">Cancel</button>
              </form>
            </div>
          )}

          {/* Medical History */}
          <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
            <h2 className="text-lg font-bold mb-4 flex items-center"><FileText className="mr-2"/> Medical History (Read Only)</h2>
            <div className="space-y-4">
              {history.map(item => (
                <div key={item.id} className="p-4 bg-gray-50 rounded-lg border border-gray-200">
                  <div className="flex justify-between mb-2">
                    <span className="font-semibold">Dr. {item.doctor_name}</span>
                    <span className="text-sm text-gray-500">{new Date(item.created_at).toLocaleDateString()}</span>
                  </div>
                  <p className="text-gray-700 whitespace-pre-wrap">{item.record_text}</p>
                </div>
              ))}
              {history.length === 0 && <p className="text-gray-500">No history records found.</p>}
            </div>
          </div>
        </div>

        {/* Sidebar */}
        <div className="space-y-6">
          {/* My Appointments */}
          <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
            <h2 className="text-lg font-bold mb-4 flex items-center"><Calendar className="mr-2"/> My Appointments</h2>
            <div className="space-y-4">
              {appointments.map(appt => (
                <div key={appt.id} className="p-3 border rounded-lg bg-gray-50">
                  <p className="font-semibold">Dr. {appt.doctor_name}</p>
                  <p className="text-sm text-gray-600">{appt.date} at {appt.time}</p>
                  <div className="flex justify-between items-center mt-2">
                    <span className={`text-xs px-2 py-1 rounded-full ${
                      appt.status === 'Pending' ? 'bg-yellow-100 text-yellow-800' :
                      appt.status === 'Confirmed' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                    }`}>
                      {appt.status}
                    </span>
                    {!appt.payment_verified && appt.status === 'Pending' && (
                      <button onClick={() => setPaymentApptId(appt.id)} className="text-xs text-blue-600 hover:underline flex items-center">
                        <Upload size={14} className="mr-1"/> Pay
                      </button>
                    )}
                  </div>
                </div>
              ))}
              {appointments.length === 0 && <p className="text-sm text-gray-500">No appointments booked.</p>}
            </div>
          </div>

          {/* Payment Upload Form */}
          {paymentApptId && (
            <div className="bg-white p-6 rounded-xl shadow-sm border border-yellow-200">
              <h2 className="text-md font-bold mb-2 text-yellow-800">Upload Payment Screenshot</h2>
              <form onSubmit={handleUploadPayment} className="space-y-3">
                <input 
                  type="file" 
                  accept="image/*" 
                  required
                  onChange={(e) => setPaymentFile(e.target.files ? e.target.files[0] : null)}
                  className="w-full text-sm"
                />
                <div className="flex space-x-2">
                  <button type="submit" className="flex-1 bg-yellow-500 text-white py-2 rounded text-sm">Upload</button>
                  <button type="button" onClick={() => setPaymentApptId(null)} className="flex-1 bg-gray-200 text-gray-700 py-2 rounded text-sm">Cancel</button>
                </div>
              </form>
            </div>
          )}

          {chatDoctor && (
            <div className="bg-white p-6 rounded-xl shadow-sm border border-indigo-100">
              <h2 className="text-lg font-bold mb-4 flex items-center"><MessageSquare className="mr-2" /> Chat with Dr. {chatDoctor.name}</h2>
              <div className="max-h-72 overflow-y-auto space-y-3 mb-4">
                {messages.map((msg) => (
                  <div key={msg.id} className={`p-3 rounded-xl ${msg.sender_id === user?.id ? 'bg-blue-600 text-white ml-auto' : 'bg-gray-100 text-gray-900'}`}>
                    <p className="text-sm whitespace-pre-wrap">{msg.content}</p>
                    <p className="text-xs text-gray-400 mt-1">{new Date(msg.created_at).toLocaleString()}</p>
                  </div>
                ))}
                {messages.length === 0 && <p className="text-gray-500">No messages yet. Send a message to start.</p>}
              </div>
              <form onSubmit={sendMessage} className="space-y-3">
                <textarea
                  rows={3}
                  className="w-full px-3 py-2 border rounded-md"
                  placeholder="Write your message..."
                  value={chatText}
                  onChange={(e) => setChatText(e.target.value)}
                />
                <div className="flex gap-2">
                  <button type="submit" className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">Send</button>
                  <button type="button" onClick={() => setChatDoctor(null)} className="bg-gray-200 text-gray-700 px-4 py-2 rounded-md hover:bg-gray-300">Close</button>
                </div>
              </form>
            </div>
          )}
        </div>

      </div>
    </div>
  );
};

export default PatientDashboard;
