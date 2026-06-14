import React, { useState, useEffect } from 'react';
import MobileLayout from '../../components/Layout/MobileLayout';
import { useAuth } from '../../context/AuthContext';
import api from '../../lib/api';
import { Search, Calendar, FileText, Upload, MessageSquare, Activity } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
} from 'chart.js';
import { Line } from 'react-chartjs-2';

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
);

const PatientDashboard = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [appointments, setAppointments] = useState<any[]>([]);
  const [history, setHistory] = useState<any[]>([]);
  const [prescriptions, setPrescriptions] = useState<any[]>([]);
  const [metrics, setMetrics] = useState<any[]>([]);
  const [newMetric, setNewMetric] = useState({ bp_systolic: '', bp_diastolic: '', heart_rate: '', weight_kg: '' });
  
  // Payment upload state
  const [paymentFile, setPaymentFile] = useState<File | null>(null);
  const [paymentApptId, setPaymentApptId] = useState<number | null>(null);
  const [paymentMethod, setPaymentMethod] = useState<'offline' | 'online'>('online');

  useEffect(() => {
    fetchAppointments();
    fetchHistory();
    fetchMetrics();
    // Simulate fetching prescriptions since there's no patient endpoint yet, or use history length
    setPrescriptions(history); // Mock
  }, [history.length]); // Dependency on history to trigger

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
      setPrescriptions(data); // mock
    } catch (err) {
      console.error(err);
    }
  };

  const fetchMetrics = async () => {
    try {
      const { data } = await api.get('/health');
      setMetrics(data);
    } catch (err) {
      console.error(err);
    }
  };

  const handleAddMetric = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await api.post('/health', newMetric);
      setNewMetric({ bp_systolic: '', bp_diastolic: '', heart_rate: '', weight_kg: '' });
      fetchMetrics();
      alert('Health metrics updated!');
    } catch (err) {
      console.error(err);
      alert('Failed to add metric.');
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

  const handleOnlinePayment = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!paymentApptId) return;
    try {
      await api.post('/payments/online', { appointment_id: paymentApptId });
      setPaymentApptId(null);
      alert('Payment successful. Appointment confirmed instantly!');
      fetchAppointments();
    } catch (err) {
      console.error(err);
      alert('Payment failed.');
    }
  };

  const upcomingAppointments = appointments.filter(a => a.status === 'Pending' || a.status === 'Confirmed');

  const chartData = {
    labels: metrics.map(m => new Date(m.recorded_at).toLocaleDateString()),
    datasets: [
      {
        label: 'Systolic BP',
        data: metrics.map(m => m.bp_systolic),
        borderColor: '#0052FF',
        backgroundColor: 'rgba(0, 82, 255, 0.5)',
      },
      {
        label: 'Diastolic BP',
        data: metrics.map(m => m.bp_diastolic),
        borderColor: '#50E3C2',
        backgroundColor: 'rgba(80, 227, 194, 0.5)',
      }
    ],
  };
  const chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { position: 'top' as const },
    },
  };

  return (
    <MobileLayout 
      title="MediFlow - Patient" 
      headerRight={<button onClick={logout} className="text-xs text-red-500 font-medium bg-red-50 px-3 py-1.5 rounded-full">Logout</button>}
    >
      <div className="bg-primary text-white p-6 pb-12 rounded-b-3xl relative">
        <h2 className="text-2xl font-bold mb-1">Hi, {user?.name?.split(' ')[0]}</h2>
        <p className="text-blue-100 text-sm">Your health overview</p>

        {/* 3 Metric Cards */}
        <div className="mt-6 grid grid-cols-3 gap-3">
           <div className="bg-white/10 backdrop-blur-md rounded-xl p-3 border border-white/20 text-center">
             <p className="text-xs text-blue-100 mb-1">Total Appts</p>
             <p className="text-2xl font-bold">{appointments.length}</p>
           </div>
           <div className="bg-white/10 backdrop-blur-md rounded-xl p-3 border border-white/20 text-center">
             <p className="text-xs text-blue-100 mb-1">Upcoming</p>
             <p className="text-2xl font-bold">{upcomingAppointments.length}</p>
           </div>
           <div className="bg-white/10 backdrop-blur-md rounded-xl p-3 border border-white/20 text-center">
             <p className="text-xs text-blue-100 mb-1">Scripts</p>
             <p className="text-2xl font-bold">{prescriptions.length}</p>
           </div>
        </div>
      </div>

      <div className="px-4 -mt-6 pb-6 space-y-6">
        
        {/* Upcoming Appointments (Horizontal Scroll) */}
        <div>
          <h3 className="font-bold text-gray-900 dark:text-white text-lg mb-3">Upcoming Appointments</h3>
          <div className="flex overflow-x-auto pb-4 gap-4 scrollbar-hide">
            {upcomingAppointments.map(appt => (
              <div key={appt.id} className="min-w-[240px] bg-white dark:bg-slate-800 p-4 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 flex-shrink-0">
                <div className="flex justify-between items-start">
                  <div>
                    <p className="font-semibold dark:text-white">Dr. {appt.doctor_name}</p>
                    <p className="text-sm text-gray-600 dark:text-gray-300 flex items-center mt-1"><Calendar size={12} className="mr-1"/> {appt.date} at {appt.time}</p>
                  </div>
                  <span className={`text-[10px] px-2 py-1 rounded-full font-medium ${
                      appt.status === 'Confirmed' ? 'bg-secondary/20 text-secondary' : 'bg-yellow-100 text-yellow-800'
                    }`}>
                      {appt.status}
                  </span>
                </div>
                {/* Pay Button */}
                {!appt.payment_verified && appt.status === 'Pending' && (
                  <button 
                    onClick={() => setPaymentApptId(appt.id)}
                    className="mt-3 w-full bg-blue-50 text-blue-600 dark:bg-blue-900/30 dark:text-blue-400 py-1.5 rounded-lg text-xs font-medium hover:bg-blue-100 transition flex justify-center items-center"
                  >
                    <Upload size={14} className="mr-1"/> Pay Now
                  </button>
                )}
              </div>
            ))}
            {upcomingAppointments.length === 0 && (
              <div className="w-full text-center p-4 bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700">
                <p className="text-sm text-gray-500">No upcoming appointments.</p>
              </div>
            )}
          </div>
        </div>

        {/* Payment Modal */}
        {paymentApptId && (
          <div className="bg-white dark:bg-slate-800 p-5 rounded-xl shadow-sm border border-yellow-200 dark:border-yellow-800">
            <h2 className="text-md font-bold mb-2 text-yellow-800 dark:text-yellow-400">Complete Payment</h2>
            
            <div className="flex gap-2 mb-4">
               <button type="button" onClick={() => setPaymentMethod('online')} className={`flex-1 py-1.5 rounded-lg text-sm font-medium ${paymentMethod === 'online' ? 'bg-primary text-white' : 'bg-gray-100 dark:bg-slate-700 text-gray-600 dark:text-gray-300'}`}>Online Card</button>
               <button type="button" onClick={() => setPaymentMethod('offline')} className={`flex-1 py-1.5 rounded-lg text-sm font-medium ${paymentMethod === 'offline' ? 'bg-primary text-white' : 'bg-gray-100 dark:bg-slate-700 text-gray-600 dark:text-gray-300'}`}>Upload Receipt</button>
            </div>

            {paymentMethod === 'online' ? (
              <form onSubmit={handleOnlinePayment} className="space-y-3">
                <input type="text" placeholder="Card Number (Dummy: 4111...)" required className="w-full px-3 py-2 bg-gray-50 dark:bg-slate-700 border border-gray-200 dark:border-slate-600 rounded-lg text-sm dark:text-white" />
                <div className="flex gap-2">
                  <input type="text" placeholder="MM/YY" required className="w-1/2 px-3 py-2 bg-gray-50 dark:bg-slate-700 border border-gray-200 dark:border-slate-600 rounded-lg text-sm dark:text-white" />
                  <input type="text" placeholder="CVV" required className="w-1/2 px-3 py-2 bg-gray-50 dark:bg-slate-700 border border-gray-200 dark:border-slate-600 rounded-lg text-sm dark:text-white" />
                </div>
                <div className="flex space-x-2">
                  <button type="submit" className="flex-1 bg-green-500 text-white py-2 rounded-lg text-sm font-medium">Pay Instantly</button>
                  <button type="button" onClick={() => setPaymentApptId(null)} className="flex-1 bg-gray-200 dark:bg-slate-700 text-gray-700 dark:text-gray-300 py-2 rounded-lg text-sm font-medium">Cancel</button>
                </div>
              </form>
            ) : (
              <form onSubmit={handleUploadPayment} className="space-y-3">
                <input 
                  type="file" 
                  accept="image/*" 
                  required
                  onChange={(e) => setPaymentFile(e.target.files ? e.target.files[0] : null)}
                  className="w-full text-sm dark:text-gray-300"
                />
                <div className="flex space-x-2">
                  <button type="submit" className="flex-1 bg-yellow-500 text-white py-2 rounded-lg text-sm font-medium">Upload for Verification</button>
                  <button type="button" onClick={() => setPaymentApptId(null)} className="flex-1 bg-gray-200 dark:bg-slate-700 text-gray-700 dark:text-gray-300 py-2 rounded-lg text-sm font-medium">Cancel</button>
                </div>
              </form>
            )}
          </div>
        )}

        {/* Health Metrics Chart & Form */}
        <div className="bg-white dark:bg-slate-800 p-5 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700">
           <div className="flex justify-between items-center mb-4">
             <h3 className="font-bold text-gray-900 dark:text-white text-lg flex items-center"><Activity className="mr-2 text-red-500" size={18}/> Health Metrics</h3>
           </div>
           
           {metrics.length > 0 ? (
             <div className="mb-6 h-48 w-full">
               <Line data={chartData} options={chartOptions} />
             </div>
           ) : (
             <div className="mb-6 p-4 text-center bg-gray-50 dark:bg-slate-700 rounded-lg text-sm text-gray-500 dark:text-gray-400">
               No health metrics recorded yet.
             </div>
           )}

           <form onSubmit={handleAddMetric} className="bg-gray-50 dark:bg-slate-700/50 p-4 rounded-xl border border-gray-100 dark:border-slate-600">
             <h4 className="text-sm font-bold text-gray-700 dark:text-gray-300 mb-3">Record New Metrics</h4>
             <div className="grid grid-cols-2 gap-3 mb-3">
               <div>
                 <label className="text-[10px] uppercase font-bold text-gray-500 dark:text-gray-400">Systolic BP</label>
                 <input type="number" required placeholder="120" value={newMetric.bp_systolic} onChange={e => setNewMetric({...newMetric, bp_systolic: e.target.value})} className="w-full px-3 py-2 bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-600 rounded-lg text-sm mt-1 focus:outline-none focus:border-blue-500 dark:text-white" />
               </div>
               <div>
                 <label className="text-[10px] uppercase font-bold text-gray-500 dark:text-gray-400">Diastolic BP</label>
                 <input type="number" required placeholder="80" value={newMetric.bp_diastolic} onChange={e => setNewMetric({...newMetric, bp_diastolic: e.target.value})} className="w-full px-3 py-2 bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-600 rounded-lg text-sm mt-1 focus:outline-none focus:border-blue-500 dark:text-white" />
               </div>
               <div>
                 <label className="text-[10px] uppercase font-bold text-gray-500 dark:text-gray-400">Heart Rate</label>
                 <input type="number" required placeholder="72" value={newMetric.heart_rate} onChange={e => setNewMetric({...newMetric, heart_rate: e.target.value})} className="w-full px-3 py-2 bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-600 rounded-lg text-sm mt-1 focus:outline-none focus:border-blue-500 dark:text-white" />
               </div>
               <div>
                 <label className="text-[10px] uppercase font-bold text-gray-500 dark:text-gray-400">Weight (kg)</label>
                 <input type="number" step="0.1" required placeholder="70.5" value={newMetric.weight_kg} onChange={e => setNewMetric({...newMetric, weight_kg: e.target.value})} className="w-full px-3 py-2 bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-600 rounded-lg text-sm mt-1 focus:outline-none focus:border-blue-500 dark:text-white" />
               </div>
             </div>
             <button type="submit" className="w-full bg-blue-600 text-white py-2 rounded-lg text-sm font-medium hover:bg-blue-700 transition">Save Metrics</button>
           </form>
        </div>

        {/* Bottom grid: Timeline & Quick Actions */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          
          {/* Medical History Timeline */}
          <div className="bg-white dark:bg-slate-800 p-5 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700">
            <h3 className="font-bold text-gray-900 dark:text-white text-lg mb-4 flex items-center"><FileText className="mr-2" size={18}/> History Timeline</h3>
            <div className="space-y-4 border-l-2 border-gray-100 dark:border-slate-700 ml-2 pl-4">
              {history.slice(0, 5).map((item) => (
                <div key={item.id} className="relative">
                  <div className="absolute -left-[23px] top-1 w-4 h-4 bg-primary dark:bg-secondary rounded-full border-4 border-white dark:border-slate-800"></div>
                  <p className="font-semibold text-sm dark:text-white">Dr. {item.doctor_name}</p>
                  <p className="text-xs text-gray-500 dark:text-gray-400 mb-1">{new Date(item.created_at).toLocaleDateString()}</p>
                  <p className="text-sm text-gray-700 dark:text-gray-300 line-clamp-2">{item.record_text}</p>
                </div>
              ))}
              {history.length === 0 && <p className="text-sm text-gray-500">No history records found.</p>}
            </div>
          </div>

          {/* Quick Actions */}
          <div className="bg-white dark:bg-slate-800 p-5 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700">
             <h3 className="font-bold text-gray-900 dark:text-white text-lg mb-4">Quick Actions</h3>
             <div className="grid grid-cols-2 gap-3">
               <button onClick={() => navigate('/patient/search')} className="flex flex-col items-center justify-center p-4 bg-gray-50 dark:bg-slate-700 rounded-xl hover:bg-gray-100 dark:hover:bg-slate-600 transition">
                 <Search size={24} className="text-primary dark:text-white mb-2" />
                 <span className="text-xs font-medium dark:text-white">Book Appt</span>
               </button>
               <button onClick={() => navigate('/patient/history')} className="flex flex-col items-center justify-center p-4 bg-gray-50 dark:bg-slate-700 rounded-xl hover:bg-gray-100 dark:hover:bg-slate-600 transition">
                 <Upload size={24} className="text-primary dark:text-white mb-2" />
                 <span className="text-xs font-medium dark:text-white">Reports</span>
               </button>
               <button onClick={() => alert("Chat functionality will open drawer (Step 5)")} className="flex flex-col items-center justify-center p-4 bg-gray-50 dark:bg-slate-700 rounded-xl hover:bg-gray-100 dark:hover:bg-slate-600 transition col-span-2">
                 <MessageSquare size={24} className="text-primary dark:text-white mb-2" />
                 <span className="text-xs font-medium dark:text-white">Message Doctor</span>
               </button>
             </div>
          </div>

        </div>

      </div>
    </MobileLayout>
  );
};

export default PatientDashboard;
