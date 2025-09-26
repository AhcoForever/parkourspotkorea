import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/spot_ui.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/spot_info_helper.dart';

class DetailSection extends StatelessWidget {
  final SpotUiModel model;

  const DetailSection({required this.model});

  @override
  Widget build(BuildContext context) {
    final spot = model.spot;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DetailRow(
          icon: Icons.fitness_center,
          label: '난이도',
          value: SpotInfoHelper.getDifficultyText(spot.difficulty),
          valueColor: SpotInfoHelper.getDifficultyColor(spot.difficulty),
        ),
        SizedBox(height: 12),
        _DetailRow(
          icon: Icons.category,
          label: '카테고리',
          value: SpotInfoHelper.getCategoryText(spot.category),
        ),
        SizedBox(height: 12),
        _DetailRow(
          icon: Icons.map,
          label: '좌표',
          value: model.formattedCoordinates,
        ),
        if (model.hasDescription) ...[
          SizedBox(height: 16),
          Text(
            '설명',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: BrandColors.txtWhite,
            ),
          ),
          SizedBox(height: 8),
          Text(
            spot.description,
            style: TextStyle(
              fontSize: 14,
              color: BrandColors.txt100,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: BrandColors.txt300),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: BrandColors.txt300,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? BrandColors.txtWhite,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}