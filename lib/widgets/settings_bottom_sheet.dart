import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';
import 'package:parkourspotkorea/constants/app_constants.dart';

class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BrandColors.c800,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 드래그 핸들
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: BrandColors.txt300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 제목
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              '설정',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: BrandColors.txt30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // 메뉴 아이템들
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _SettingsMenuItem(
                  title: '비밀번호 변경',
                  icon: Icons.key_outlined,
                  onTap: () {
                    context.goNamed('find');
                  },
                ),
                _SettingsMenuItem(
                  title: '공지사항',
                  icon: Icons.notifications_rounded,
                  onTap: () {
                    context.goNamed('notice');
                  },
                ),
                _SettingsMenuItem(
                  title: '로그아웃',
                  icon: Icons.logout,
                  onTap: () {
                    Navigator.pop(context);
                    // 로그아웃 로직
                  },
                ),
                _SettingsMenuItem(
                  title: '고객 지원',
                  icon: Icons.help_outline,
                  onTap: () {
                    Navigator.pop(context);
                    context.pushNamed('customerService');
                  },
                ),
                _SettingsMenuItem(
                  title: '만든이 정보',
                  icon: Icons.list_rounded,
                  onTap: () {
                    context.goNamed('aboutCreator');
                  },
                ),
                _SettingsMenuItem(
                  title: '회원 탈퇴',
                  icon: Icons.person_off_outlined,
                  onTap: () {
                    context.goNamed('deleteAccount');
                  },
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '버전 ${AppConstants.appVersion}',
                    style: TextStyle(color: BrandColors.txtWhite, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  /// 설정 바텀시트 표시 메서드
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) => SettingsBottomSheet(),
    );
  }
}

/// 설정 메뉴 아이템 위젯
class _SettingsMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool underline;

  const _SettingsMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BrandColors.c800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: SecondaryColors.c500Default, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: textTheme.bodyLarge?.copyWith(
                  color: BrandColors.txtWhite,
                  decoration: underline
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: BrandColors.txtWhite,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: BrandColors.txt300, size: 16),
          ],
        ),
      ),
    );
  }
}
