import 'package:flutter/material.dart';
import '../../../model/ride_preference.dart';
import '../../../ui/theme/theme.dart';
import '../../../utils/animations_util.dart';
import '../../widgets/pickers/bla_ride_preference_modal.dart';
import '../ride_selection/ride_selection_screen.dart';
import 'home_view_model.dart';
import 'widgets/home_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

/// Home Content - Displays the UI for ride preference selection
/// Separated from state management (MVVM approach)
///
/// Receives:
/// - viewModel: HomeViewModel that provides state and methods
///
/// This widget should NOT be Stateful - it gets notifications from the viewModel
class HomeContent extends StatelessWidget {
  const HomeContent({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  /// Navigate to rides selection screen
  Future<void> _onRidePrefSelected(
    BuildContext context,
    RidePreference selectedPreference,
  ) async {
    // 1 - Update the global state with the selected preference
    await viewModel.selectPreference(selectedPreference);

    // 2 - Navigate to the rides screen
    if (context.mounted) {
      await Navigator.of(context).push(
        AnimationUtils.createBottomToTopRoute(const RideSelectionScreen()),
      );
    }

    // 3 - The viewModel will notify listeners (HomeScreen will rebuild)
    // No need for setState() anymore!
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_buildBackground(), _buildForeground(context)]);
  }

  Widget _buildForeground(BuildContext context) {
    return Column(
      children: [
        // 1 - THE HEADER
        const SizedBox(height: 16),
        Align(
          alignment: AlignmentGeometry.center,
          child: Text(
            "Your pick of rides at low price",
            style: BlaTextStyles.heading.copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(height: 100),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 2 - THE FORM / PREFERENCE PICKER
              BlaRidePreferenceModal(
                onRidePreferenceSelected: (preference) =>
                    _onRidePrefSelected(context, preference),
              ),
              const SizedBox(height: BlaSpacings.m),

              // 3 - THE HISTORY
              _buildHistory(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistory(BuildContext context) {
    // Get reversed history from viewModel
    List<RidePreference> history = viewModel.getReversedHistory();

    return SizedBox(
      height: 200,
      child: history.isEmpty
          ? Center(
              child: Text(
                'No previous searches',
                style: BlaTextStyles.label.copyWith(color: BlaColors.textLight),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: history.length,
              itemBuilder: (ctx, index) => HomeHistoryTile(
                ridePref: history[index],
                onPressed: () => _onRidePrefSelected(context, history[index]),
              ),
            ),
    );
  }

  Widget _buildBackground() {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(blablaHomeImagePath, fit: BoxFit.cover),
    );
  }
}
