// Node.js 스크립트 - 각 동을 개별 문서로 Firestore에 업로드
const admin = require('firebase-admin');
const fs = require('fs').promises;

// Firebase Admin SDK 초기화
admin.initializeApp({
  credential: admin.credential.cert('./serviceAccountKey.json'),
  projectId: 'parkourspot-korea'
});

const db = admin.firestore();

async function uploadDongToFirestore() {
  try {
    // GeoJSON 파일 읽기
    console.log('GeoJSON 파일 읽는 중...');
    const data = await fs.readFile('HangJeongDong_ver20250401.geojson', 'utf8');
    const geoJson = JSON.parse(data);

    console.log(`총 features: ${geoJson.features.length}`);

    // 배치 작업 준비
    let batch = db.batch();
    let batchCount = 0;
    let totalDongCount = 0;
    let errorCount = 0;

    for (const feature of geoJson.features) {
      try {
        const properties = feature.properties || {};
        const admCd = properties.adm_cd || '';

        // 동 단위만 처리 (8자리 이상 코드)
        if (admCd.length >= 8) {
          // 시/도 코드 추출
          const sidoCode = admCd.substring(0, 2);
          const sigunguCode = admCd.substring(0, 5);

          // 문서 데이터 준비
          const dongData = {
            // 행정구역 정보
            adm_cd: admCd,
            adm_nm: properties.adm_nm || '',

            // 계층 정보
            sido_cd: sidoCode,
            sido_nm: getSidoName(sidoCode),
            sigungu_cd: sigunguCode,
            sigungu_nm: properties.sgg_nm || '',

            // geometry 저장 (GeoJSON 형식 그대로)
            geometry: feature.geometry,

            // 메타데이터
            created_at: admin.firestore.FieldValue.serverTimestamp(),

            // 추가 정보 (있다면)
            eng_nm: properties.eng_nm || '',
            kor_nm: properties.kor_nm || '',

            // 중심점 계산해서 저장 (빠른 거리 계산용)
            center: calculateCenter(feature.geometry)
          };

          // 배치에 추가
          const docRef = db.collection('dong_boundaries').doc(admCd);
          batch.set(docRef, dongData);
          batchCount++;
          totalDongCount++;

          // 500개마다 배치 커밋 (Firestore 제한)
          if (batchCount >= 500) {
            await batch.commit();
            console.log(`${totalDongCount}개 동 업로드 완료...`);
            batch = db.batch();
            batchCount = 0;
          }
        }
      } catch (error) {
        console.error(`Feature 처리 오류: ${error.message}`);
        errorCount++;
      }
    }

    // 마지막 배치 커밋
    if (batchCount > 0) {
      await batch.commit();
    }

    console.log('\n=== 업로드 완료 ===');
    console.log(`총 동 개수: ${totalDongCount}`);
    console.log(`오류 개수: ${errorCount}`);

    // 통계 정보 저장
    await db.collection('dong_boundaries').doc('_metadata').set({
      total_count: totalDongCount,
      last_updated: admin.firestore.FieldValue.serverTimestamp(),
      sido_list: getSidoList(),
      upload_date: new Date().toISOString()
    });

    console.log('메타데이터 저장 완료');

  } catch (error) {
    console.error('업로드 실패:', error);
  }
}

// 중심점 계산 함수
function calculateCenter(geometry) {
  let totalLat = 0;
  let totalLng = 0;
  let pointCount = 0;

  // MultiPolygon 또는 Polygon 처리
  const coordinates = geometry.type === 'MultiPolygon'
    ? geometry.coordinates[0][0]
    : geometry.coordinates[0];

  for (const coord of coordinates) {
    if (Array.isArray(coord) && coord.length >= 2) {
      totalLng += coord[0];
      totalLat += coord[1];
      pointCount++;
    }
  }

  return {
    lat: totalLat / pointCount,
    lng: totalLng / pointCount
  };
}

// 시/도 이름 가져오기
function getSidoName(code) {
  const names = {
    '11': '서울특별시',
    '26': '부산광역시',
    '27': '대구광역시',
    '28': '인천광역시',
    '29': '광주광역시',
    '30': '대전광역시',
    '31': '울산광역시',
    '36': '세종특별자치시',
    '41': '경기도',
    '42': '강원특별자치도',
    '43': '충청북도',
    '44': '충청남도',
    '45': '전라북도',
    '46': '전라남도',
    '47': '경상북도',
    '48': '경상남도',
    '50': '제주특별자치도'
  };
  return names[code] || '알 수 없음';
}

// 시/도 목록
function getSidoList() {
  return [
    { code: '11', name: '서울특별시' },
    { code: '26', name: '부산광역시' },
    { code: '27', name: '대구광역시' },
    { code: '28', name: '인천광역시' },
    { code: '29', name: '광주광역시' },
    { code: '30', name: '대전광역시' },
    { code: '31', name: '울산광역시' },
    { code: '36', name: '세종특별자치시' },
    { code: '41', name: '경기도' },
    { code: '42', name: '강원특별자치도' },
    { code: '43', name: '충청북도' },
    { code: '44', name: '충청남도' },
    { code: '45', name: '전라북도' },
    { code: '46', name: '전라남도' },
    { code: '47', name: '경상북도' },
    { code: '48', name: '경상남도' },
    { code: '50', name: '제주특별자치도' }
  ];
}

// 실행
uploadDongToFirestore();