import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  bool _isButtonClicked = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: BrandColors.c900,
      appBar: AppBar(
        backgroundColor: BrandColors.c900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: BrandColors.txtWhite),
          onPressed: () => context.goNamed('map'),
        ),
        title: Text(
          '나만의 파쿠르 스팟',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // 새 장소 추가 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isButtonClicked = true;
                  });
                  // 새 장소 추가 기능
                  print('새 장소 추가 버튼 클릭');
                },
                icon: Icon(
                  Icons.add_rounded,
                  color: BrandColors.c900,
                  size: 24,
                ),
                label: Text(
                  '새 장소 추가',
                  style: TextStyle(
                    color: BrandColors.c900,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonClicked
                      ? SecondaryColors.c700
                      : SecondaryColors.c500Default,
                  foregroundColor: BrandColors.txtWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('나만의 파쿠르 스팟',
              style: TextStyle(
                color: BrandColors.txt100,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),),
            ),
          ),
          // 메인 컨텐츠 영역
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 안내 텍스트
                  Text(
                    '아직 저장된 파쿠르 장소가 없어요.',
                    style: TextStyle(
                      color: BrandColors.normal,
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
