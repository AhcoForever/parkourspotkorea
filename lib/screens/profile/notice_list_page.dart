import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../model/notice.dart';
import '../../theme/app_colors.dart';
import '../../viewmodel/notice_viewmodel.dart';
import 'notice_detail_page.dart';

class NoticeListPage extends StatefulWidget {
  const NoticeListPage({super.key});

  @override
  State<NoticeListPage> createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoticeViewmodel>().loadNotices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
        backgroundColor: BrandColors.c900,
        actions: [
          IconButton(
            onPressed: () {
              context.read<NoticeViewmodel>().refreshNotices();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Consumer<NoticeViewmodel>(
        builder: (context, vm, child) {
          // 로딩 상태
          if (vm.isLoading && vm.notices.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // 에러 상태
          if (vm.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: StatusColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    vm.errorMessage!,
                    style: const TextStyle(
                      color: StatusColors.error,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => vm.loadNotices(),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          // 빈 목록
          if (vm.notices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: BrandColors.txt300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '등록된 공지사항이 없습니다.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: BrandColors.txt300),
                  ),
                ],
              ),
            );
          }
          // 공지사항 목록
          return RefreshIndicator(
            onRefresh: vm.refreshNotices,
            color: SecondaryColors.c500Default,
            backgroundColor: BrandColors.c800,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: vm.sortedNotices.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notice = vm.sortedNotices[index];
                return _NoticeCard(notice: notice);
              },
            ),
          );
        },
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final Notice notice;

  const _NoticeCard({required this.notice});

  @override
  Widget build(BuildContext context) {
    final dataFormat = DateFormat('yyyy.MM.dd');
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoticeDetailPage(notice: notice),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BrandColors.c800,
          border: Border.all(
            color: notice.isImportant
                ? SecondaryColors.c500Default.withValues(alpha: 0.3)
                : StrokeColors.defaultStroke,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 중요 뱃지
                if (notice.isImportant) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: SecondaryColors.c500Default,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '중요',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: BrandColors.c900,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],

                // 제목
                Expanded(
                  child: Text(
                    notice.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: BrandColors.txtWhite,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.chevron_right, color: BrandColors.txt300, size: 24),
              ],
            ),
            const SizedBox(height: 12),
            // 날짜
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: BrandColors.txt300),
                const SizedBox(width: 6),
                Text(
                  dataFormat.format(notice.createdAt),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: BrandColors.txt300),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
