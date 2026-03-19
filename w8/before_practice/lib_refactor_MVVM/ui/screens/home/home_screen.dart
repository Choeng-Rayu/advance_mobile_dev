import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../states/ride_perference_state.dart';
import 'home_content.dart';
import 'home_view_model.dart';

/// Home Screen - Entry point for home feature
/// Uses Provider pattern to manage state
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // Create ViewModel with access to RidePreferenceState
    _viewModel = HomeViewModel(
      ridePreferenceState: context.read<RidePreferenceState>(),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BlaBlaCar'), centerTitle: true),
      body: ChangeNotifierProvider<HomeViewModel>.value(
        value: _viewModel,
        child: Consumer<HomeViewModel>(
          builder: (context, viewModel, _) {
            return HomeContent(
              viewModel: viewModel,
              onAddNewPreference: () {
                // TODO: Navigate to preference selection screen
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Add new search')));
              },
            );
          },
        ),
      ),
    );
  }
}
