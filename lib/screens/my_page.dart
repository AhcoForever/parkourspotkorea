import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';
import 'package:parkourspotkorea/widgets/background_wrapper.dart';
import 'package:parkourspotkorea/widgets/settings_bottom_sheet.dart';
import 'package:parkourspotkorea/viewmodels/my_page_viewmodel.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyPageViewModel(),
      child: _MyPageView(),
    );
  }
}

class _MyPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyPageViewModel>(
      builder: (context, viewModel, child) {
        return _buildScaffold(context, viewModel);
      },
    );
  }

  void _showSkillLevelDialog(BuildContext context, MyPageViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: BrandColors.c800,
          title: Text(
            '파쿠르 숙련도 선택',
            style: TextStyle(
              color: BrandColors.txtWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSkillLevelOption(context, viewModel, '트레이서', '파쿠르를 처음 시작하는 단계'),
              SizedBox(height: 8),
              _buildSkillLevelOption(context, viewModel, '프리러너', '기본적인 동작들을 익힌 단계'),
              SizedBox(height: 8),
              _buildSkillLevelOption(context, viewModel, '야막', '다양한 기술을 자유롭게 구사하는 단계'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: TextStyle(color: BrandColors.txt300),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkillLevelOption(BuildContext context, MyPageViewModel viewModel, String level, String description) {
    final isSelected = viewModel.isSkillLevelSelected(level);

    return InkWell(
      onTap: () {
        viewModel.updateSkillLevel(level);
        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? SecondaryColors.c500Default.withValues(alpha: 0.1) : BrandColors.c700,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? SecondaryColors.c500Default : StrokeColors.defaultStroke,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              level,
              style: TextStyle(
                color: isSelected ? SecondaryColors.c500Default : BrandColors.txtWhite,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: BrandColors.txt300,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildScaffold(BuildContext context, MyPageViewModel viewModel) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: BrandColors.c900,
      appBar: AppBar(
        title: Text(
          '마이 페이지',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: BrandColors.c900,
        foregroundColor: BrandColors.txt30,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: BrandColors.txt30),
            onPressed: () => SettingsBottomSheet.show(context),
          ),
        ],
      ),
      body: SafeArea(
        child: viewModel.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: SecondaryColors.c500Default,
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Center(
                  child: BackgroundWrapper(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 프로필 사진 (맨 위)
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: SecondaryColors.c500Default,
                              width: 4,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: viewModel.isEditing ? viewModel.pickImage : null,
                            child: CircleAvatar(
                              radius: 75,
                              backgroundColor: BrandColors.c700,
                              backgroundImage: viewModel.getProfileImage(),
                              child: viewModel.getProfileImage() == null
                                  ? Icon(
                                      Icons.person,
                                      size: 60,
                                      color: BrandColors.txt300,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // 닉네임과 편집 아이콘
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: viewModel.isEditing
                                  ? TextField(
                                      controller: viewModel.nicknameController,
                                      textAlign: TextAlign.center,
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: BrandColors.txtWhite,
                                        fontSize: 24,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '닉네임 입력',
                                        hintStyle: TextStyle(
                                          fontSize: 24,
                                          color: BrandColors.txt300,
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: StrokeColors.defaultStroke,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: StrokeColors.defaultStroke,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: SecondaryColors.c500Default,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      viewModel.nicknameController.text.isEmpty
                                          ? '닉네임을 설정해주세요'
                                          : viewModel.nicknameController.text,
                                      style: TextStyle(
                                        color: viewModel.nicknameController.text.isEmpty
                                            ? BrandColors.txt300
                                            : BrandColors.txtWhite,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                        height: 1.50,
                                      ),
                                    ),
                            ),
                            if (viewModel.isEditing) ...[
                              IconButton(
                                icon: Icon(Icons.close, color: BrandColors.txt300),
                                onPressed: viewModel.cancelEdit,
                              ),
                              IconButton(
                                icon: Icon(Icons.check, color: SecondaryColors.c500Default),
                                onPressed: viewModel.toggleEdit,
                              ),
                            ] else
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/icons/iconamoon_edit-light.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                onPressed: viewModel.toggleEdit,
                              ),
                          ],
                        ),
                        SizedBox(height: 30),
                        viewModel.isEditing
                            ? TextField(
                                controller: viewModel.introController,
                                maxLines: 4,
                                style: TextStyle(
                                  color: BrandColors.txtWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: BrandColors.c800,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                      color: StatusColors.notification,
                                    ),
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                      color: SecondaryColors.c500Default,
                                      width: 2,
                                    ),
                                  ),
                                  hintText: '소개를 입력하세요',
                                  hintStyle: TextStyle(
                                    color: BrandColors.txtWhite,
                                  ),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: BrandColors.c800,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  viewModel.introController.text,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: BrandColors.txtWhite,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                        SizedBox(height: 12),
                        InkWell(
                          onTap: () {
                            // 파쿠르 숙련도 변경 로직
                            _showSkillLevelDialog(context, viewModel);
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: BrandColors.c800,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '파쿠르 숙련도 변경',
                                  style: TextStyle(
                                    color: BrandColors.txtWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: SecondaryColors.c500Default,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    viewModel.userProfile?['skillLevel'] ?? '트레이서',
                                    style: TextStyle(
                                      color: SecondaryColors.c500Default,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: BrandColors.txt300,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

}
