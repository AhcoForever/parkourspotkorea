import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../viewmodel/spot_bottom_sheet_viewmodel.dart';

class ActionButtons extends StatelessWidget {
  final SpotBottomSheetViewModel viewModel;

  const ActionButtons({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: viewModel.isLoading ? null : viewModel.openDirections,
            icon: viewModel.isLoading
                ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2)
            )
                : Icon(Icons.directions),
            label: Text('길찾기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: viewModel.isLoading ? null : viewModel.toggleBookmark,
                icon: Icon(Icons.favorite_border),
                label: Text('즐겨찾기'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: viewModel.isLoading ? null : viewModel.shareSpot,
                icon: Icon(Icons.share),
                label: Text('공유'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}