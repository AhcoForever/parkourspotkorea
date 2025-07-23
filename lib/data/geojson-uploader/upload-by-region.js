const admin = require('firebase-admin');
const fs = require('fs').promises;

// 시/도별로 분할해서 업로드 (geometry 문제 해결)
async function uploadByRegion(sidoCode, sidoName) {
  const serviceAccount = require('./serviceAccountKey.json');

  if (!admin.apps.length) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });
  }

  const db = admin.firestore();

  console.log(`\n🏛️  ${sidoName} 업로드 시작...`);

  // GeoJSON 로드
  const data = await fs.readFile('./HangJeongDong_ver20250401.geojson', 'utf8');
  const geoJson = JSON.parse(data);

  let batch = db.batch();
  let count = 0;
  let batchCount = 0;
  let errorCount = 0;

  for (const feature of geoJson.features) {
    try {
      const admCd = String(feature.properties.adm_cd || '');

      // 해당 시/도의 동만 처리
      if (admCd.startsWith(sidoCode) && admCd.length >= 8) {
        const dongData = {
          adm_cd: admCd,
          adm_nm: feature.properties.adm_nm || '',
          sido_cd: sidoCode,
          sido_nm: sidoName,
          sigungu_cd: admCd.substring(0, 5),
          sigungu_nm: feature.properties.sgg_nm || '',

          // 방법 1: geometry를 JSON 문자열로 저장
          geometry_json: JSON.stringify(feature.geometry),

          // 방법 2: geometry 타입만 저장하고 좌표는 따로 저장
          geometry_type: feature.geometry.type,

          // 중심점은 그대로 저장 가능
          center: calculateCenter(feature.geometry),

          created_at: admin.firestore.FieldValue.serverTimestamp()
        };

        batch.set(db.collection('dong_boundaries').doc(admCd), dongData);
        batchCount++;
        count++;

        // 500개마다 커밋
        if (batchCount >= 500) {
          await batch.commit();
          console.log(`  ${count}개 완료...`);
          batch = db.batch();
          batchCount = 0;
        }
      }
    } catch (error) {
      console.error(`  ❌ 문서 처리 오류 (${feature.properties?.adm_cd}):`, error.message);
      errorCount++;
    }
  }

  // 마지막 배치 커밋
  if (batchCount > 0) {
    await batch.commit();
  }

  console.log(`✅ ${sidoName} 완료: ${count}개 동 (오류: ${errorCount}개)`);
  return count;
}

function calculateCenter(geometry) {
  try {
    const coords = geometry.type === 'MultiPolygon'
      ? geometry.coordinates[0][0]
      : geometry.coordinates[0];

    let lat = 0, lng = 0, count = 0;
    for (const coord of coords) {
      if (Array.isArray(coord) && coord.length >= 2) {
        lng += coord[0];
        lat += coord[1];
        count++;
      }
    }

    return count > 0 ? { lat: lat/count, lng: lng/count } : { lat: 0, lng: 0 };
  } catch (error) {
    console.error('중심점 계산 오류:', error.message);
    return { lat: 0, lng: 0 };
  }
}

// 시/도별로 순차 업로드
async function uploadAll() {
  const regions = [
    ['11', '서울특별시'],
    ['26', '부산광역시'],
    ['27', '대구광역시'],
    ['28', '인천광역시'],
    ['29', '광주광역시'],
    ['30', '대전광역시'],
    ['31', '울산광역시'],
    ['36', '세종특별자치시'],
    ['41', '경기도'],
    ['42', '강원특별자치도'],
    ['43', '충청북도'],
    ['44', '충청남도'],
    ['45', '전라북도'],
    ['46', '전라남도'],
    ['47', '경상북도'],
    ['48', '경상남도'],
    ['50', '제주특별자치도']
  ];

  console.log('🚀 시/도별 업로드 시작 (geometry를 JSON 문자열로 저장)');

  let totalCount = 0;
  for (const [code, name] of regions) {
    try {
      const count = await uploadByRegion(code, name);
      totalCount += count;
    } catch (error) {
      console.error(`❌ ${name} 업로드 실패:`, error.message);
    }
  }

  console.log(`\n✨ 전체 업로드 완료: 총 ${totalCount}개 동`);

  // 메타데이터 저장
  const db = admin.firestore();
  await db.collection('dong_boundaries').doc('_metadata').set({
    total_count: totalCount,
    last_updated: admin.firestore.FieldValue.serverTimestamp(),
    geometry_format: 'json_string',
    note: 'geometry는 JSON 문자열로 저장됨'
  });
}

// 전체 업로드
uploadAll().catch(console.error);