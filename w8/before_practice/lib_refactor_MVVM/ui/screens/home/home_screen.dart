import 'package:flutter/material.dart';
import '../../../main.dart';
import 'home_content.dart';
import 'home_view_model.dart';

/// Home Screen - Main screen for ride preference selection
/// Listens to global RidePreferenceState to rebuild when state changes
///
/// Architecture:
/// - HomeScreen (Stateful, listens to global state)
///   └─ HomeViewModel (delegates to global state)
///       └─ HomeContent (Stateless, receives ViewModel)
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
    // Create ViewModel instance
    _viewModel = HomeViewModel();

    // Listen to global state changes
    ServiceLocator.ridePreferenceState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    // Stop listening to global state
    ServiceLocator.ridePreferenceState.removeListener(_onStateChanged);
    super.dispose();
  }

  /// Callback when global state changes - rebuild the screen
  void _onStateChanged() {
    setState(() {
      // Just trigger a rebuild - ViewModel will get fresh data from global state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomeContent(viewModel: _viewModel));
  }
}
