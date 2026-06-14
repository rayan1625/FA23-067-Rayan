import React from 'react';
import BottomNav from './BottomNav';
import { useLocation } from 'react-router-dom';

const MobileLayout: React.FC<{ children: React.ReactNode, hideBottomNav?: boolean, headerRight?: React.ReactNode, title?: string }> = ({ children, hideBottomNav, headerRight, title }) => {
  const location = useLocation();

  return (
    <div className="min-h-screen bg-[#F8F9FA] text-gray-900 font-sans sm:bg-gray-200 flex justify-center">
      <div className="w-full max-w-md bg-white min-h-screen shadow-xl relative flex flex-col overflow-hidden">
        
        {/* Top Header */}
        <header className="flex justify-between items-center p-4 bg-white sticky top-0 z-10">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center overflow-hidden">
              <img src="https://ui-avatars.com/api/?name=Doc+Hub&background=0D8ABC&color=fff" alt="Logo" className="w-full h-full object-cover" />
            </div>
            <h1 className="text-lg font-bold text-[#0052FF]">{title || 'MedCore Central'}</h1>
          </div>
          {headerRight && <div>{headerRight}</div>}
        </header>

        {/* Content Area */}
        <main className="flex-1 overflow-y-auto pb-20 bg-[#F8F9FA]">
          {children}
        </main>

        {/* Bottom Navigation */}
        {!hideBottomNav && <BottomNav currentPath={location.pathname} />}
        
      </div>
    </div>
  );
};

export default MobileLayout;
