import * as React from 'react';
import dynamic from 'next/dynamic';

// Dynamically import the LocalWarningBanner with no SSR to avoid hydration issues
const LocalWarningBanner = dynamic(
  () => import('@/components/ui/LocalWarningBanner'),
  { ssr: false }
);

export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <>
      <div
        id='layout'
        className='min-w-screen min-h-screen mobile-demo:min-w-full'
      >
        {children}
        <LocalWarningBanner />
      </div>
    </>
  );
}
