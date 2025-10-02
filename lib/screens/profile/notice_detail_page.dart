import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkourspotkorea/model/notice.dart';

import '../../theme/app_colors.dart';

class NoticeDetailPage extends StatelessWidget {
  final Notice notice;

  const NoticeDetailPage({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일');

    return Scaffold(
      appBar: AppBar(title: const Text('공지사항')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 영역
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: BrandColors.c800,
                border: Border(
                  bottom: BorderSide(
                    color: StrokeColors.defaultStroke,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 중요 뱃지
                  if (notice.isImportant) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: SecondaryColors.c500Default,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '필독',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: BrandColors.c900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  // 제목
                  Text(
                    notice.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: BrandColors.txtWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 날짜
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: BrandColors.txt300,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateFormat.format(notice.createdAt),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: BrandColors.txt300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 본문 영역
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                notice.content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: BrandColors.c100,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
