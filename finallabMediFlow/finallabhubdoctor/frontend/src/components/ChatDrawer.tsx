import React, { useState, useEffect, useRef } from 'react';
import { io, Socket } from 'socket.io-client';
import { useAuth } from '../context/AuthContext';
import api from '../lib/api';
import { X, Send, User } from 'lucide-react';

interface ChatDrawerProps {
  isOpen: boolean;
  onClose: () => void;
  onUnreadChange: (count: number) => void;
}

const ChatDrawer: React.FC<ChatDrawerProps> = ({ isOpen, onClose, onUnreadChange }) => {
  const { user } = useAuth();
  const [socket, setSocket] = useState<Socket | null>(null);
  const [contacts, setContacts] = useState<any[]>([]);
  const [activeChat, setActiveChat] = useState<any | null>(null);
  const [messages, setMessages] = useState<any[]>([]);
  const [inputText, setInputText] = useState('');
  const [unreadCounts, setUnreadCounts] = useState<Record<number, number>>({});
  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!user) return;
    
    const fetchContacts = async () => {
      try {
        if (user.role === 'Patient') {
          const { data } = await api.get('/doctors');
          setContacts(data.map((d: any) => ({ id: d.user_id, name: d.name, role: 'Doctor' })));
        } else if (user.role === 'Doctor') {
          const { data } = await api.get('/appointments');
          const uniquePatients = Array.from(new Set(data.map((a: any) => a.patient_user_id)))
            .map(id => {
               const appt = data.find((a: any) => a.patient_user_id === id);
               return { id, name: appt.patient_name, role: 'Patient' };
            });
          setContacts(uniquePatients.filter((c: any) => c.id));
        }
      } catch (err) {
        console.error(err);
      }
    };
    fetchContacts();

    const newSocket = io(import.meta.env.VITE_API_URL?.replace('/api', '') || 'http://localhost:5000');
    setSocket(newSocket);

    newSocket.on('connect', () => {
      newSocket.emit('register', user.id);
    });

    newSocket.on('new_message', (msg: any) => {
      if (activeChat && msg.sender_id === activeChat.id) {
        setMessages(prev => [...prev, msg]);
      } else {
        setUnreadCounts(prev => {
          const newCounts = { ...prev, [msg.sender_id]: (prev[msg.sender_id] || 0) + 1 };
          const totalUnread = Object.values(newCounts).reduce((a, b) => a + b, 0);
          onUnreadChange(totalUnread);
          return newCounts;
        });
      }
    });

    return () => {
      newSocket.close();
    };
  }, [user]); // Only run on user change

  // This second effect is for listening to socket events while activeChat changes
  // Actually, we must use a ref for activeChat to avoid stale closures in socket listener
  // But since we use functional updates `setMessages(prev => ...)` it works if we check activeChat.id
  // However, activeChat is from the closure of the first useEffect. 
  // We need to sync it.
  const activeChatRef = useRef(activeChat);
  useEffect(() => {
    activeChatRef.current = activeChat;
  }, [activeChat]);

  useEffect(() => {
    if (!socket) return;
    const handleNewMessage = (msg: any) => {
      const currentChat = activeChatRef.current;
      if (currentChat && msg.sender_id === currentChat.id) {
        setMessages(prev => [...prev, msg]);
      } else {
        setUnreadCounts(prev => {
          const newCounts = { ...prev, [msg.sender_id]: (prev[msg.sender_id] || 0) + 1 };
          const totalUnread = Object.values(newCounts).reduce((a, b) => a + b, 0);
          onUnreadChange(totalUnread);
          return newCounts;
        });
      }
    };
    
    socket.off('new_message');
    socket.on('new_message', handleNewMessage);
  }, [socket]);

  useEffect(() => {
    if (activeChat) {
      setUnreadCounts(prev => {
        const newCounts = { ...prev };
        delete newCounts[activeChat.id];
        const totalUnread = Object.values(newCounts).reduce((a, b) => a + b, 0);
        onUnreadChange(totalUnread);
        return newCounts;
      });

      api.get(`/communication/messages/${activeChat.id}`).then((res: any) => {
        setMessages(res.data);
      }).catch(console.error);
    }
  }, [activeChat]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const handleSend = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!inputText.trim() || !activeChat) return;

    try {
      const { data } = await api.post('/communication/message', {
        receiver_id: activeChat.id,
        content: inputText
      });
      setMessages(prev => [...prev, data.data]);
      setInputText('');
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <>
      {isOpen && (
        <div className="fixed inset-0 bg-black/50 z-40" onClick={onClose}></div>
      )}

      <div className={`fixed top-0 right-0 h-full w-80 bg-white dark:bg-slate-800 shadow-2xl z-50 transform transition-transform duration-300 ease-in-out ${isOpen ? 'translate-x-0' : 'translate-x-full'} flex flex-col`}>
        
        <div className="p-4 border-b dark:border-slate-700 flex justify-between items-center bg-primary text-white">
          <h2 className="font-bold">{activeChat ? `Chat: ${activeChat.name}` : 'Messages'}</h2>
          <button onClick={() => activeChat ? setActiveChat(null) : onClose()} className="hover:bg-white/20 p-1 rounded-full">
            <X size={20} />
          </button>
        </div>

        <div className="flex-1 overflow-hidden flex flex-col">
          {!activeChat ? (
            <div className="flex-1 overflow-y-auto p-2">
              {contacts.length === 0 ? (
                <p className="text-center text-gray-500 mt-10 text-sm">No contacts available.</p>
              ) : (
                contacts.map(c => (
                  <div key={c.id} onClick={() => setActiveChat(c)} className="flex items-center p-3 hover:bg-gray-50 dark:hover:bg-slate-700 cursor-pointer rounded-lg mb-1 border border-transparent hover:border-gray-100 dark:hover:border-slate-600 transition">
                    <div className="w-10 h-10 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center mr-3 relative">
                      <User size={20} />
                      {unreadCounts[c.id] > 0 && (
                        <span className="absolute -top-1 -right-1 bg-red-500 text-white text-[10px] w-4 h-4 flex items-center justify-center rounded-full font-bold">
                          {unreadCounts[c.id]}
                        </span>
                      )}
                    </div>
                    <div>
                      <p className="font-semibold text-gray-900 dark:text-white text-sm">{c.name}</p>
                      <p className="text-xs text-gray-500">{c.role}</p>
                    </div>
                  </div>
                ))
              )}
            </div>
          ) : (
            <>
              <div className="flex-1 overflow-y-auto p-4 space-y-3 bg-gray-50 dark:bg-slate-900">
                {messages.map(msg => {
                  const isMe = msg.sender_id === user?.id;
                  return (
                    <div key={msg.id} className={`flex flex-col ${isMe ? 'items-end' : 'items-start'}`}>
                      <div className={`px-4 py-2 rounded-2xl max-w-[85%] text-sm ${isMe ? 'bg-primary text-white rounded-tr-sm' : 'bg-white dark:bg-slate-700 dark:text-white border border-gray-100 dark:border-slate-600 rounded-tl-sm shadow-sm'}`}>
                        {msg.content}
                      </div>
                      <span className="text-[10px] text-gray-400 mt-1 mx-1">{new Date(msg.created_at).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}</span>
                    </div>
                  );
                })}
                <div ref={messagesEndRef} />
              </div>
              <form onSubmit={handleSend} className="p-3 border-t dark:border-slate-700 bg-white dark:bg-slate-800 flex gap-2">
                <input 
                  type="text" 
                  value={inputText}
                  onChange={e => setInputText(e.target.value)}
                  placeholder="Type a message..." 
                  className="flex-1 px-3 py-2 bg-gray-100 dark:bg-slate-700 border-transparent focus:border-blue-500 rounded-full text-sm outline-none dark:text-white"
                />
                <button type="submit" disabled={!inputText.trim()} className="w-10 h-10 rounded-full bg-primary text-white flex items-center justify-center disabled:opacity-50 hover:bg-slate-800 transition">
                  <Send size={16} className="-ml-0.5" />
                </button>
              </form>
            </>
          )}
        </div>

      </div>
    </>
  );
};

export default ChatDrawer;
