'use client';

import { useEffect, useState } from 'react';

const LocalWarningBanner = () => {
  const [isLocal, setIsLocal] = useState(false);

  useEffect(() => {
    // Only show banner in development mode AND when explicitly set to localhost
    setIsLocal(
      process.env.NODE_ENV === 'development' && 
      process.env.NEXT_PUBLIC_NETWORK === 'localhost'
    );
    // Log the current environment for debugging
    console.log('Environment:', {
      NODE_ENV: process.env.NODE_ENV,
      NEXT_PUBLIC_NETWORK: process.env.NEXT_PUBLIC_NETWORK,
      isLocal: process.env.NODE_ENV === 'development' && process.env.NEXT_PUBLIC_NETWORK === 'localhost'
    });
  }, []);

  if (!isLocal) return null;

  return (
    <div className="fixed bottom-4 right-4 bg-yellow-400 text-black text-sm px-4 py-2 rounded-lg shadow-lg border-2 border-yellow-500 z-40 flex items-center gap-2 transform transition-all duration-300 hover:scale-105">
      <div className="text-lg">🚧</div>
      <div className="text-left">
        <div className="font-bold">Local Development Preview</div>
        <div className="text-xs opacity-80">Using local blockchain and mock data</div>
      </div>
    </div>
  );
};

export default LocalWarningBanner;
