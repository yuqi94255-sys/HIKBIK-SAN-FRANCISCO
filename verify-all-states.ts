// 🔍 验证所有50个州的数据完整性

import { StateData } from "./states-data";
import { alabamaData } from "./alabama-data";
import { alaskaData } from "./alaska-data";
import { arizonaData } from "./arizona-data";
import { arkansasData } from "./arkansas-data";
import { californiaData } from "./california-data";
import { coloradoData } from "./colorado-data";
import { connecticutData } from "./connecticut-data";
import { delawareData } from "./delaware-data";
import { floridaData } from "./florida-data";
import { georgiaData } from "./georgia-data";
import { hawaiiData } from "./hawaii-data";
import { idahoData } from "./idaho-data";
import { illinoisData } from "./illinois-data";
import { indianaData } from "./indiana-data";
import { iowaData } from "./iowa-data";
import { kansasData } from "./kansas-data";
import { kentuckyData } from "./kentucky-data";
import { louisianaData } from "./louisiana-data";
import { maineData } from "./maine-data";
import { marylandData } from "./maryland-data";
import { massachusettsData } from "./massachusetts-data";
import { michiganData } from "./michigan-data";
import { minnesotaData } from "./minnesota-data";
import { mississippiData } from "./mississippi-data";
import { missouriData } from "./missouri-data";
import { montanaData } from "./montana-data";
import { nebraskaData } from "./nebraska-data";
import { nevadaData } from "./nevada-data";
import { newHampshireData } from "./new-hampshire-data";
import { newJerseyData } from "./new-jersey-data";
import { newMexicoData } from "./new-mexico-data";
import { newYorkData } from "./new-york-data";
import { northCarolinaData } from "./north-carolina-data";
import { northDakotaData } from "./north-dakota-data";
import { ohioData } from "./ohio-data";
import { oklahomaData } from "./oklahoma-data";
import { oregonData } from "./oregon-data";
import { pennsylvaniaData } from "./pennsylvania-data";
import { rhodeIslandData } from "./rhode-island-data";
import { southCarolinaData } from "./south-carolina-data";
import { southDakotaData } from "./south-dakota-data";
import { tennesseeData } from "./tennessee-data";
import { texasData } from "./texas-data";
import { utahData } from "./utah-data";
import { vermontData } from "./vermont-data";
import { virginiaData } from "./virginia-data";
import { washingtonData } from "./washington-data";
import { westVirginiaData } from "./west-virginia-data";
import { wisconsinData } from "./wisconsin-data";
import { wyomingData } from "./wyoming-data";

// 所有50个州的数据数组
export const ALL_STATES_DATA_VERIFIED: StateData[] = [
  alabamaData,        // AL - 1
  alaskaData,         // AK - 2
  arizonaData,        // AZ - 3
  arkansasData,       // AR - 4
  californiaData,     // CA - 5
  coloradoData,       // CO - 6 ✅ 已修复
  connecticutData,    // CT - 7 ✅ 已修复
  delawareData,       // DE - 8 ✅ 已修复
  floridaData,        // FL - 9 ✅ 已修复
  georgiaData,        // GA - 10
  hawaiiData,         // HI - 11 ✅ 已修复
  idahoData,          // ID - 12
  illinoisData,       // IL - 13
  indianaData,        // IN - 14
  iowaData,           // IA - 15
  kansasData,         // KS - 16
  kentuckyData,       // KY - 17
  louisianaData,      // LA - 18
  maineData,          // ME - 19
  marylandData,       // MD - 20
  massachusettsData,  // MA - 21
  michiganData,       // MI - 22
  minnesotaData,      // MN - 23
  mississippiData,    // MS - 24
  missouriData,       // MO - 25
  montanaData,        // MT - 26
  nebraskaData,       // NE - 27
  nevadaData,         // NV - 28
  newHampshireData,   // NH - 29
  newJerseyData,      // NJ - 30
  newMexicoData,      // NM - 31
  newYorkData,        // NY - 32
  northCarolinaData,  // NC - 33
  northDakotaData,    // ND - 34
  ohioData,           // OH - 35
  oklahomaData,       // OK - 36
  oregonData,         // OR - 37
  pennsylvaniaData,   // PA - 38
  rhodeIslandData,    // RI - 39
  southCarolinaData,  // SC - 40
  southDakotaData,    // SD - 41
  tennesseeData,      // TN - 42
  texasData,          // TX - 43
  utahData,           // UT - 44
  vermontData,        // VT - 45
  virginiaData,       // VA - 46
  washingtonData,     // WA - 47
  westVirginiaData,   // WV - 48
  wisconsinData,      // WI - 49
  wyomingData         // WY - 50
];

// 验证函数
export function verifyAllStatesData() {
  console.log("🔍 验证所有50个州的数据...\n");
  
  let totalParks = 0;
  let statesWithIssues: string[] = [];
  
  ALL_STATES_DATA_VERIFIED.forEach((state, index) => {
    const stateNum = index + 1;
    const parkCount = state.parks.length;
    totalParks += parkCount;
    
    // 检查必需字段
    const hasName = !!state.name;
    const hasCode = !!state.code;
    const hasImages = state.images && state.images.length > 0;
    const hasParks = parkCount > 0;
    const hasBounds = !!state.bounds;
    
    const isValid = hasName && hasCode && hasImages && hasParks && hasBounds;
    
    if (!isValid) {
      statesWithIssues.push(state.name || state.code || `州 #${stateNum}`);
      console.log(`❌ ${stateNum}. ${state.name} (${state.code}): 数据不完整`);
      if (!hasName) console.log(`   - 缺少 name`);
      if (!hasCode) console.log(`   - 缺少 code`);
      if (!hasImages) console.log(`   - 缺少 images`);
      if (!hasParks) console.log(`   - 缺少 parks`);
      if (!hasBounds) console.log(`   - 缺少 bounds`);
    } else {
      console.log(`✅ ${stateNum}. ${state.name} (${state.code}): ${parkCount} 个公园/森林`);
    }
  });
  
  console.log(`\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`);
  console.log(`📊 统计摘要:`);
  console.log(`   总州数: ${ALL_STATES_DATA_VERIFIED.length}/50`);
  console.log(`   总公园/森林数: ${totalParks.toLocaleString()}`);
  console.log(`   有问题的州: ${statesWithIssues.length}`);
  
  if (statesWithIssues.length > 0) {
    console.log(`\n⚠️  需要修复的州:`);
    statesWithIssues.forEach(state => console.log(`   - ${state}`));
  } else {
    console.log(`\n🎉 所有50个州数据完整！系统100%完成！`);
  }
  
  return {
    totalStates: ALL_STATES_DATA_VERIFIED.length,
    totalParks,
    statesWithIssues
  };
}

// 导出州代码映射
export const STATES_MAP: Record<string, StateData> = {
  AL: alabamaData,
  AK: alaskaData,
  AZ: arizonaData,
  AR: arkansasData,
  CA: californiaData,
  CO: coloradoData,
  CT: connecticutData,
  DE: delawareData,
  FL: floridaData,
  GA: georgiaData,
  HI: hawaiiData,
  ID: idahoData,
  IL: illinoisData,
  IN: indianaData,
  IA: iowaData,
  KS: kansasData,
  KY: kentuckyData,
  LA: louisianaData,
  ME: maineData,
  MD: marylandData,
  MA: massachusettsData,
  MI: michiganData,
  MN: minnesotaData,
  MS: mississippiData,
  MO: missouriData,
  MT: montanaData,
  NE: nebraskaData,
  NV: nevadaData,
  NH: newHampshireData,
  NJ: newJerseyData,
  NM: newMexicoData,
  NY: newYorkData,
  NC: northCarolinaData,
  ND: northDakotaData,
  OH: ohioData,
  OK: oklahomaData,
  OR: oregonData,
  PA: pennsylvaniaData,
  RI: rhodeIslandData,
  SC: southCarolinaData,
  SD: southDakotaData,
  TN: tennesseeData,
  TX: texasData,
  UT: utahData,
  VT: vermontData,
  VA: virginiaData,
  WA: washingtonData,
  WV: westVirginiaData,
  WI: wisconsinData,
  WY: wyomingData
};
