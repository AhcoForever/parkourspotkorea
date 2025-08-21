import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/parkour_spot_migration.dart';

// 방금 만든 서비스 import

/// 파쿠르 스팟 마이그레이션 UI 페이지
class ParkourMigrationPage extends StatefulWidget {
  @override
  _ParkourMigrationPageState createState() => _ParkourMigrationPageState();
}

class _ParkourMigrationPageState extends State<ParkourMigrationPage> {
  final ParkourSpotMigrationService _migrationService = ParkourSpotMigrationService();

  bool _isMigrating = false;
  MigrationResult? _lastResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🏃‍♂️ 파쿠르 스팟 마이그레이션'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 현재 상태 카드
            _buildStatusCard(),

            SizedBox(height: 16),

            // 마이그레이션 카드
            _buildMigrationCard(),

            SizedBox(height: 16),

            // 결과 카드
            if (_lastResult != null) _buildResultCard(),

            SizedBox(height: 16),

            // 스팟 목록 카드
            _buildSpotListCard(),

            SizedBox(height: 16),

            // 관리 카드
            _buildManagementCard(),
          ],
        ),
      ),
    );
  }

  /// 현재 상태 카드
  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 현재 상태',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            StreamBuilder<QuerySnapshot>(
              stream: _migrationService.getUploadedSpots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('데이터 로딩 중...');
                }

                final spots = snapshot.data!.docs;
                final totalCount = spots.length;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('총 파쿠르 스팟', '$totalCount개', Colors.orange),
                    _buildStatItem('컬렉션명', 'spot', Colors.blue),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  /// 마이그레이션 카드
  Widget _buildMigrationCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🚀 parkourSpot250711.json 마이그레이션',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            Text(
              '네이버 지도 파쿠르 스팟 JSON 파일을 Firestore의 "spot" 컬렉션으로 마이그레이션합니다.',
              style: TextStyle(color: Colors.grey[600]),
            ),

            SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isMigrating ? null : _startMigration,
                icon: _isMigrating
                    ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Icon(Icons.upload_file),
                label: Text(_isMigrating ? '마이그레이션 중...' : 'JSON 파일 선택 & 마이그레이션'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            if (_isMigrating)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: LinearProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  /// 결과 카드
  Widget _buildResultCard() {
    final result = _lastResult!;

    return Card(
      color: result.success ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  result.success ? Icons.check_circle : Icons.error,
                  color: result.success ? Colors.green : Colors.red,
                ),
                SizedBox(width: 8),
                Text(
                  result.success ? '✅ 마이그레이션 완료' : '❌ 마이그레이션 실패',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: result.success ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            Text(
              result.summary,
              style: TextStyle(
                color: result.success ? Colors.green.shade700 : Colors.red.shade700,
              ),
            ),

            if (result.errors.isNotEmpty) ...[
              SizedBox(height: 8),
              ExpansionTile(
                title: Text('오류 상세 (${result.errors.length}개)'),
                children: result.errors.map((error) =>
                    ListTile(
                      leading: Icon(Icons.warning, color: Colors.orange, size: 16),
                      title: Text(error, style: TextStyle(fontSize: 12)),
                    )
                ).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 스팟 목록 카드
  Widget _buildSpotListCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📍 마이그레이션된 파쿠르 스팟',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            StreamBuilder<QuerySnapshot>(
              stream: _migrationService.getUploadedSpots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('오류: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final spots = snapshot.data?.docs ?? [];

                if (spots.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.location_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          '아직 마이그레이션된 파쿠르 스팟이 없습니다.\nparkourSpot250711.json 파일을 업로드해보세요!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Text('총 ${spots.length}개 스팟'),
                    SizedBox(height: 8),

                    // 최근 5개만 표시
                    ...spots.take(5).map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildSpotListItem(data, doc.id);
                    }),

                    if (spots.length > 5)
                      TextButton(
                        onPressed: () => _showAllSpots(spots),
                        child: Text('전체 목록 보기 (${spots.length}개)'),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotListItem(Map<String, dynamic> data, String docId) {
    final location = data['location'] as GeoPoint?;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getSubcategoryColor(data['subcategory'] ?? 'general'),
        child: Text(_getSubcategoryIcon(data['subcategory'] ?? 'general')),
      ),
      title: Text(data['name'] ?? '이름 없음'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data['address']?.isNotEmpty == true)
            Text(data['address']),
          Row(
            children: [
              Text('📍 ${data['subcategory'] ?? 'general'}'),
              SizedBox(width: 8),
              if (location != null)
                Text(
                  '🗺️ ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
            ],
          ),
          Text(
            '🆔 ${data['documentId'] ?? docId}',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
      trailing: Icon(Icons.location_on, color: Colors.orange),
      onTap: () => _showSpotDetail(data, docId),
    );
  }

  /// 관리 카드
  Widget _buildManagementCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🛠️ 관리 기능',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() {}),
                    icon: Icon(Icons.refresh),
                    label: Text('새로고침'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showClearDialog,
                    icon: Icon(Icons.delete_forever),
                    label: Text('전체 삭제'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // === 이벤트 핸들러들 ===

  Future<void> _startMigration() async {
    setState(() {
      _isMigrating = true;
      _lastResult = null;
    });

    try {
      final result = await _migrationService.migrateParkourSpots();

      setState(() {
        _lastResult = result;
      });

    } catch (e) {
      setState(() {
        _lastResult = MigrationResult.error('예상치 못한 오류: $e');
      });
    } finally {
      setState(() {
        _isMigrating = false;
      });
    }
  }

  void _showAllSpots(List<QueryDocumentSnapshot> spots) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllParkourSpotsPage(spots: spots),
      ),
    );
  }

  void _showSpotDetail(Map<String, dynamic> data, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(data['name'] ?? '이름 없음'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('📍 주소: ${data['address'] ?? '주소 없음'}'),
              Text('🏷️ 카테고리: ${data['subcategory'] ?? 'general'}'),
              Text('📍 타입: ${data['type'] ?? 'place'}'),
              if (data['tags'] != null)
                Text('🏃 태그: ${(data['tags'] as List).join(', ')}'),
              if (data['location'] != null) ...[
                SizedBox(height: 8),
                Text('🗺️ 위치 정보:'),
                Text('  위도: ${(data['location'] as GeoPoint).latitude}'),
                Text('  경도: ${(data['location'] as GeoPoint).longitude}'),
              ],
              SizedBox(height: 8),
              Text('🆔 문서 ID: ${data['documentId'] ?? docId}'),
              Text('📝 북마크 ID: ${data['bookmarkId'] ?? '없음'}'),
              if (data['createdAt'] != null)
                Text('📅 생성일: ${(data['createdAt'] as Timestamp).toDate().toString().split('.')[0]}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('닫기'),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('⚠️ 경고'),
        content: Text('정말로 모든 파쿠르 스팟 데이터를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('삭제'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _migrationService.clearAllSpots();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ 모든 파쿠르 스팟이 삭제되었습니다.')),
        );

        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ 삭제 실패: $e')),
        );
      }
    }
  }

  // === 헬퍼 함수들 ===

  Color _getSubcategoryColor(String subcategory) {
    switch (subcategory) {
      case 'park': return Colors.green;
      case 'school': return Colors.blue;
      case 'parkour_gym': return Colors.orange;
      case 'gym': return Colors.purple;
      case 'plaza': return Colors.teal;
      case 'bridge': return Colors.indigo;
      case 'stairs': return Colors.brown;
      default: return Colors.grey;
    }
  }

  String _getSubcategoryIcon(String subcategory) {
    switch (subcategory) {
      case 'park': return '🌳';
      case 'school': return '🏫';
      case 'parkour_gym': return '🏃';
      case 'gym': return '💪';
      case 'plaza': return '🏛️';
      case 'bridge': return '🌉';
      case 'stairs': return '🪜';
      default: return '📍';
    }
  }
}

/// 전체 파쿠르 스팟 목록 페이지
class AllParkourSpotsPage extends StatelessWidget {
  final List<QueryDocumentSnapshot> spots;

  const AllParkourSpotsPage({Key? key, required this.spots}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('전체 파쿠르 스팟 (${spots.length}개)'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: spots.length,
        itemBuilder: (context, index) {
          final doc = spots[index];
          final data = doc.data() as Map<String, dynamic>;
          final location = data['location'] as GeoPoint?;

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getSubcategoryColor(data['subcategory'] ?? 'general'),
                child: Text('${index + 1}'),
              ),
              title: Text(data['name'] ?? '이름 없음'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data['address']?.isNotEmpty == true)
                    Text(data['address']),
                  Text(
                    '${data['subcategory'] ?? 'general'} • ${data['type'] ?? 'place'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (location != null)
                    Text(
                      '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.orange),
                  Text(
                    data['documentId']?.substring(0, 6) ?? doc.id.substring(0, 6),
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
              onTap: () {
                // 스팟 상세 정보 표시 또는 지도로 이동
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(data['name'] ?? '이름 없음'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('주소: ${data['address'] ?? '없음'}'),
                        Text('카테고리: ${data['subcategory'] ?? 'general'}'),
                        if (location != null) ...[
                          Text('위도: ${location.latitude}'),
                          Text('경도: ${location.longitude}'),
                        ],
                        Text('문서 ID: ${data['documentId'] ?? doc.id}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('닫기'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color _getSubcategoryColor(String subcategory) {
    switch (subcategory) {
      case 'park': return Colors.green;
      case 'school': return Colors.blue;
      case 'parkour_gym': return Colors.orange;
      case 'gym': return Colors.purple;
      case 'plaza': return Colors.teal;
      case 'bridge': return Colors.indigo;
      case 'stairs': return Colors.brown;
      default: return Colors.grey;
    }
  }
}