import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MeetUp());
}

class MeetUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '모임 생성 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: MapScreen(),
    );
  }
}

class Meeting {
  final String id;
  final String title;
  final LatLng location;
  final String locationName;
  final String createdBy;
  final DateTime createdAt;
  final List<String> participants;

  Meeting({
    required this.id,
    required this.title,
    required this.location,
    required this.locationName,
    required this.createdBy,
    required this.createdAt,
    required this.participants,
  });
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  List<Meeting> _meetings = [];
  LatLng? _selectedLocation;
  String _selectedLocationName = '';
  String _currentUserNickname = '사용자1'; // 현재 사용자 닉네임

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.5665, 126.9780), // 서울 시청
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('모임 생성'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _showMeetingList,
            tooltip: '모임 목록',
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            markers: _markers,
            onTap: _onMapTapped,
          ),
          if (_selectedLocation != null) _buildActionButtons(),
        ],
      ),
    );
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _selectedLocationName = _getLocationName(location);
    });
  }

  String _getLocationName(LatLng location) {
    // 실제 앱에서는 Geocoding API를 사용하여 주소를 가져옵니다
    List<String> locations = [
      '강남역', '홍대입구역', '명동', '이태원', '종로3가',
      '신촌', '건대입구', '성신여대입구', '신림역', '사당역'
    ];
    return locations[Random().nextInt(locations.length)];
  }

  Widget _buildActionButtons() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '선택된 장소: $_selectedLocationName',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _createMeeting,
                    icon: Icon(Icons.add),
                    label: Text('모임 생성'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showMeetingList,
                    icon: Icon(Icons.list),
                    label: Text('모임 목록'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createMeeting() {
    if (_selectedLocation == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('모임 생성'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '모임 제목',
                hintText: '모임 제목을 입력하세요',
              ),
              onChanged: (value) {
                // 모임 제목 저장
              },
            ),
            SizedBox(height: 16),
            Text('장소: $_selectedLocationName'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              _addMeeting();
              Navigator.of(context).pop();
            },
            child: Text('생성'),
          ),
        ],
      ),
    );
  }

  void _addMeeting() {
    if (_selectedLocation == null) return;

    final meeting = Meeting(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '모임 ${_meetings.length + 1}',
      location: _selectedLocation!,
      locationName: _selectedLocationName,
      createdBy: _currentUserNickname,
      createdAt: DateTime.now(),
      participants: [_currentUserNickname],
    );

    setState(() {
      _meetings.add(meeting);
      _markers.add(
        Marker(
          markerId: MarkerId(meeting.id),
          position: meeting.location,
          infoWindow: InfoWindow(
            title: meeting.title,
            snippet: '${meeting.locationName} - ${meeting.participants.length}명 참여',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          onTap: () => _showMeetingDetails(meeting),
        ),
      );
      _selectedLocation = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('모임이 생성되었습니다!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showMeetingList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                '모임 목록',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: _meetings.isEmpty
                    ? Center(
                  child: Text(
                    '생성된 모임이 없습니다.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : ListView.builder(
                  controller: scrollController,
                  itemCount: _meetings.length,
                  itemBuilder: (context, index) {
                    final meeting = _meetings[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(meeting.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('장소: ${meeting.locationName}'),
                            Text('생성자: ${meeting.createdBy}'),
                            Text('참여자: ${meeting.participants.join(', ')}'),
                            Text('생성시간: ${_formatDateTime(meeting.createdAt)}'),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text('상세보기'),
                              onTap: () => _showMeetingDetails(meeting),
                            ),
                            if (meeting.createdBy == _currentUserNickname)
                              PopupMenuItem(
                                child: Text('삭제'),
                                onTap: () => _deleteMeeting(meeting),
                              ),
                            if (!meeting.participants.contains(_currentUserNickname))
                              PopupMenuItem(
                                child: Text('참여'),
                                onTap: () => _joinMeeting(meeting),
                              ),
                          ],
                        ),
                        onTap: () => _showMeetingDetails(meeting),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMeetingDetails(Meeting meeting) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(meeting.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('장소: ${meeting.locationName}'),
            SizedBox(height: 8),
            Text('생성자: ${meeting.createdBy}'),
            SizedBox(height: 8),
            Text('생성시간: ${_formatDateTime(meeting.createdAt)}'),
            SizedBox(height: 8),
            Text('참여자 (${meeting.participants.length}명):'),
            ...meeting.participants.map((participant) =>
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('• $participant'),
                )
            ),
          ],
        ),
        actions: [
          if (meeting.createdBy == _currentUserNickname)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showDeleteConfirmation(meeting);
              },
              child: Text('모임 취소', style: TextStyle(color: Colors.red)),
            ),
          if (!meeting.participants.contains(_currentUserNickname))
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _joinMeeting(meeting);
              },
              child: Text('참여하기'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('닫기'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Meeting meeting) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('모임 취소'),
        content: Text('정말로 모임을 취소하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('아니오'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteMeeting(meeting);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('예'),
          ),
        ],
      ),
    );
  }

  void _deleteMeeting(Meeting meeting) {
    setState(() {
      _meetings.removeWhere((m) => m.id == meeting.id);
      _markers.removeWhere((marker) => marker.markerId.value == meeting.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('모임이 취소되었습니다.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _joinMeeting(Meeting meeting) {
    setState(() {
      final index = _meetings.indexWhere((m) => m.id == meeting.id);
      if (index != -1) {
        _meetings[index].participants.add(_currentUserNickname);

        // 마커 업데이트
        _markers.removeWhere((marker) => marker.markerId.value == meeting.id);
        _markers.add(
          Marker(
            markerId: MarkerId(meeting.id),
            position: meeting.location,
            infoWindow: InfoWindow(
              title: meeting.title,
              snippet: '${meeting.locationName} - ${meeting.participants.length}명 참여',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            onTap: () => _showMeetingDetails(meeting),
          ),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('모임에 참여했습니다!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}