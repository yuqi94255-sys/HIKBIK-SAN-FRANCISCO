// Wyoming 州立公园完整数据
// 包含 12 个州立公园和休闲区

import { StateData, Park } from "./states-data";

export const wyomingData: StateData = {
  name: "Wyoming",
  code: "WY",
  description: "Discover Wyoming's rugged beauty from the peaks of the Rockies to wide-open prairies. Experience world-class state parks featuring pristine reservoirs, natural hot springs, and abundant wildlife in America's least populated state.",
  bounds: [[41.0, -111.1], [45.0, -104.0]],
  regions: [
    "Northwest",
    "Northeast", 
    "Central",
    "Southwest",
    "Southeast"
  ],
  counties: [
    "Albany", "Big Horn", "Campbell", "Carbon", "Converse", "Crook", "Fremont",
    "Goshen", "Hot Springs", "Johnson", "Laramie", "Lincoln", "Natrona",
    "Niobrara", "Park", "Platte", "Sheridan", "Sublette", "Sweetwater",
    "Teton", "Uinta", "Washakie", "Weston"
  ],
  images: [
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
    "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800"
  ],
  parks: [
    {
      id: 1,
      name: "Bear River State Park",
      description: "Scenic 324-acre park in Evanston along the Bear River. Features diverse wildlife including bison and elk herds, excellent fishing, and beautiful riverside trails. Popular visitor center showcasing Wyoming's natural history.",
      image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
      activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Wildlife Watching"],
      latitude: 41.2641,
      longitude: -110.9418,
      popularity: 7,
      hours: "Open daily: 6:00 AM - 10:00 PM",
      entryFee: "Free (resident), $7 per vehicle (non-resident)",
      phone: "(307) 789-6547"
    },
    {
      id: 2,
      name: "Boysen State Reservoir",
      description: "Large 19,800-acre reservoir offering exceptional fishing and water recreation. Located in the Wind River Canyon with stunning red rock formations. Popular for boating, camping, and windsurfing.",
      image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
      activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking"],
      latitude: 43.3753,
      longitude: -108.1784,
      popularity: 8,
      hours: "Open year-round, 24 hours",
      entryFee: "Free (resident), $7 per vehicle (non-resident)",
      phone: "(307) 876-2796"
    },
    {
      id: 3,
      name: "Buffalo Bill State Park",
      description: "Stunning park on Buffalo Bill Reservoir near Cody, featuring spectacular views of the Absaroka Mountains. Named after legendary Buffalo Bill Cody. Excellent boating, fishing, and camping with easy access to Yellowstone.",
      image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
      activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking"],
      latitude: 44.503,
      longitude: -109.2443,
      popularity: 9,
      hours: "Open year-round, 24 hours",
      entryFee: "Free (resident), $7 per vehicle (non-resident)",
      phone: "(307) 587-9227"
    },
    {
      id: 4,
      name: "Curt Gowdy State Park",
      description: "Outdoor paradise between Cheyenne and Laramie featuring three reservoirs, 35 miles of trails, and stunning granite rock formations. Named after legendary sportscaster Curt Gowdy. Premier destination for mountain biking, hiking, and fishing.",
      image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
      activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Horseback Riding", "Wildlife Watching"],
      latitude: 41.1695,
      longitude: -105.228,
      popularity: 9,
      hours: "Open year-round, 24 hours",
      entryFee: "Free (resident), $7 per vehicle (non-resident)",
      phone: "(307) 632-7946"
    },
    {
      id: 5,
      name: "Edness Kimball Wilkins State Park",
      description: "Peaceful park on the North Platte River in Casper offering excellent fishing, bird watching, and water recreation. Features beautiful riverside setting with abundant wildlife. Popular for kayaking and paddleboarding.",
      image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
      activities: ["Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
      latitude: 42.851,
      longitude: -106.1813,
      popularity: 6,
      hours: "Open daily: 6:00 AM - 10:00 PM",
      entryFee: "Free (resident), $7 per vehicle (non-resident)",
      phone: "(307) 577-5150"
    },
    {
      id: 6,
      name: "Glendo State Park",
      description: "Popular 12,500-acre reservoir park offering sandy beaches, excellent sailing, and diverse camping options. Features miles of shoreline, multiple campgrounds, and outstanding fishing for walleye and smallmouth bass.",
      image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
      activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
      latitude: 42.5015,
      longitude: -105.0192,
      popularity: 8,
      hours: "Open year-round, 24 hours",
      entryFee: "Free (resident), $7 per vehicle (non-resident)",
      phone: "(307) 735-4433"
    },
    {
      id: 7,
      name: "Guernsey State Park",
      description: "Historic park on Guernsey Reservoir featuring CCC-built structures from the 1930s. Offers excellent camping, fishing, and hiking along scenic limestone cliffs. Rich in Oregon Trail history with nearby Register Cliff.",
      image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
      activities: ["Hiking", "Fishing", "Picnicking"],
      latitude: 42.2564,
      longitude: -104.7394,
      popularity: 7,
      hours: "Open year-round, 24 hours",
      entryFee: "Free (resident), $7 per vehicle (non-resident)",
      phone: "(307) 836-2334"
    },
    {
      id: 8,
      name: "Hawk Springs State Recreation Area",
      description: "Quiet prairie reservoir popular for fishing and water recreation. Features peaceful camping, bird watching, and excellent warm-water fishing. Ideal for those seeking solitude and natural beauty.",
      image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
      activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Wildlife Watching"],
      latitude: 41.7129,
      longitude: -104.1958,
      popularity: 6,
      hours: "Open year-round, 24 hours",
      entryFee: "Free (resident), $7 per vehicle (non-resident)",
      phone: "(307) 836-2334"
    },
    {
      id: 9,
      name: "Hot Springs State Park",
      description: "World's largest mineral hot springs in Thermopolis! Features free public bathhouse with natural 104°F mineral water, stunning travertine terraces, and bison herd. One of Wyoming's most unique parks.",
      image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
      activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
      latitude: 43.6505,
      longitude: -108.2049,
      popularity: 10,
      hours: "Open year-round, 24 hours",
      entryFee: "Free",
      phone: "(307) 864-2176"
    },
    {
      id: 10,
      name: "Keyhole State Park",
      description: "Scenic 14,720-acre reservoir in the Black Hills region offering diverse recreation. Features marina, sandy beaches, and excellent fishing for walleye. Popular for camping, boating, and viewing prairie wildlife.",
      image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
      activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking", "Wildlife Watching"],
      latitude: 44.3609,
      longitude: -104.7653,
      popularity: 8,
      hours: "Open year-round, 24 hours",
      entryFee: "Free (resident), $7 per vehicle (non-resident)",
      phone: "(307) 756-3596"
    },
    {
      id: 11,
      name: "Seminoe State Park",
      description: "Remote wilderness reservoir surrounded by rugged red rock canyon. Outstanding fishing for trophy trout and walleye. Features spectacular scenery, challenging access, and true backcountry experience.",
      image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
      activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking"],
      latitude: 42.1362,
      longitude: -106.8943,
      popularity: 7,
      hours: "Open year-round, 24 hours",
      entryFee: "Free (resident), $7 per vehicle (non-resident)",
      phone: "(307) 320-3013"
    },
    {
      id: 12,
      name: "Sinks Canyon State Park",
      description: "Geological wonder where the Popo Agie River disappears into a cave (The Sinks) and emerges a quarter mile downstream (The Rise). Features visitor center, rock climbing, trout fishing, and scenic canyon trails.",
      image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
      activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Wildlife Watching"],
      latitude: 42.747,
      longitude: -108.8132,
      popularity: 9,
      hours: "Open year-round, 24 hours",
      entryFee: "Free (resident), $7 per vehicle (non-resident)",
      phone: "(307) 332-6333"
    }
  ]
};
