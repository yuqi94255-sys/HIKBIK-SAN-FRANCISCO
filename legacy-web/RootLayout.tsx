import { Outlet, useLocation } from "react-router";
import { BottomNavigation } from "./BottomNavigation";

export function RootLayout() {
  const location = useLocation();
  const isWelcomeScreen = location.pathname === '/';

  return (
    <div className="min-h-screen bg-neutral-50">
      <div className={isWelcomeScreen ? '' : 'pb-20'}>
        <Outlet />
      </div>
      
      {!isWelcomeScreen && <BottomNavigation />}
    </div>
  );
}
