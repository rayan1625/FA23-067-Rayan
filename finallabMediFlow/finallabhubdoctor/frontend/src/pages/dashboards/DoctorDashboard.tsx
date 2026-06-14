import React, { useState, useEffect } from 'react';
import MobileLayout from '../../components/Layout/MobileLayout';
import { useAuth } from '../../context/AuthContext';
import api from '../../lib/api';
import { Calendar, PenTool, CheckCircle, Clock } from 'lucide-react';

const DoctorDashboard = () => {
  const { user, logout } = useAuth();
  const [appointments, setAppointments] = useState<any[]>([]);
  const [prescriptions, setPrescriptions] = useState<any[]>([]);

  const [selectedAppt, setSelectedAppt] = useState<any>(null);
  const [medicines, setMedicines] = useState('');
  const [notes, setNotes] = useState('');

  useEffect(() => {
    fetchAppointments();
    fetchPrescriptions();
  }, []);

  const fetchAppointments = async () => {
    try {
      const { data } = await api.get('/appointments');
      setAppointments(data);
    } catch (err) {
      console.error(err);
    }
  };

  const fetchPrescriptions = async () => {
    try {
      const { data } = await api.get('/prescriptions');
      setPrescriptions(data);
    } catch (err) {
      console.error(err);
    }
  };

  const handlePrescribe = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedAppt) return;
    try {
      await api.post('/prescriptions', {
        appointment_id: selectedAppt.id,
        patient_id: selectedAppt.patient_id,
        medicines,
        notes
      });
      setSelectedAppt(null);
      setMedicines('');
      setNotes('');
      fetchAppointments();
      fetchPrescriptions();
      alert('Prescription added and saved to history!');
    } catch (err) {
      console.error(err);
      alert('Failed to add prescription.');
    }
  };

  const todaysAppointments = appointments.filter(a => new Date(a.date).toDateString() === new Date().toDateString());
  const pendingConsultations = appointments.filter(a => a.status === 'Confirmed' || a.status === 'Pending');

  return (
    <MobileLayout title="MediFlow - Doctor" headerRight={<button onClick={logout} className="text-xs text-red-500 font-medium bg-red-50 px-3 py-1.5 rounded-full">Logout</button>}>
      
      <div className="bg-primary text-white p-6 pb-12 rounded-b-3xl relative">
        <h2 className="text-2xl font-bold mb-1">Dr. {user?.name?.split(' ')[0]}</h2>
        <p className="text-blue-100 text-sm">Dashboard Overview</p>
      </div>

      <div className="px-4 -mt-6 pb-6">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          
          {/* Left Sidebar: Today's Schedule */}
          <div className="md:col-span-1 space-y-4">
            <h3 className="font-bold text-gray-900 dark:text-white text-lg">Today's Schedule</h3>
            <div className="bg-white dark:bg-slate-800 p-4 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700">
              <div className="space-y-4">
                {todaysAppointments.map(appt => (
                  <div key={appt.id} className="flex gap-3 items-center border-b border-gray-100 dark:border-slate-700 pb-3 last:border-0 last:pb-0">
                    <div className="bg-blue-50 dark:bg-slate-700 text-blue-600 dark:text-blue-400 p-2 rounded-lg text-center min-w-[60px]">
                      <p className="text-xs font-bold">{appt.time}</p>
                    </div>
                    <div>
                      <p className="text-sm font-semibold dark:text-white">{appt.patient_name}</p>
                      <p className="text-xs text-gray-500">{appt.status}</p>
                    </div>
                  </div>
                ))}
                {todaysAppointments.length === 0 && <p className="text-sm text-gray-500">No appointments today.</p>}
              </div>
            </div>
          </div>

          {/* Main Area: Pending Consultations */}
          <div className="md:col-span-2 space-y-4">
            <h3 className="font-bold text-gray-900 dark:text-white text-lg">Pending Consultations</h3>
            <div className="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 overflow-hidden">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="bg-gray-50 dark:bg-slate-700 border-b border-gray-100 dark:border-slate-600">
                    <th className="p-4 text-xs font-bold text-gray-500 uppercase">Patient</th>
                    <th className="p-4 text-xs font-bold text-gray-500 uppercase">Time</th>
                    <th className="p-4 text-xs font-bold text-gray-500 uppercase text-right">Action</th>
                  </tr>
                </thead>
                <tbody>
                  {pendingConsultations.map(appt => (
                    <tr key={appt.id} className="border-b border-gray-100 dark:border-slate-700 last:border-0 hover:bg-gray-50 dark:hover:bg-slate-700/50">
                      <td className="p-4">
                        <p className="font-semibold text-sm dark:text-white">{appt.patient_name}</p>
                        <p className="text-xs text-gray-500">{appt.status}</p>
                      </td>
                      <td className="p-4 text-sm text-gray-600 dark:text-gray-300">
                        {appt.date} <br/> <span className="text-xs">{appt.time}</span>
                      </td>
                      <td className="p-4 text-right">
                        {appt.status !== 'Completed' && (
                          <button 
                            onClick={() => setSelectedAppt(appt)} 
                            className="bg-secondary text-white px-4 py-2 rounded-lg text-xs font-medium hover:bg-emerald-600 transition shadow-sm shadow-emerald-500/20"
                          >
                            Start Consult
                          </button>
                        )}
                      </td>
                    </tr>
                  ))}
                  {pendingConsultations.length === 0 && (
                    <tr>
                      <td colSpan={3} className="p-6 text-center text-gray-500 text-sm">No pending consultations.</td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>

          {/* Right Sidebar: Recent Prescriptions */}
          <div className="md:col-span-1 space-y-4">
            <h3 className="font-bold text-gray-900 dark:text-white text-lg">Recent Prescriptions</h3>
            <div className="bg-white dark:bg-slate-800 p-4 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700">
              <div className="space-y-4">
                {prescriptions.slice(0, 5).map(rx => (
                  <div key={rx.id} className="border-l-2 border-primary dark:border-secondary pl-3">
                    <p className="text-xs text-gray-500 dark:text-gray-400 mb-0.5">{new Date(rx.created_at).toLocaleDateString()}</p>
                    <p className="text-sm font-semibold dark:text-white line-clamp-1">{rx.medicines}</p>
                    <p className="text-xs text-gray-600 dark:text-gray-300 mt-1 line-clamp-2">{rx.notes}</p>
                  </div>
                ))}
                {prescriptions.length === 0 && <p className="text-sm text-gray-500">No recent prescriptions.</p>}
              </div>
            </div>
          </div>

        </div>

        {/* Write Prescription Modal */}
        {selectedAppt && (
          <div className="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4">
             <div className="bg-white dark:bg-slate-800 rounded-2xl w-full max-w-sm p-6 shadow-xl">
               <h3 className="font-bold text-gray-900 dark:text-white text-lg mb-4">Prescription for {selectedAppt.patient_name}</h3>
               <form onSubmit={handlePrescribe} className="space-y-4">
                  <div>
                    <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 uppercase mb-1">Medicines</label>
                    <textarea
                      required
                      rows={3}
                      className="w-full px-3 py-2 bg-gray-50 dark:bg-slate-700 border border-gray-200 dark:border-slate-600 rounded-lg text-sm focus:outline-none focus:border-blue-500 dark:text-white"
                      value={medicines}
                      onChange={(e) => setMedicines(e.target.value)}
                      placeholder="E.g., Paracetamol 500mg"
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-bold text-gray-700 dark:text-gray-300 uppercase mb-1">Notes (Optional)</label>
                    <textarea
                      rows={2}
                      className="w-full px-3 py-2 bg-gray-50 dark:bg-slate-700 border border-gray-200 dark:border-slate-600 rounded-lg text-sm focus:outline-none focus:border-blue-500 dark:text-white"
                      value={notes}
                      onChange={(e) => setNotes(e.target.value)}
                      placeholder="Dietary instructions..."
                    />
                  </div>
                  <div className="pt-2 flex gap-3">
                    <button type="button" onClick={() => setSelectedAppt(null)} className="flex-1 py-2.5 rounded-xl text-sm font-medium text-gray-600 bg-gray-100 dark:bg-slate-700 dark:text-gray-300">Cancel</button>
                    <button type="submit" className="flex-1 py-2.5 rounded-xl text-sm font-medium text-white bg-primary hover:bg-slate-800 shadow-md">Save Record</button>
                  </div>
                  <p className="text-[10px] text-gray-500 text-center flex items-center justify-center mt-2">
                    <CheckCircle size={10} className="mr-1 text-green-500"/> Immutable once saved
                  </p>
               </form>
             </div>
          </div>
        )}

      </div>
    </MobileLayout>
  );
};

export default DoctorDashboard;
