import 'package:flutter/material.dart';
import 'package:parkourspotkorea/screens/spot/widget_parkourspot_bottomsheet/action_buttons.dart';
import 'package:parkourspotkorea/screens/spot/widget_parkourspot_bottomsheet/detail_section.dart';
import 'package:parkourspotkorea/screens/spot/widget_parkourspot_bottomsheet/error_message.dart';
import 'package:parkourspotkorea/screens/spot/widget_parkourspot_bottomsheet/parkourspot_bottomsheet.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '../../model/parkour_spot.dart';
import '../../model/spot_ui.dart';
import '../../viewmodel/spot_bottom_sheet_viewmodel.dart';

class ParkourSpotBottomSheet extends StatefulWidget {
  final ParkourSpot spot;
  final VoidCallback? onClose;

  const ParkourSpotBottomSheet({
    Key? key,
    required this.spot,
    this.onClose,
  }) : super(key: key);

  @override
  State<ParkourSpotBottomSheet> createState() => _ParkourSpotBottomSheetState();
}

class _ParkourSpotBottomSheetState extends State<ParkourSpotBottomSheet> {
  late SpotBottomSheetViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SpotBottomSheetViewModel(spot: widget.spot);
    _viewModel.initialize();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<SpotBottomSheetViewModel>(
        builder: (context, viewModel, child) {
          return Container(
            decoration: BoxDecoration(
              color: BrandColors.c800,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DragHandle(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderSection(model: viewModel.spotUiModel),
                        SizedBox(height: 16),
                        ImageSection(model: viewModel.spotUiModel),
                        SizedBox(height: 16),
                        DetailSection(model: viewModel.spotUiModel),
                        SizedBox(height: 20),
                        ActionButtons(viewModel: viewModel),
                        if (viewModel.errorMessage != null) ...[
                          SizedBox(height: 16),
                          ErrorMessage(message: viewModel.errorMessage!),
                        ],
                        SizedBox(height: MediaQuery.of(context).padding.bottom),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
class ParkourBottomSheetHelper {
  static Future<void> show(
      BuildContext context,
      ParkourSpot spot, {
        VoidCallback? onClose,
      }) async {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        snap: true,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) {
          return ParkourSpotBottomSheet(spot: spot, onClose: onClose);
        },
      ),
    ).then((_) {
      onClose?.call();
    });
  }
}