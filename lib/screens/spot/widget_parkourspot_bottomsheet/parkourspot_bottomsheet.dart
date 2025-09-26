import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/spot_ui.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/spot_info_helper.dart';

class DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: BrandColors.txt300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final SpotUiModel model;

  const HeaderSection({required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.displayName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: BrandColors.txtWhite,
          ),
        ),
        SizedBox(height: 4),
        if (model.hasAddress) _AddressRow(address: model.spot.address),
        SizedBox(height: 8),
        if (model.hasTags) _TagsRow(tags: model.spot.tags),
      ],
    );
  }
}

class _AddressRow extends StatelessWidget {
  final String address;

  const _AddressRow({required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, size: 16, color: BrandColors.txt300),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            address,
            style: TextStyle(fontSize: 14, color: BrandColors.txt300),
          ),
        ),
      ],
    );
  }
}

class _TagsRow extends StatelessWidget {
  final List<String> tags;

  const _TagsRow({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: tags.take(3).map((tag) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: SecondaryColors.c500Default.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: SecondaryColors.c500Default),
          ),
          child: Text(
            '#$tag',
            style: TextStyle(
              fontSize: 12,
              color: SecondaryColors.c500Default,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ImageSection extends StatelessWidget {
  final SpotUiModel model;

  const ImageSection({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: BrandColors.c700,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _SpotImage(model: model),
      ),
    );
  }
}

class _SpotImage extends StatelessWidget {
  final SpotUiModel model;

  const _SpotImage({required this.model});

  @override
  Widget build(BuildContext context) {
    final imageModel = model.imageModel;

    if (imageModel.isLoading) {
      return _LoadingImage();
    }

    // Firestore 이미지 우선
    if (model.hasFirestoreImages) {
      return Image.network(
        model.spot.imageUrls.first,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return _GoogleImage(model: model);
        },
      );
    }

    return _GoogleImage(model: model);
  }
}

class _LoadingImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: BrandColors.c700,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(BrandColors.c500),
              ),
            ),
            SizedBox(height: 12),
            Text(
              '장소 이미지 로딩 중...',
              style: TextStyle(color: BrandColors.txt300, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleImage extends StatelessWidget {
  final SpotUiModel model;

  const _GoogleImage({required this.model});

  @override
  Widget build(BuildContext context) {
    if (model.imageModel.hasImage) {
      return Stack(
        children: [
          Image.network(
            model.imageModel.imageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return _DefaultImage(category: model.spot.category);
            },
          ),
          // Google Attribution (필수!)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(179),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Google',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return _DefaultImage(category: model.spot.category);
  }
}

class _DefaultImage extends StatelessWidget {
  final String category;

  const _DefaultImage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BrandColors.c700,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            SpotInfoHelper.getCategoryIcon(category),
            size: 48,
            color: BrandColors.c300,
          ),
          SizedBox(height: 8),
          Text(
            SpotInfoHelper.getCategoryText(category),
            style: TextStyle(
              color: BrandColors.c200,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}