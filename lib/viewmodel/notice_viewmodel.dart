import 'package:flutter/foundation.dart';

import '../model/notice.dart';

class NoticeViewmodel extends ChangeNotifier {
  List<Notice> _notices = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Notice> get notices => _notices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Notice> get sortedNotices {
    final important = _notices.where((n) => n.isImportant).toList();
    final normal = _notices.where((n) => !n.isImportant).toList();

    important.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    normal.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return [...important, ...normal];
  }

  Future<void> loadNotices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(Duration(milliseconds: 500));
      _notices = _generateDummyNotices();
    } catch (e) {
      _errorMessage = '공지사항을 불러오는데 실패했습니다';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshNotices() async {
    await loadNotices();
  }

  List<Notice> _generateDummyNotices() {
    return [
      Notice(
        id: '1',
        title: '[필독] 서비스 이용약관 변경 안내',
        content: '서비스 이용약관이 변경됩니다...',
        createdAt: DateTime(2025, 10, 1),
        isImportant: true,
      ),
      // 더 많은 더미 데이터...
    ];
  }
}