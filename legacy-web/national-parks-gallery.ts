// National Parks Photo Gallery Data
// Photos sourced from Unsplash - can be replaced with custom images later

export interface ParkGallery {
  parkId: string;
  photos: string[];
}

export const PARK_GALLERIES: Record<string, string[]> = {
  "yosemite": [
    "https://images.unsplash.com/photo-1516687401797-25297ff1462c?w=1200",
    "https://images.unsplash.com/photo-1548625361-08775eea0f2b?w=1200",
    "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=1200",
    "https://images.unsplash.com/photo-1570311594927-31da8c36f271?w=1200",
    "https://images.unsplash.com/photo-1581301267075-3c0c6c2c2c7b?w=1200",
    "https://images.unsplash.com/photo-1552799446-159ba9523315?w=1200",
  ],
  "yellowstone": [
    "https://images.unsplash.com/photo-1629985692757-48648f4f1fc1?w=1200",
    "https://images.unsplash.com/photo-1677116825823-97c47cf7b33c?w=1200",
    "https://images.unsplash.com/photo-1621276680566-a8c2e34fe55d?w=1200",
    "https://images.unsplash.com/photo-1566843772882-365c39e9b0ca?w=1200",
    "https://images.unsplash.com/photo-1589519160732-57fc498494f8?w=1200",
    "https://images.unsplash.com/photo-1580058572462-98e2c0e0e2e0?w=1200",
  ],
  "grand-canyon": [
    "https://images.unsplash.com/photo-1456425712190-0dd8c2b00156?w=1200",
    "https://images.unsplash.com/photo-1474044159687-1ee9f3a51722?w=1200",
    "https://images.unsplash.com/photo-1632189437161-a6560af9e232?w=1200",
    "https://images.unsplash.com/photo-1719859064930-a36495201a4a?w=1200",
    "https://images.unsplash.com/photo-1601486200695-1882e67e5b98?w=1200",
    "https://images.unsplash.com/photo-1555979703-d7e94985c265?w=1200",
  ],
  "zion": [
    "https://images.unsplash.com/photo-1524274165673-750e79bf7e2e?w=1200",
    "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=1200",
    "https://images.unsplash.com/photo-1615729947596-a598e5de0ab3?w=1200",
    "https://images.unsplash.com/photo-1569310515935-2c88dbf7dcfa?w=1200",
    "https://images.unsplash.com/photo-1508193638397-1c4234db14d8?w=1200",
    "https://images.unsplash.com/photo-1580795479225-3b9e9c1f7e3f?w=1200",
  ],
  "glacier": [
    "https://images.unsplash.com/photo-1635965072050-9b608060234d?w=1200",
    "https://images.unsplash.com/photo-1570740076956-b2f7950cd5d6?w=1200",
    "https://images.unsplash.com/photo-1568849676085-51415703900f?w=1200",
    "https://images.unsplash.com/photo-1596407081693-a21e1a9e0521?w=1200",
    "https://images.unsplash.com/photo-1601924991320-571e90d99713?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
  ],
  "rocky-mountain": [
    "https://images.unsplash.com/photo-1600542158543-1faed2d1c05d?w=1200",
    "https://images.unsplash.com/photo-1516849677043-ef67c9557e16?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1571863533956-01c88e79957e?w=1200",
    "https://images.unsplash.com/photo-1464207687429-7505649dae38?w=1200",
    "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?w=1200",
  ],
  "bryce-canyon": [
    "https://images.unsplash.com/photo-1437240443155-612416af4d5a?w=1200",
    "https://images.unsplash.com/photo-1605640840605-14ac1855827b?w=1200",
    "https://images.unsplash.com/photo-1547036967-23d11aacaee0?w=1200",
    "https://images.unsplash.com/photo-1569330315690-4795c8611e04?w=1200",
    "https://images.unsplash.com/photo-1507608616759-54f48f0af0ee?w=1200",
    "https://images.unsplash.com/photo-1551799090-b143d97880f0?w=1200",
  ],
  "arches": [
    "https://images.unsplash.com/photo-1614484564972-e37b65b5a573?w=1200",
    "https://images.unsplash.com/photo-1644028931417-ab988401495c?w=1200",
    "https://images.unsplash.com/photo-1531219432768-9f540ce91ef3?w=1200",
    "https://images.unsplash.com/photo-1591382386627-349b692688ff?w=1200",
    "https://images.unsplash.com/photo-1569330315690-4795c8611e04?w=1200",
    "https://images.unsplash.com/photo-1571499284374-2ea4b0b8f431?w=1200",
  ],
  "acadia": [
    "https://images.unsplash.com/photo-1609697992606-4d6ec6d6178a?w=1200",
    "https://images.unsplash.com/photo-1666201906234-88e635a2902c?w=1200",
    "https://images.unsplash.com/photo-1508193638397-1c4234db14d8?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=1200",
    "https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=1200",
  ],
  "joshua-tree": [
    "https://images.unsplash.com/photo-1576191919769-40424bb34367?w=1200",
    "https://images.unsplash.com/photo-1624278960904-ab14207e4be9?w=1200",
    "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=1200",
    "https://images.unsplash.com/photo-1542401886-65d6c61db217?w=1200",
    "https://images.unsplash.com/photo-1531804055935-76f44d7c3621?w=1200",
    "https://images.unsplash.com/photo-1580060839134-75a5edca2e99?w=1200",
  ],
  "grand-teton": [
    "https://images.unsplash.com/photo-1546779375-2d49f85efe78?w=1200",
    "https://images.unsplash.com/photo-1730669683024-55a76e99d3ae?w=1200",
    "https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=1200",
    "https://images.unsplash.com/photo-1489549132488-d00b7eee80f1?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1464207687429-7505649dae38?w=1200",
  ],
  "sequoia": [
    "https://images.unsplash.com/photo-1709943517404-635ada23e41d?w=1200",
    "https://images.unsplash.com/photo-1649397129609-3e3862379937?w=1200",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    "https://images.unsplash.com/photo-1542401886-65d6c61db217?w=1200",
    "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
  ],
};

// Helper function to get gallery photos for a park
export function getParkGallery(parkId: string): string[] {
  return PARK_GALLERIES[parkId] || [];
}

// Check if park has gallery photos
export function hasParkGallery(parkId: string): boolean {
  return parkId in PARK_GALLERIES && PARK_GALLERIES[parkId].length > 0;
}
