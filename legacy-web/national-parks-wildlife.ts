export interface WildlifeAnimal {
  name: string;
  icon: string;
  category: 'Mammal' | 'Bird' | 'Reptile' | 'Fish' | 'Amphibian';
  commonlySeen: boolean;
}

export interface ParkWildlife {
  parkId: string;
  animals: WildlifeAnimal[];
  bestViewingTimes: string[];
  safetyTips: string[];
}

// Wildlife data for each national park
export const PARK_WILDLIFE: ParkWildlife[] = [
  // California Parks
  {
    parkId: 'yosemite',
    animals: [
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Coyote', icon: '🐺', category: 'Mammal', commonlySeen: true },
      { name: 'Bald Eagle', icon: '🦅', category: 'Bird', commonlySeen: false },
      { name: 'Mountain Lion', icon: '🐆', category: 'Mammal', commonlySeen: false },
      { name: 'Bobcat', icon: '🐱', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Early morning', 'Dusk'],
    safetyTips: ['Store food properly', 'Keep safe distance from bears', 'Never feed wildlife'],
  },
  {
    parkId: 'sequoia',
    animals: [
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Marmot', icon: '🦫', category: 'Mammal', commonlySeen: true },
      { name: 'Gray Fox', icon: '🦊', category: 'Mammal', commonlySeen: false },
      { name: 'Mountain Chickadee', icon: '🐦', category: 'Bird', commonlySeen: true },
      { name: 'Sierra Newt', icon: '🦎', category: 'Amphibian', commonlySeen: false },
    ],
    bestViewingTimes: ['Dawn', 'Dusk'],
    safetyTips: ['Bear-proof containers required', 'Stay on designated trails'],
  },
  {
    parkId: 'kings-canyon',
    animals: [
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Golden Trout', icon: '🐟', category: 'Fish', commonlySeen: true },
      { name: 'Peregrine Falcon', icon: '🦅', category: 'Bird', commonlySeen: false },
    ],
    bestViewingTimes: ['Morning', 'Evening'],
    safetyTips: ['Secure all food items', 'Watch for wildlife on roads'],
  },
  {
    parkId: 'death-valley',
    animals: [
      { name: 'Desert Bighorn Sheep', icon: '🐏', category: 'Mammal', commonlySeen: false },
      { name: 'Coyote', icon: '🐺', category: 'Mammal', commonlySeen: true },
      { name: 'Roadrunner', icon: '🐦', category: 'Bird', commonlySeen: true },
      { name: 'Sidewinder Rattlesnake', icon: '🐍', category: 'Reptile', commonlySeen: false },
      { name: 'Kit Fox', icon: '🦊', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Dawn', 'Dusk', 'Night'],
    safetyTips: ['Watch for snakes on trails', 'Stay hydrated', 'Observe from distance'],
  },
  {
    parkId: 'joshua-tree',
    animals: [
      { name: 'Desert Tortoise', icon: '🐢', category: 'Reptile', commonlySeen: false },
      { name: 'Bighorn Sheep', icon: '🐏', category: 'Mammal', commonlySeen: false },
      { name: 'Coyote', icon: '🐺', category: 'Mammal', commonlySeen: true },
      { name: 'Roadrunner', icon: '🐦', category: 'Bird', commonlySeen: true },
      { name: 'Chuckwalla', icon: '🦎', category: 'Reptile', commonlySeen: true },
    ],
    bestViewingTimes: ['Early morning', 'Late afternoon'],
    safetyTips: ['Never touch tortoises', 'Check shoes before wearing', 'Stay on trails'],
  },
  {
    parkId: 'channel-islands',
    animals: [
      { name: 'Island Fox', icon: '🦊', category: 'Mammal', commonlySeen: true },
      { name: 'Sea Lion', icon: '🦭', category: 'Mammal', commonlySeen: true },
      { name: 'Blue Whale', icon: '🐋', category: 'Mammal', commonlySeen: false },
      { name: 'Pelican', icon: '🦅', category: 'Bird', commonlySeen: true },
      { name: 'Dolphin', icon: '🐬', category: 'Mammal', commonlySeen: true },
    ],
    bestViewingTimes: ['Morning boat tours', 'Afternoon coastline'],
    safetyTips: ['Maintain distance from marine life', 'Follow boat safety guidelines'],
  },
  {
    parkId: 'redwood',
    animals: [
      { name: 'Roosevelt Elk', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: false },
      { name: 'Gray Whale', icon: '🐋', category: 'Mammal', commonlySeen: false },
      { name: 'Stellar Jay', icon: '🐦', category: 'Bird', commonlySeen: true },
      { name: 'Banana Slug', icon: '🐌', category: 'Amphibian', commonlySeen: true },
    ],
    bestViewingTimes: ['Morning', 'Evening'],
    safetyTips: ['Keep distance from elk', 'Stay quiet in forests', 'Use binoculars'],
  },
  {
    parkId: 'lassen-volcanic',
    animals: [
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Golden Eagle', icon: '🦅', category: 'Bird', commonlySeen: false },
      { name: 'Pine Marten', icon: '🦡', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Dawn', 'Dusk'],
    safetyTips: ['Store food properly', 'Watch for wildlife near thermal areas'],
  },
  {
    parkId: 'pinnacles',
    animals: [
      { name: 'California Condor', icon: '🦅', category: 'Bird', commonlySeen: true },
      { name: 'Bobcat', icon: '🐱', category: 'Mammal', commonlySeen: false },
      { name: 'Gray Fox', icon: '🦊', category: 'Mammal', commonlySeen: true },
      { name: 'Tarantula', icon: '🕷️', category: 'Reptile', commonlySeen: false },
    ],
    bestViewingTimes: ['Early morning', 'Late afternoon'],
    safetyTips: ['Look up for condors', 'Watch step on trails', 'Stay hydrated'],
  },

  // Arizona Parks
  {
    parkId: 'grand-canyon',
    animals: [
      { name: 'California Condor', icon: '🦅', category: 'Bird', commonlySeen: true },
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Elk', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Bighorn Sheep', icon: '🐏', category: 'Mammal', commonlySeen: false },
      { name: 'Mountain Lion', icon: '🐆', category: 'Mammal', commonlySeen: false },
      { name: 'Rattlesnake', icon: '🐍', category: 'Reptile', commonlySeen: false },
    ],
    bestViewingTimes: ['Early morning', 'Evening'],
    safetyTips: ['Keep safe distance', 'Watch for rattlesnakes', 'Stay on trails'],
  },
  {
    parkId: 'saguaro',
    animals: [
      { name: 'Gila Monster', icon: '🦎', category: 'Reptile', commonlySeen: false },
      { name: 'Coyote', icon: '🐺', category: 'Mammal', commonlySeen: true },
      { name: 'Roadrunner', icon: '🐦', category: 'Bird', commonlySeen: true },
      { name: 'Javelina', icon: '🐗', category: 'Mammal', commonlySeen: true },
      { name: 'Rattlesnake', icon: '🐍', category: 'Reptile', commonlySeen: false },
    ],
    bestViewingTimes: ['Dawn', 'Dusk'],
    safetyTips: ['Watch for snakes and lizards', 'Keep distance from javelinas'],
  },
  {
    parkId: 'petrified-forest',
    animals: [
      { name: 'Pronghorn', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Coyote', icon: '🐺', category: 'Mammal', commonlySeen: true },
      { name: 'Golden Eagle', icon: '🦅', category: 'Bird', commonlySeen: false },
      { name: 'Collared Lizard', icon: '🦎', category: 'Reptile', commonlySeen: true },
    ],
    bestViewingTimes: ['Morning', 'Late afternoon'],
    safetyTips: ['Stay in vehicle for best viewing', 'Bring binoculars'],
  },

  // Utah Parks
  {
    parkId: 'zion',
    animals: [
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Bighorn Sheep', icon: '🐏', category: 'Mammal', commonlySeen: false },
      { name: 'California Condor', icon: '🦅', category: 'Bird', commonlySeen: false },
      { name: 'Mountain Lion', icon: '🐆', category: 'Mammal', commonlySeen: false },
      { name: 'Golden Eagle', icon: '🦅', category: 'Bird', commonlySeen: false },
    ],
    bestViewingTimes: ['Early morning', 'Dusk'],
    safetyTips: ['Watch for wildlife on shuttle', 'Keep safe distance'],
  },
  {
    parkId: 'bryce-canyon',
    animals:[
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Pronghorn', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Utah Prairie Dog', icon: '🦫', category: 'Mammal', commonlySeen: true },
      { name: 'Golden Eagle', icon: '🦅', category: 'Bird', commonlySeen: false },
      { name: 'Mountain Lion', icon: '🐆', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Dawn', 'Evening'],
    safetyTips: ['Do not feed prairie dogs', 'Stay on designated paths'],
  },
  {
    parkId: 'arches',
    animals: [
      { name: 'Bighorn Sheep', icon: '🐏', category: 'Mammal', commonlySeen: false },
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Kangaroo Rat', icon: '🐭', category: 'Mammal', commonlySeen: false },
      { name: 'Raven', icon: '🐦', category: 'Bird', commonlySeen: true },
      { name: 'Collared Lizard', icon: '🦎', category: 'Reptile', commonlySeen: true },
    ],
    bestViewingTimes: ['Early morning', 'Late afternoon'],
    safetyTips: ['Watch for snakes and lizards', 'Stay hydrated'],
  },
  {
    parkId: 'canyonlands',
    animals: [
      { name: 'Bighorn Sheep', icon: '🐏', category: 'Mammal', commonlySeen: false },
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Coyote', icon: '🐺', category: 'Mammal', commonlySeen: true },
      { name: 'Golden Eagle', icon: '🦅', category: 'Bird', commonlySeen: false },
      { name: 'Midget Faded Rattlesnake', icon: '🐍', category: 'Reptile', commonlySeen: false },
    ],
    bestViewingTimes: ['Dawn', 'Dusk'],
    safetyTips: ['Observe from overlooks', 'Carry binoculars'],
  },
  {
    parkId: 'capitol-reef',
    animals: [
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Desert Bighorn Sheep', icon: '🐏', category: 'Mammal', commonlySeen: false },
      { name: 'Mountain Lion', icon: '🐆', category: 'Mammal', commonlySeen: false },
      { name: 'Golden Eagle', icon: '🦅', category: 'Bird', commonlySeen: false },
    ],
    bestViewingTimes: ['Morning', 'Evening'],
    safetyTips: ['Stay in vehicle for best viewing', 'Keep safe distance'],
  },

  // Wyoming Parks
  {
    parkId: 'yellowstone',
    animals: [
      { name: 'Bison', icon: '🦬', category: 'Mammal', commonlySeen: true },
      { name: 'Grizzly Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Wolf', icon: '🐺', category: 'Mammal', commonlySeen: false },
      { name: 'Elk', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Bald Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
      { name: 'Moose', icon: '🫎', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Dawn', 'Dusk', 'Early morning'],
    safetyTips: ['Stay 100 yards from bears/wolves', 'Stay 25 yards from bison/elk', 'Never approach wildlife'],
  },
  {
    parkId: 'grand-teton',
    animals: [
      { name: 'Moose', icon: '🫎', category: 'Mammal', commonlySeen: true },
      { name: 'Grizzly Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Elk', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Bald Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
      { name: 'Pronghorn', icon: '🦌', category: 'Mammal', commonlySeen: true },
    ],
    bestViewingTimes: ['Early morning', 'Evening'],
    safetyTips: ['Carry bear spray', 'Make noise on trails', 'Keep safe distance'],
  },

  // Montana Parks
  {
    parkId: 'glacier',
    animals: [
      { name: 'Grizzly Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Mountain Goat', icon: '🐐', category: 'Mammal', commonlySeen: true },
      { name: 'Bighorn Sheep', icon: '🐏', category: 'Mammal', commonlySeen: true },
      { name: 'Moose', icon: '🫎', category: 'Mammal', commonlySeen: false },
      { name: 'Gray Wolf', icon: '🐺', category: 'Mammal', commonlySeen: false },
      { name: 'Golden Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
    ],
    bestViewingTimes: ['Dawn', 'Dusk'],
    safetyTips: ['Carry bear spray always', 'Hike in groups', 'Make noise on trails'],
  },

  // Colorado Parks
  {
    parkId: 'rocky-mountain',
    animals: [
      { name: 'Elk', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Bighorn Sheep', icon: '🐏', category: 'Mammal', commonlySeen: true },
      { name: 'Moose', icon: '🫎', category: 'Mammal', commonlySeen: true },
      { name: 'Marmot', icon: '🦫', category: 'Mammal', commonlySeen: true },
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: false },
      { name: 'Mountain Lion', icon: '🐆', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Dawn', 'Dusk', 'Fall rutting season'],
    safetyTips: ['Keep 25 yards from elk', 'Store food properly', 'Watch for elk on roads during rut'],
  },
  {
    parkId: 'black-canyon',
    animals: [
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Elk', icon: '🦌', category: 'Mammal', commonlySeen: false },
      { name: 'Peregrine Falcon', icon: '🦅', category: 'Bird', commonlySeen: true },
      { name: 'Golden Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
    ],
    bestViewingTimes: ['Morning', 'Evening'],
    safetyTips: ['Watch for raptors at overlooks', 'Stay on trails'],
  },
  {
    parkId: 'great-sand-dunes',
    animals: [
      { name: 'Pronghorn', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Elk', icon: '🦌', category: 'Mammal', commonlySeen: false },
      { name: 'Bison', icon: '🦬', category: 'Mammal', commonlySeen: false },
      { name: 'Kangaroo Rat', icon: '🐭', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Early morning', 'Dusk'],
    safetyTips: ['Watch for wildlife in grasslands', 'Keep distance'],
  },
  {
    parkId: 'mesa-verde',
    animals: [
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Elk', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Turkey', icon: '🦃', category: 'Bird', commonlySeen: true },
      { name: 'Mountain Lion', icon: '🐆', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Morning', 'Evening'],
    safetyTips: ['Stay on designated paths', 'Watch for wildlife near ruins'],
  },

  // Alaska Parks
  {
    parkId: 'denali',
    animals: [
      { name: 'Grizzly Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Moose', icon: '🫎', category: 'Mammal', commonlySeen: true },
      { name: 'Caribou', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Wolf', icon: '🐺', category: 'Mammal', commonlySeen: true },
      { name: 'Dall Sheep', icon: '🐏', category: 'Mammal', commonlySeen: true },
      { name: 'Golden Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
    ],
    bestViewingTimes: ['Bus tours', 'Early morning', 'Evening'],
    safetyTips: ['Stay on bus for wildlife viewing', 'Carry bear spray', 'Keep safe distance'],
  },
  {
    parkId: 'kenai-fjords',
    animals: [
      { name: 'Sea Otter', icon: '🦦', category: 'Mammal', commonlySeen: true },
      { name: 'Humpback Whale', icon: '🐋', category: 'Mammal', commonlySeen: true },
      { name: 'Orca', icon: '🐋', category: 'Mammal', commonlySeen: true },
      { name: 'Sea Lion', icon: '🦭', category: 'Mammal', commonlySeen: true },
      { name: 'Puffin', icon: '🐦', category: 'Bird', commonlySeen: true },
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Boat tours', 'Summer months'],
    safetyTips: ['Book boat tours for best viewing', 'Respect marine life distance'],
  },
  {
    parkId: 'glacier-bay',
    animals: [
      { name: 'Humpback Whale', icon: '🐋', category: 'Mammal', commonlySeen: true },
      { name: 'Sea Otter', icon: '🦦', category: 'Mammal', commonlySeen: true },
      { name: 'Brown Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Mountain Goat', icon: '🐐', category: 'Mammal', commonlySeen: true },
      { name: 'Bald Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
      { name: 'Harbor Seal', icon: '🦭', category: 'Mammal', commonlySeen: true },
    ],
    bestViewingTimes: ['Cruise tours', 'Summer season'],
    safetyTips: ['Use boat tours for wildlife', 'Keep safe distance from bears'],
  },
  {
    parkId: 'katmai',
    animals: [
      { name: 'Brown Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Salmon', icon: '🐟', category: 'Fish', commonlySeen: true },
      { name: 'Bald Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
      { name: 'Moose', icon: '🫎', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['July (salmon run)', 'September (bears)'],
    safetyTips: ['Stay on viewing platforms', 'Never approach bears', 'Follow ranger guidance'],
  },
  {
    parkId: 'lake-clark',
    animals: [
      { name: 'Brown Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Moose', icon: '🫎', category: 'Mammal', commonlySeen: true },
      { name: 'Dall Sheep', icon: '🐏', category: 'Mammal', commonlySeen: false },
      { name: 'Salmon', icon: '🐟', category: 'Fish', commonlySeen: true },
    ],
    bestViewingTimes: ['Summer months', 'Salmon season'],
    safetyTips: ['Fly-in access only', 'Carry bear spray', 'Stay alert'],
  },
  {
    parkId: 'wrangell-st-elias',
    animals: [
      { name: 'Grizzly Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Moose', icon: '🫎', category: 'Mammal', commonlySeen: true },
      { name: 'Dall Sheep', icon: '🐏', category: 'Mammal', commonlySeen: true },
      { name: 'Caribou', icon: '🦌', category: 'Mammal', commonlySeen: false },
      { name: 'Golden Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
    ],
    bestViewingTimes: ['Summer', 'Early fall'],
    safetyTips: ['Carry bear spray', 'Hike in groups', 'Make noise'],
  },
  {
    parkId: 'gates-of-arctic',
    animals: [
      { name: 'Caribou', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Grizzly Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Wolf', icon: '🐺', category: 'Mammal', commonlySeen: false },
      { name: 'Dall Sheep', icon: '🐏', category: 'Mammal', commonlySeen: true },
      { name: 'Moose', icon: '🫎', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Summer only', 'Caribou migration'],
    safetyTips: ['Extremely remote', 'Expert wilderness skills required', 'Carry bear spray'],
  },
  {
    parkId: 'kobuk-valley',
    animals: [
      { name: 'Caribou', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Grizzly Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Wolf', icon: '🐺', category: 'Mammal', commonlySeen: false },
      { name: 'Moose', icon: '🫎', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Fall caribou migration', 'Summer'],
    safetyTips: ['Remote wilderness', 'Plan carefully', 'Carry bear spray'],
  },

  // Washington
  {
    parkId: 'olympic',
    animals: [
      { name: 'Roosevelt Elk', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Mountain Goat', icon: '🐐', category: 'Mammal', commonlySeen: false },
      { name: 'Gray Whale', icon: '🐋', category: 'Mammal', commonlySeen: false },
      { name: 'Sea Otter', icon: '🦦', category: 'Mammal', commonlySeen: true },
    ],
    bestViewingTimes: ['Morning', 'Evening', 'Winter for whales'],
    safetyTips: ['Keep distance from elk', 'Store food properly', 'Watch tides'],
  },
  {
    parkId: 'north-cascades',
    animals: [
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Mountain Goat', icon: '🐐', category: 'Mammal', commonlySeen: true },
      { name: 'Marmot', icon: '🦫', category: 'Mammal', commonlySeen: true },
      { name: 'Gray Wolf', icon: '🐺', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Summer', 'Early fall'],
    safetyTips: ['Carry bear spray', 'Make noise on trails', 'Store food properly'],
  },
  {
    parkId: 'mount-rainier',
    animals: [
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Elk', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Mountain Goat', icon: '🐐', category: 'Mammal', commonlySeen: true },
      { name: 'Marmot', icon: '🦫', category: 'Mammal', commonlySeen: true },
      { name: 'Cougar', icon: '🐆', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Summer meadows', 'Dawn', 'Dusk'],
    safetyTips: ['Store food in bear lockers', 'Keep distance from wildlife'],
  },

  // Oregon
  {
    parkId: 'crater-lake',
    animals: [
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Elk', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Marmot', icon: '🦫', category: 'Mammal', commonlySeen: true },
      { name: 'Bald Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
    ],
    bestViewingTimes: ['Summer', 'Early morning'],
    safetyTips: ['Store food properly', 'Watch for wildlife on roads'],
  },

  // Nevada
  {
    parkId: 'great-basin',
    animals: [
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Pronghorn', icon: '🦌', category: 'Mammal', commonlySeen: false },
      { name: 'Mountain Lion', icon: '🐆', category: 'Mammal', commonlySeen: false },
      { name: 'Golden Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
    ],
    bestViewingTimes: ['Dawn', 'Dusk'],
    safetyTips: ['Stay on trails', 'Watch for snakes'],
  },

  // New Mexico
  {
    parkId: 'carlsbad-caverns',
    animals: [
      { name: 'Mexican Free-tailed Bat', icon: '🦇', category: 'Mammal', commonlySeen: true },
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Javelina', icon: '🐗', category: 'Mammal', commonlySeen: false },
      { name: 'Rattlesnake', icon: '🐍', category: 'Reptile', commonlySeen: false },
    ],
    bestViewingTimes: ['Sunset (bat flight)', 'Evening'],
    safetyTips: ['Watch bat flight program', 'Stay on designated trails'],
  },
  {
    parkId: 'white-sands',
    animals: [
      { name: 'Kit Fox', icon: '🦊', category: 'Mammal', commonlySeen: false },
      { name: 'Roadrunner', icon: '🐦', category: 'Bird', commonlySeen: true },
      { name: 'Horned Lizard', icon: '🦎', category: 'Reptile', commonlySeen: true },
      { name: 'Coyote', icon: '🐺', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Early morning', 'Dusk'],
    safetyTips: ['Watch for snakes and lizards', 'Stay hydrated'],
  },

  // Texas
  {
    parkId: 'big-bend',
    animals: [
      { name: 'Javelina', icon: '🐗', category: 'Mammal', commonlySeen: true },
      { name: 'Roadrunner', icon: '🐦', category: 'Bird', commonlySeen: true },
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: false },
      { name: 'Mountain Lion', icon: '🐆', category: 'Mammal', commonlySeen: false },
      { name: 'Rattlesnake', icon: '🐍', category: 'Reptile', commonlySeen: false },
    ],
    bestViewingTimes: ['Early morning', 'Dusk'],
    safetyTips: ['Watch for snakes', 'Keep distance from javelinas', 'Carry water'],
  },
  {
    parkId: 'guadalupe-mountains',
    animals: [
      { name: 'Mule Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Elk', icon: '🦌', category: 'Mammal', commonlySeen: false },
      { name: 'Mountain Lion', icon: '🐆', category: 'Mammal', commonlySeen: false },
      { name: 'Golden Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
    ],
    bestViewingTimes: ['Morning', 'Evening'],
    safetyTips: ['Stay on trails', 'Carry plenty of water'],
  },

  // South Dakota
  {
    parkId: 'badlands',
    animals: [
      { name: 'Bighorn Sheep', icon: '🐏', category: 'Mammal', commonlySeen: true },
      { name: 'Bison', icon: '🦬', category: 'Mammal', commonlySeen: true },
      { name: 'Black-footed Ferret', icon: '🦡', category: 'Mammal', commonlySeen: false },
      { name: 'Prairie Dog', icon: '🦫', category: 'Mammal', commonlySeen: true },
      { name: 'Golden Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
    ],
    bestViewingTimes: ['Early morning', 'Evening'],
    safetyTips: ['Keep 25 yards from bison', 'Watch for prairie dog holes'],
  },
  {
    parkId: 'wind-cave',
    animals: [
      { name: 'Bison', icon: '🦬', category: 'Mammal', commonlySeen: true },
      { name: 'Elk', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Prairie Dog', icon: '🦫', category: 'Mammal', commonlySeen: true },
      { name: 'Pronghorn', icon: '🦌', category: 'Mammal', commonlySeen: true },
    ],
    bestViewingTimes: ['Morning', 'Evening'],
    safetyTips: ['Stay in vehicle for best viewing', 'Keep safe distance from bison'],
  },

  // North Dakota
  {
    parkId: 'theodore-roosevelt',
    animals: [
      { name: 'Bison', icon: '🦬', category: 'Mammal', commonlySeen: true },
      { name: 'Wild Horse', icon: '🐴', category: 'Mammal', commonlySeen: true },
      { name: 'Elk', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Prairie Dog', icon: '🦫', category: 'Mammal', commonlySeen: true },
      { name: 'Golden Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
    ],
    bestViewingTimes: ['Scenic drive', 'Early morning', 'Sunset'],
    safetyTips: ['Keep 25 yards from large animals', 'Stay in vehicle for close viewing'],
  },

  // Florida
  {
    parkId: 'everglades',
    animals: [
      { name: 'Alligator', icon: '🐊', category: 'Reptile', commonlySeen: true },
      { name: 'Manatee', icon: '🦭', category: 'Mammal', commonlySeen: true },
      { name: 'Florida Panther', icon: '🐆', category: 'Mammal', commonlySeen: false },
      { name: 'Roseate Spoonbill', icon: '🦩', category: 'Bird', commonlySeen: true },
      { name: 'Dolphin', icon: '🐬', category: 'Mammal', commonlySeen: true },
    ],
    bestViewingTimes: ['Dry season (Dec-Apr)', 'Early morning'],
    safetyTips: ['Never feed alligators', 'Keep safe distance', 'Stay on boardwalks'],
  },
  {
    parkId: 'biscayne',
    animals: [
      { name: 'Dolphin', icon: '🐬', category: 'Mammal', commonlySeen: true },
      { name: 'Manatee', icon: '🦭', category: 'Mammal', commonlySeen: true },
      { name: 'Sea Turtle', icon: '🐢', category: 'Reptile', commonlySeen: true },
      { name: 'Tropical Fish', icon: '🐠', category: 'Fish', commonlySeen: true },
    ],
    bestViewingTimes: ['Snorkeling tours', 'Boat tours'],
    safetyTips: ['Book boat tours', 'Respect marine life', 'No touching wildlife'],
  },
  {
    parkId: 'dry-tortugas',
    animals: [
      { name: 'Sea Turtle', icon: '🐢', category: 'Reptile', commonlySeen: true },
      { name: 'Dolphin', icon: '🐬', category: 'Mammal', commonlySeen: true },
      { name: 'Tropical Fish', icon: '🐠', category: 'Fish', commonlySeen: true },
      { name: 'Frigatebird', icon: '🐦', category: 'Bird', commonlySeen: true },
    ],
    bestViewingTimes: ['Snorkeling', 'Boat tours'],
    safetyTips: ['Snorkel with care', 'Respect coral reefs', 'Book ferry in advance'],
  },

  // Virgin Islands
  {
    parkId: 'virgin-islands',
    animals: [
      { name: 'Sea Turtle', icon: '🐢', category: 'Reptile', commonlySeen: true },
      { name: 'Dolphin', icon: '🐬', category: 'Mammal', commonlySeen: true },
      { name: 'Tropical Fish', icon: '🐠', category: 'Fish', commonlySeen: true },
      { name: 'Iguana', icon: '🦎', category: 'Reptile', commonlySeen: true },
      { name: 'Pelican', icon: '🦅', category: 'Bird', commonlySeen: true },
    ],
    bestViewingTimes: ['Snorkeling', 'Beach visits'],
    safetyTips: ['Protect coral reefs', 'No touching marine life', 'Stay hydrated'],
  },

  // American Samoa
  {
    parkId: 'american-samoa',
    animals: [
      { name: 'Flying Fox Bat', icon: '🦇', category: 'Mammal', commonlySeen: true },
      { name: 'Sea Turtle', icon: '🐢', category: 'Reptile', commonlySeen: true },
      { name: 'Tropical Fish', icon: '🐠', category: 'Fish', commonlySeen: true },
      { name: 'Humpback Whale', icon: '🐋', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Snorkeling', 'Rainforest hikes'],
    safetyTips: ['Respect fruit bats', 'Protect coral', 'Follow local customs'],
  },

  // Hawaii
  {
    parkId: 'hawaii-volcanoes',
    animals: [
      { name: 'Nene (Hawaiian Goose)', icon: '🦆', category: 'Bird', commonlySeen: true },
      { name: 'Hawaiian Hawk', icon: '🦅', category: 'Bird', commonlySeen: false },
      { name: 'Green Sea Turtle', icon: '🐢', category: 'Reptile', commonlySeen: true },
      { name: 'Spinner Dolphin', icon: '🐬', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Morning', 'Coastal areas for turtles'],
    safetyTips: ['Never feed nene', 'Stay on trails', 'Respect endangered species'],
  },
  {
    parkId: 'haleakala',
    animals: [
      { name: 'Nene (Hawaiian Goose)', icon: '🦆', category: 'Bird', commonlySeen: true },
      { name: 'Humpback Whale', icon: '🐋', category: 'Mammal', commonlySeen: false },
      { name: 'Hawaiian Petrel', icon: '🐦', category: 'Bird', commonlySeen: false },
      { name: 'Green Sea Turtle', icon: '🐢', category: 'Reptile', commonlySeen: true },
    ],
    bestViewingTimes: ['Summit sunrise', 'Winter for whales'],
    safetyTips: ['Never approach nene', 'Stay on designated paths', 'Protect native species'],
  },

  // Arkansas
  {
    parkId: 'hot-springs',
    animals: [
      { name: 'White-tailed Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Fox Squirrel', icon: '🐿️', category: 'Mammal', commonlySeen: true },
      { name: 'Woodpecker', icon: '🐦', category: 'Bird', commonlySeen: true },
      { name: 'Armadillo', icon: '🦔', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Morning', 'Evening'],
    safetyTips: ['Stay on trails', 'Do not feed animals'],
  },

  // Kentucky
  {
    parkId: 'mammoth-cave',
    animals: [
      { name: 'Bat', icon: '🦇', category: 'Mammal', commonlySeen: true },
      { name: 'White-tailed Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Wild Turkey', icon: '🦃', category: 'Bird', commonlySeen: true },
      { name: 'Cave Cricket', icon: '🦗', category: 'Reptile', commonlySeen: true },
    ],
    bestViewingTimes: ['Cave tours', 'Forest trails'],
    safetyTips: ['Follow cave tour guidelines', 'Do not disturb bats'],
  },

  // Tennessee/North Carolina
  {
    parkId: 'great-smoky-mountains',
    animals: [
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'White-tailed Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Elk', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Wild Turkey', icon: '🦃', category: 'Bird', commonlySeen: true },
      { name: 'Salamander', icon: '🦎', category: 'Amphibian', commonlySeen: true },
    ],
    bestViewingTimes: ['Dawn', 'Dusk', 'Fall elk rut'],
    safetyTips: ['Keep 50 yards from bears', 'Store food properly', 'Never approach elk'],
  },

  // Virginia
  {
    parkId: 'shenandoah',
    animals: [
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'White-tailed Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Wild Turkey', icon: '🦃', category: 'Bird', commonlySeen: true },
      { name: 'Bobcat', icon: '🐱', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Skyline Drive', 'Dawn', 'Dusk'],
    safetyTips: ['Drive carefully', 'Keep distance from bears', 'Store food properly'],
  },

  // West Virginia/Maryland
  {
    parkId: 'new-river-gorge',
    animals: [
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: false },
      { name: 'White-tailed Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Turkey Vulture', icon: '🦅', category: 'Bird', commonlySeen: true },
      { name: 'Peregrine Falcon', icon: '🦅', category: 'Bird', commonlySeen: false },
    ],
    bestViewingTimes: ['Morning', 'Evening'],
    safetyTips: ['Stay on trails', 'Watch for wildlife near river'],
  },

  // South Carolina
  {
    parkId: 'congaree',
    animals: [
      { name: 'White-tailed Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'River Otter', icon: '🦦', category: 'Mammal', commonlySeen: true },
      { name: 'Alligator', icon: '🐊', category: 'Reptile', commonlySeen: false },
      { name: 'Woodpecker', icon: '🐦', category: 'Bird', commonlySeen: true },
    ],
    bestViewingTimes: ['Boardwalk walks', 'Canoeing'],
    safetyTips: ['Stay on boardwalks', 'Watch for alligators', 'Wear bug spray'],
  },

  // Maine
  {
    parkId: 'acadia',
    animals: [
      { name: 'White-tailed Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Red Fox', icon: '🦊', category: 'Mammal', commonlySeen: false },
      { name: 'Bald Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
      { name: 'Harbor Seal', icon: '🦭', category: 'Mammal', commonlySeen: true },
      { name: 'Puffin', icon: '🐦', category: 'Bird', commonlySeen: false },
    ],
    bestViewingTimes: ['Morning', 'Coastal areas', 'Boat tours for puffins'],
    safetyTips: ['Watch tides', 'Keep distance from seals', 'Stay on carriage roads'],
  },

  // Michigan
  {
    parkId: 'isle-royale',
    animals: [
      { name: 'Moose', icon: '🫎', category: 'Mammal', commonlySeen: true },
      { name: 'Gray Wolf', icon: '🐺', category: 'Mammal', commonlySeen: false },
      { name: 'Red Fox', icon: '🦊', category: 'Mammal', commonlySeen: true },
      { name: 'Bald Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
    ],
    bestViewingTimes: ['Hiking trails', 'Shorelines'],
    safetyTips: ['Keep distance from moose', 'Store food properly', 'Follow backcountry guidelines'],
  },

  // Minnesota
  {
    parkId: 'voyageurs',
    animals: [
      { name: 'Black Bear', icon: '🐻', category: 'Mammal', commonlySeen: true },
      { name: 'Moose', icon: '🫎', category: 'Mammal', commonlySeen: false },
      { name: 'Gray Wolf', icon: '🐺', category: 'Mammal', commonlySeen: false },
      { name: 'Bald Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
      { name: 'Beaver', icon: '🦫', category: 'Mammal', commonlySeen: true },
    ],
    bestViewingTimes: ['Boat tours', 'Dawn', 'Dusk'],
    safetyTips: ['Boat safety first', 'Store food in bear lockers', 'Keep safe distance'],
  },

  // Missouri/Illinois
  {
    parkId: 'gateway-arch',
    animals: [
      { name: 'Bald Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
      { name: 'Deer', icon: '🦌', category: 'Mammal', commonlySeen: false },
      { name: 'Squirrel', icon: '🐿️', category: 'Mammal', commonlySeen: true },
    ],
    bestViewingTimes: ['Riverfront', 'Winter for eagles'],
    safetyTips: ['Watch for eagles near river', 'Stay on paths'],
  },

  // Indiana
  {
    parkId: 'indiana-dunes',
    animals: [
      { name: 'White-tailed Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Coyote', icon: '🐺', category: 'Mammal', commonlySeen: false },
      { name: 'Sandhill Crane', icon: '🦆', category: 'Bird', commonlySeen: true },
      { name: 'Red Fox', icon: '🦊', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Beach areas', 'Wetlands', 'Migration seasons'],
    safetyTips: ['Stay on trails', 'Respect nesting areas'],
  },

  // Ohio
  {
    parkId: 'cuyahoga-valley',
    animals: [
      { name: 'White-tailed Deer', icon: '🦌', category: 'Mammal', commonlySeen: true },
      { name: 'Beaver', icon: '🦫', category: 'Mammal', commonlySeen: true },
      { name: 'Bald Eagle', icon: '🦅', category: 'Bird', commonlySeen: true },
      { name: 'Coyote', icon: '🐺', category: 'Mammal', commonlySeen: false },
    ],
    bestViewingTimes: ['Towpath Trail', 'Early morning', 'Evening'],
    safetyTips: ['Stay on trails', 'Watch for wildlife on bike paths'],
  },
];

// Helper function to get wildlife data for a specific park
export function getParkWildlife(parkId: string): ParkWildlife | undefined {
  return PARK_WILDLIFE.find(w => w.parkId === parkId);
}

// Helper function to get commonly seen animals for a park
export function getCommonAnimals(parkId: string): WildlifeAnimal[] {
  const parkData = getParkWildlife(parkId);
  return parkData ? parkData.animals.filter(a => a.commonlySeen) : [];
}

// Helper function to get all animals for a park
export function getAllAnimals(parkId: string): WildlifeAnimal[] {
  const parkData = getParkWildlife(parkId);
  return parkData ? parkData.animals : [];
}
