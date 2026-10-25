import type { ReactNode } from 'react';
export const metadata = { title: 'Coditude Assessment', description: 'AWS DevOps assessment frontend' };
export default function RootLayout({ children }: { children: ReactNode }) {
  return <html lang="en"><body>{children}</body></html>;
}
