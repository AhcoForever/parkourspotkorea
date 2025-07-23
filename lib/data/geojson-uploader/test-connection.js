const admin = require('firebase-admin');

// 서비스 계정 키 파일 로드
try {
  const serviceAccount = require('./serviceAccountKey.json');

  // Firebase 초기화
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });

  console.log('✅ Firebase 연결 성공!');
  console.log('프로젝트 ID:', serviceAccount.project_id);

  // Firestore 테스트
  const db = admin.firestore();

  // 테스트 문서 쓰기
  db.collection('dong_boundaries').doc('connection').set({
    message: '연결 테스트 성공',
    timestamp: admin.firestore.FieldValue.serverTimestamp()
  }).then(() => {
    console.log('✅ Firestore 쓰기 테스트 성공!');
    process.exit(0);
  }).catch(error => {
    console.error('❌ Firestore 쓰기 실패:', error.message);
    process.exit(1);
  });

} catch (error) {
  console.error('❌ 오류 발생:', error.message);
  process.exit(1);
}