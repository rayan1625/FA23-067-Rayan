import React from 'react';
import BottomNav from './BottomNav';
import { useLocation } from 'react-router-dom';
import { Moon, Sun, MessageCircle } from 'lucide-react';
import ChatDrawer from '../ChatDrawer';
import { useAuth } from '../../context/AuthContext';

const MobileLayout: React.FC<{ children: React.ReactNode, hideBottomNav?: boolean, headerRight?: React.ReactNode, title?: string }> = ({ children, hideBottomNav, headerRight, title }) => {
  const location = useLocation();
  const { user } = useAuth();
  const [isDarkMode, setIsDarkMode] = React.useState(false);
  const [isChatOpen, setIsChatOpen] = React.useState(false);
  const [unreadCount, setUnreadCount] = React.useState(0);

  React.useEffect(() => {
    if (isDarkMode) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  }, [isDarkMode]);

  const toggleDarkMode = () => setIsDarkMode(!isDarkMode);

  return (
    <div className={`min-h-screen font-sans flex justify-center ${isDarkMode ? 'bg-gray-900 dark' : 'bg-background sm:bg-gray-200'}`}>
      <div className="w-full max-w-md bg-white dark:bg-slate-800 min-h-screen shadow-xl relative flex flex-col overflow-hidden">
        
        {/* Top Header */}
        <header className="flex justify-between items-center p-4 bg-white dark:bg-slate-800 sticky top-0 z-10 border-b dark:border-slate-700">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center overflow-hidden">
              <img src="https://ui-avatars.com/api/?name=Medi+Flow&background=0D8ABC&color=fff" alt="Logo" className="w-full h-full object-cover" />
            </div>
            <h1 className="text-lg font-bold text-primary dark:text-white">{title || 'MediFlow Central'}</h1>
          </div>
          <div className="flex items-center gap-2">
            <button onClick={toggleDarkMode} className="p-2 text-gray-500 hover:text-gray-700 dark:text-gray-300 dark:hover:text-white">
              {isDarkMode ? <Sun size={20} /> : <Moon size={20} />}
            </button>
            {user && (
              <button onClick={() => setIsChatOpen(true)} className="p-2 text-gray-500 hover:text-gray-700 dark:text-gray-300 dark:hover:text-white relative">
                <MessageCircle size={20} />
                {unreadCount > 0 && (
                  <span className="absolute top-1 right-1 bg-red-500 text-white text-[10px] w-4 h-4 flex items-center justify-center rounded-full font-bold">
                    {unreadCount}
                  </span>
                )}
              </button>
            )}
            {headerRight}
          </div>
        </header>

        {/* Content Area */}
        <main className="flex-1 overflow-y-auto pb-20 bg-background dark:bg-slate-900">
          {children}
        </main>

        {/* Chat Drawer */}
        <ChatDrawer 
          isOpen={isChatOpen} 
          onClose={() => setIsChatOpen(false)} 
          onUnreadChange={setUnreadCount} 
        />

        {/* Bottom Navigation */}
        {!hideBottomNav && <BottomNav currentPath={location.pathname} />}
        
      </div>
    </div>
  );
};

export default MobileLayout;
