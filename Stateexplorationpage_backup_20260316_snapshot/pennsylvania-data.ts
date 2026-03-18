import { Park, StateData } from "./states-data";

// Pennsylvania Regions
export const PENNSYLVANIA_REGIONS = {
  NORTH_CENTRAL: "North Central",
  SOUTH_CENTRAL: "South Central",
  NORTHWEST: "Northwest",
  SOUTHWEST: "Southwest",
  NORTHEAST: "Northeast",
  SOUTHEAST: "Southeast"
} as const;

// Pennsylvania Counties (67 counties)
export const PENNSYLVANIA_COUNTIES = [
  "Adams", "Allegheny", "Armstrong", "Beaver", "Bedford", "Berks", "Blair", "Bradford",
  "Bucks", "Butler", "Cambria", "Cameron", "Carbon", "Centre", "Chester", "Clarion",
  "Clearfield", "Clinton", "Columbia", "Crawford", "Cumberland", "Dauphin", "Delaware", "Elk",
  "Erie", "Fayette", "Forest", "Franklin", "Fulton", "Greene", "Huntingdon", "Indiana",
  "Jefferson", "Juniata", "Lackawanna", "Lancaster", "Lawrence", "Lebanon", "Lehigh", "Luzerne",
  "Lycoming", "McKean", "Mercer", "Mifflin", "Monroe", "Montgomery", "Montour", "Northampton",
  "Northumberland", "Perry", "Philadelphia", "Pike", "Potter", "Schuylkill", "Snyder", "Somerset",
  "Sullivan", "Susquehanna", "Tioga", "Union", "Venango", "Warren", "Washington", "Wayne",
  "Westmoreland", "Wyoming", "York"
];

export const pennsylvaniaParks: Park[] = [
  // NORTH CENTRAL - Largest region with most forests
  {
    id: 1,
    name: "Sproul State Forest",
    region: PENNSYLVANIA_REGIONS.NORTH_CENTRAL,
    description: "Massive 280,000-acre wilderness! Excellent remote hiking! Great mountain biking. Good horseback riding. Beautiful wild area. Don't miss wilderness! Perfect for backcountry adventure!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.3,
    longitude: -77.8,
    activities: ["Hiking", "Fishing", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 9,
    type: "State Forest"
  },
  
  {
    id: 2,
    name: "Susquehannock State Forest",
    region: PENNSYLVANIA_REGIONS.NORTH_CENTRAL,
    description: "Huge 265,000-acre forest! Excellent camping facilities. Great mountain biking trails. Good horseback riding. Beautiful wilderness. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.7,
    longitude: -78.1,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Mountain Biking", "Horseback Riding"],
    popularity: 9,
    type: "State Forest",
    phone: "814-435-2550"
  },
  
  {
    id: 3,
    name: "Tiadaghton State Forest",
    region: PENNSYLVANIA_REGIONS.NORTH_CENTRAL,
    description: "Large 215,500-acre forest! Excellent camping. Great hiking trails. Good fishing. Beautiful mountain wilderness. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.4,
    longitude: -77.4,
    activities: ["Camping", "Hiking", "Fishing"],
    popularity: 8,
    type: "State Forest",
    phone: "570-966-1330"
  },
  
  {
    id: 4,
    name: "Elk State Forest",
    region: PENNSYLVANIA_REGIONS.NORTH_CENTRAL,
    description: "Massive 200,000-acre elk country! Excellent elk watching! Great camping. Good hiking. Beautiful mountain forest. Don't miss elk! Perfect for wildlife camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.5,
    longitude: -78.6,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking"],
    popularity: 9,
    type: "State Forest"
  },
  
  {
    id: 5,
    name: "Tioga State Forest",
    region: PENNSYLVANIA_REGIONS.NORTH_CENTRAL,
    description: "Large 160,000-acre forest! Excellent hiking trails. Great horseback riding. Good camping. Beautiful mountain scenery. Perfect for forest recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.8,
    longitude: -77.4,
    activities: ["Hiking", "Picnicking", "Horseback Riding"],
    popularity: 7,
    type: "State Forest",
    phone: "814-435-2550"
  },
  
  {
    id: 6,
    name: "Tuscarora State Forest",
    region: PENNSYLVANIA_REGIONS.NORTH_CENTRAL,
    description: "Large 91,165-acre forest! Excellent hiking trails. Great fishing. Good horseback riding. Beautiful mountain forest. Perfect for forest recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.5,
    longitude: -77.6,
    activities: ["Hiking", "Fishing", "Picnicking", "Horseback Riding"],
    popularity: 7,
    type: "State Forest",
    phone: "717-776-5203"
  },
  
  {
    id: 7,
    name: "Bald Eagle State Forest",
    region: PENNSYLVANIA_REGIONS.NORTH_CENTRAL,
    description: "Beautiful mountain forest! Excellent camping facilities. Great hiking trails. Good wildlife watching. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.0,
    longitude: -77.7,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "814-355-7912"
  },
  
  {
    id: 8,
    name: "Moshannon State Forest",
    region: PENNSYLVANIA_REGIONS.NORTH_CENTRAL,
    description: "Mountain forest! Excellent mountain biking! Great hiking trails. Good horseback riding. Beautiful wilderness. Perfect for biking!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.0,
    longitude: -78.1,
    activities: ["Hiking", "Fishing", "Mountain Biking", "Horseback Riding"],
    popularity: 7,
    type: "State Forest"
  },
  
  {
    id: 9,
    name: "Susquehanna State Forest",
    region: PENNSYLVANIA_REGIONS.NORTH_CENTRAL,
    description: "Beautiful forest! Excellent camping facilities. Great swimming. Good horseback riding. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.2,
    longitude: -78.3,
    activities: ["Hiking", "Swimming", "Picnicking", "Horseback Riding", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "814-544-8844"
  },
  
  {
    id: 10,
    name: "Voneida State Forest Park",
    region: PENNSYLVANIA_REGIONS.NORTH_CENTRAL,
    description: "Mountain forest park! Excellent camping. Great mountain biking. Good hiking. Beautiful wilderness. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.3,
    longitude: -77.5,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Mountain Biking"],
    popularity: 6,
    type: "State Forest",
    phone: "570-966-1330"
  },
  
  {
    id: 11,
    name: "State Forest Lands",
    region: PENNSYLVANIA_REGIONS.NORTH_CENTRAL,
    description: "General forest lands! Good camping. Excellent hiking. Beautiful wilderness. Perfect for forest recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.4,
    longitude: -78.0,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    phone: "724-479-3264"
  },
  
  {
    id: 12,
    name: "Johnson Run State Forest Natural Area",
    region: PENNSYLVANIA_REGIONS.NORTH_CENTRAL,
    description: "Natural area! Good hiking. Excellent wildlife watching. Beautiful pristine forest. Perfect for nature walks!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.1,
    longitude: -78.2,
    activities: ["Hiking", "Picnicking", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest"
  },
  
  {
    id: 13,
    name: "Wayside Memorial State Forest Picnic Area",
    region: PENNSYLVANIA_REGIONS.NORTH_CENTRAL,
    description: "Memorial picnic area! Good hiking. Excellent picnicking. Beautiful forest setting. Perfect for family picnic!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.6,
    longitude: -78.4,
    activities: ["Hiking", "Picnicking", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    phone: "814-647-8777"
  },
  
  {
    id: 14,
    name: "Wykoff Run State Forest Natural Area",
    region: PENNSYLVANIA_REGIONS.NORTH_CENTRAL,
    description: "Small 1,000-acre natural area! Good hiking. Excellent wildlife watching. Beautiful old-growth forest. Perfect for nature walk!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.5,
    longitude: -77.9,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest"
  },
  
  // SOUTH CENTRAL
  {
    id: 15,
    name: "Michaux State Forest",
    region: PENNSYLVANIA_REGIONS.SOUTH_CENTRAL,
    description: "Large 85,000-acre forest! Excellent Appalachian Trail! Great camping. Good horseback riding. Beautiful mountain forest. Don't miss AT! Perfect for trail camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.9,
    longitude: -77.5,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Horseback Riding"],
    popularity: 9,
    type: "State Forest",
    phone: "717-486-8000"
  },
  
  {
    id: 16,
    name: "Rothrock State Forest",
    region: PENNSYLVANIA_REGIONS.SOUTH_CENTRAL,
    description: "Large 35,000-acre forest! Excellent camping facilities. Great hiking trails. Good mountain biking. Beautiful mountain scenery. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.7,
    longitude: -77.8,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking"],
    popularity: 8,
    type: "State Forest",
    phone: "570-586-0145"
  },
  
  {
    id: 17,
    name: "Gallitzin State Forest",
    region: PENNSYLVANIA_REGIONS.SOUTH_CENTRAL,
    description: "15,336-acre forest! Excellent camping. Great hiking trails. Good fishing. Beautiful mountain forest. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.5,
    longitude: -78.6,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking"],
    popularity: 7,
    type: "State Forest",
    phone: "814-733-4380"
  },
  
  {
    id: 18,
    name: "Haldeman State Forest",
    region: PENNSYLVANIA_REGIONS.SOUTH_CENTRAL,
    description: "7,000-acre forest! Good camping. Excellent hiking. Beautiful wildlife watching. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.6,
    longitude: -76.7,
    activities: ["Camping", "Hiking", "Boating", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "717-444-3200"
  },
  
  {
    id: 19,
    name: "Mont Alto State Forest",
    region: PENNSYLVANIA_REGIONS.SOUTH_CENTRAL,
    description: "Historic forest! Excellent camping. Good hiking trails. Beautiful mountain setting. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.8,
    longitude: -77.6,
    activities: ["Camping", "Hiking", "Fishing"],
    popularity: 6,
    type: "State Forest",
    phone: "717-642-5713"
  },
  
  // SOUTHWEST
  {
    id: 20,
    name: "Forbes State Forest",
    region: PENNSYLVANIA_REGIONS.SOUTHWEST,
    description: "Large 50,000-acre forest! Excellent camping facilities. Great hiking trails. Good fishing. Beautiful mountain wilderness. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.0,
    longitude: -79.2,
    activities: ["Hiking", "Fishing", "Picnicking", "Wildlife Watching"],
    popularity: 8,
    type: "State Forest",
    phone: "814-926-4636"
  },
  
  // NORTHWEST
  {
    id: 21,
    name: "Kittanning State Forest",
    region: PENNSYLVANIA_REGIONS.NORTHWEST,
    description: "9,089-acre forest! Excellent camping. Great hiking trails. Good wildlife watching. Beautiful forest. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.9,
    longitude: -79.4,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "814-927-8125"
  },
  
  {
    id: 22,
    name: "Babcock State Forest",
    region: PENNSYLVANIA_REGIONS.NORTHWEST,
    description: "Beautiful forest! Good camping. Excellent hiking. Great picnicking. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.8,
    longitude: -79.8,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking"],
    popularity: 6,
    type: "State Forest",
    phone: "814-733-4380"
  },
  
  // NORTHEAST
  {
    id: 23,
    name: "Wyoming State Forest",
    region: PENNSYLVANIA_REGIONS.NORTHEAST,
    description: "21,000-acre forest! Excellent camping facilities. Great hiking trails. Good swimming. Beautiful mountain forest. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.3,
    longitude: -76.2,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Forest"
  },
  
  {
    id: 24,
    name: "Weiser State Forest",
    region: PENNSYLVANIA_REGIONS.NORTHEAST,
    description: "17,961-acre forest! Excellent mountain biking! Great camping. Good hiking. Beautiful mountain forest. Perfect for biking camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.7,
    longitude: -76.6,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Mountain Biking"],
    popularity: 7,
    type: "State Forest",
    phone: "570-366-8866"
  },
  
  // SOUTHEAST
  {
    id: 25,
    name: "Delaware State Forest",
    region: PENNSYLVANIA_REGIONS.SOUTHEAST,
    description: "2,845-acre Pocono forest! Good camping. Excellent hiking. Great fishing. Beautiful mountain setting. Perfect for Pocono camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.3,
    longitude: -75.0,
    activities: ["Hiking", "Fishing", "Boating"],
    popularity: 7,
    type: "State Forest",
    phone: "570-424-2587"
  },
  
  {
    id: 26,
    name: "Buchanan State Forest",
    region: PENNSYLVANIA_REGIONS.SOUTHEAST,
    description: "1,400-acre forest! Good hiking trails. Excellent horseback riding. Great fishing. Beautiful forest. Perfect for forest recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.7866,
    longitude: -78.5513,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 6,
    type: "State Forest",
    phone: "888-727-2757"
  },
  
  // STATE PARKS - Premier Parks
  {
    id: 27,
    name: "Presque Isle State Park",
    region: PENNSYLVANIA_REGIONS.NORTHWEST,
    description: "Iconic Erie peninsula! Excellent Lake Erie beaches! Great birding - important migration stop. Good swimming. Beautiful lighthouse. Don't miss beaches! Perfect for beach day!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 42.15,
    longitude: -80.1,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 10,
    type: "State Park",
    phone: "814-833-7424"
  },
  
  {
    id: 28,
    name: "Ricketts Glen State Park",
    region: PENNSYLVANIA_REGIONS.NORTHEAST,
    description: "Spectacular 13,050-acre park! Excellent Falls Trail - 22 waterfalls! Great camping facilities. Beautiful old-growth forest. Don't miss waterfalls! Perfect for waterfall hiking!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.33,
    longitude: -76.28,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 10,
    type: "State Park",
    phone: "570-477-5675"
  },
  
  {
    id: 29,
    name: "Ohiopyle State Park",
    region: PENNSYLVANIA_REGIONS.SOUTHWEST,
    description: "Huge 19,052-acre adventure park! Excellent white-water rafting! Great mountain biking. Good camping. Beautiful Youghiogheny River. Don't miss rapids! Perfect for adventure!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.87,
    longitude: -79.49,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Mountain Biking"],
    popularity: 10,
    type: "State Park",
    phone: "724-329-8591"
  },
  
  {
    id: 30,
    name: "Cook Forest State Park",
    region: PENNSYLVANIA_REGIONS.NORTHWEST,
    description: "Ancient forest park! Excellent old-growth trees! Great camping facilities. Good mountain biking. Beautiful Clarion River. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.33,
    longitude: -79.22,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Mountain Biking", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "814-744-8407"
  },
  
  {
    id: 31,
    name: "Moraine State Park",
    region: PENNSYLVANIA_REGIONS.NORTHWEST,
    description: "Large Lake Arthur park! Excellent sailing. Great mountain biking trails. Good camping. Beautiful 3,225-acre lake. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.95,
    longitude: -80.1,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 9,
    type: "State Park",
    phone: "724-368-8811"
  },
  
  {
    id: 32,
    name: "Cherry Springs State Park",
    region: PENNSYLVANIA_REGIONS.NORTHEAST,
    description: "Dark Sky Park! Excellent stargazing - internationally recognized! Great astronomy programs. Beautiful night sky. Don't miss stars! Perfect for stargazing!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.66,
    longitude: -77.82,
    activities: ["Camping", "Hiking", "Fishing", "Mountain Biking"],
    popularity: 9,
    type: "State Park",
    phone: "814-435-5010"
  },
  
  {
    id: 33,
    name: "Promised Land State Park",
    region: PENNSYLVANIA_REGIONS.NORTHEAST,
    description: "Beautiful 3,000-acre Pocono park! Excellent camping facilities. Great mountain biking. Good fishing. Beautiful lakes. Perfect for Pocono camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.33,
    longitude: -75.22,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 9,
    type: "State Park",
    phone: "570-676-3428"
  },
  
  {
    id: 34,
    name: "Hickory Run State Park",
    region: PENNSYLVANIA_REGIONS.NORTHEAST,
    description: "Unique Boulder Field park! Excellent National Natural Landmark! Great hiking trails. Good camping. Beautiful geological wonder. Don't miss Boulder Field! Perfect for unique camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.99,
    longitude: -75.68,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "570-443-0400"
  },
  
  {
    id: 35,
    name: "French Creek State Park",
    region: PENNSYLVANIA_REGIONS.SOUTHEAST,
    description: "Large park near Philadelphia! Excellent camping facilities. Great hiking trails. Good fishing. Beautiful Hopewell Furnace nearby. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.22,
    longitude: -75.78,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "610-582-9680"
  },
  
  {
    id: 36,
    name: "Pymatuning State Park",
    region: PENNSYLVANIA_REGIONS.NORTHWEST,
    description: "Huge 725-acre park! Excellent fishing. Great camping. Good boating. Famous spillway - fish walk on ducks! Perfect for fishing camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.52,
    longitude: -80.48,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "724-932-3141"
  },
  
  {
    id: 37,
    name: "Codorus State Park",
    region: PENNSYLVANIA_REGIONS.SOUTHEAST,
    description: "Large lake park! Excellent camping facilities. Great fishing. Good mountain biking. Beautiful Lake Marburg. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.8,
    longitude: -76.85,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 8,
    type: "State Park",
    phone: "717-637-2816"
  },
  
  {
    id: 38,
    name: "Sinnemahoning State Park",
    region: PENNSYLVANIA_REGIONS.NORTHEAST,
    description: "Massive 200,000-acre park! Excellent elk watching! Great camping. Good fishing. Beautiful wilderness. Perfect for elk camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.38,
    longitude: -78.1,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "814-647-8401"
  },
  
  {
    id: 39,
    name: "Worlds End State Park",
    region: PENNSYLVANIA_REGIONS.NORTHEAST,
    description: "Stunning gorge park! Excellent hiking trails. Great camping facilities. Beautiful Loyalsock Creek. Perfect for gorge camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.47,
    longitude: -76.58,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "570-924-3287"
  },
  
  {
    id: 40,
    name: "Bald Eagle State Park",
    region: PENNSYLVANIA_REGIONS.NORTHWEST,
    description: "Large lake park! Excellent camping facilities. Great bald eagle watching! Good horseback riding. Beautiful Foster Joseph Sayers Lake. Perfect for eagle watching!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.0328,
    longitude: -77.6499,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "814-625-2775"
  },
  
  {
    id: 41,
    name: "Gifford Pinchot State Park",
    region: PENNSYLVANIA_REGIONS.SOUTH_CENTRAL,
    description: "Popular lake park! Excellent camping facilities. Great mountain biking. Good fishing. Beautiful Pinchot Lake. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.05,
    longitude: -76.88,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 7,
    type: "State Park",
    phone: "717-432-5011"
  },
  
  {
    id: 42,
    name: "Caledonia State Park",
    region: PENNSYLVANIA_REGIONS.SOUTHEAST,
    description: "Historic park on Appalachian Trail! Excellent camping. Great swimming. Good mountain biking. Beautiful Thaddeus Stevens Museum. Perfect for AT camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.91,
    longitude: -77.47,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 7,
    type: "State Park",
    phone: "717-352-2161"
  },
  
  {
    id: 43,
    name: "Pine Grove Furnace State Park",
    region: PENNSYLVANIA_REGIONS.SOUTH_CENTRAL,
    description: "Historic furnace park! Excellent Appalachian Trail stop. Great swimming. Good camping. Famous half-gallon ice cream challenge! Perfect for AT hikers!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.04,
    longitude: -77.31,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "717-486-7174"
  },
  
  {
    id: 44,
    name: "Raccoon Creek State Park",
    region: PENNSYLVANIA_REGIONS.SOUTHWEST,
    description: "Large park near Pittsburgh! Excellent camping facilities. Great hiking trails. Good fishing. Beautiful Raccoon Lake. Perfect for Pittsburgh area camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.52,
    longitude: -80.43,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "724-899-2200"
  },
  
  {
    id: 45,
    name: "Keystone State Park",
    region: PENNSYLVANIA_REGIONS.SOUTHWEST,
    description: "Popular lake park! Excellent camping facilities. Great mountain biking. Good fishing. Beautiful Keystone Lake. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.37,
    longitude: -79.13,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 7,
    type: "State Park",
    phone: "724-668-2939"
  },
  
  {
    id: 46,
    name: "Laurel Hill State Park",
    region: PENNSYLVANIA_REGIONS.SOUTHWEST,
    description: "Beautiful 1,352-acre park! Excellent camping facilities. Great hiking trails. Good fishing. Beautiful Laurel Hill Lake. Perfect for mountain camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.07,
    longitude: -79.24,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "814-445-7725"
  },
  
  {
    id: 47,
    name: "Blue Knob State Park",
    region: PENNSYLVANIA_REGIONS.SOUTHWEST,
    description: "High elevation 5,874-acre park! Excellent mountain views. Great mountain biking. Good camping. Beautiful Blue Knob summit. Perfect for mountain camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.2891,
    longitude: -78.5898,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "814-276-3576"
  },
  
  {
    id: 48,
    name: "Prince Gallitzin State Park",
    region: PENNSYLVANIA_REGIONS.SOUTH_CENTRAL,
    description: "Large lake park! Excellent camping facilities. Great mountain biking. Good fishing. Beautiful Glendale Lake. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.62,
    longitude: -78.55,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 7,
    type: "State Park",
    phone: "814-674-1000"
  },
  
  {
    id: 49,
    name: "Shawnee State Park",
    region: PENNSYLVANIA_REGIONS.SOUTH_CENTRAL,
    description: "Large 3,983-acre park! Excellent camping facilities. Great mountain biking. Good fishing. Beautiful Shawnee Lake. Perfect for mountain camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.02,
    longitude: -78.68,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 7,
    type: "State Park",
    phone: "814-733-4218"
  },
  
  {
    id: 50,
    name: "Leonard Harrison State Park",
    region: PENNSYLVANIA_REGIONS.NORTHEAST,
    description: "Pennsylvania Grand Canyon! Excellent canyon views! Great hiking trails. Good camping. Beautiful overlooks. Don't miss views! Perfect for canyon camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.7,
    longitude: -77.45,
    activities: ["Camping", "Hiking", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "570-724-3061"
  },
  
  {
    id: 51,
    name: "Colton Point State Park",
    region: PENNSYLVANIA_REGIONS.NORTHEAST,
    description: "Pennsylvania Grand Canyon south rim! Excellent canyon views! Great hiking trails. Beautiful wilderness. Perfect for canyon camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.7065,
    longitude: -77.4665,
    activities: ["Hiking", "Fishing", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "570-724-3061"
  }
];

export const pennsylvaniaData: StateData = {
  name: "Pennsylvania",
  code: "PA",
  images: [
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200"
  ],
  parks: pennsylvaniaParks,
  bounds: [[39.7, -80.5], [42.3, -74.7]],
  description: "Explore Pennsylvania's 51 state parks and forests! Discover Ricketts Glen (22 waterfalls!), Presque Isle (Lake Erie!), Ohiopyle (white-water rafting!), Cherry Springs (dark sky!), Cook Forest (ancient trees!), Sproul (280,000 acres!). Mountains to lakes!",
  regions: Object.values(PENNSYLVANIA_REGIONS),
  counties: PENNSYLVANIA_COUNTIES
};