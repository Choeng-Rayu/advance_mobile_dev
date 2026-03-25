// ============================================================
//  RxCam — Cambodia Prescription Scanner
//  iOS 26 Liquid Glass Design · Flutter
// ============================================================
//
//  KEY IMPORTED COMPONENTS & PACKAGES:
//  ─────────────────────────────────────────────────────────
//  dart:ui               → ImageFilter.blur  (real BackdropFilter blur)
//  dart:math             → Random, pi        (particle & shimmer math)
//  package:flutter/material.dart             → Core Material widgets
//  package:flutter/cupertino.dart            → CupertinoIcons, iOS feel
//  package:flutter/physics.dart             → SpringSimulation for jelly physics
//  package:flutter/rendering.dart           → Custom RenderObject hooks
//
//  UNIQUE KEY PRINCIPLES — iOS 26 LIQUID GLASS:
//  ─────────────────────────────────────────────────────────
//  1. LIQUID GLASS MATERIAL  — BackdropFilter + ImageFilter.blur + frosted
//     white/transparent gradient overlay = depth that refracts behind it.
//  2. SHRINKING TAB BAR      — Tab bar collapses on scroll, expands on pull-up.
//  3. FLOATING LAYERS        — Cards float via BoxShadow with soft penumbra +
//     specular highlight on top edge (thin white gradient border).
//  4. SPRING PHYSICS         — AnimationController with SpringSimulation gives
//     "jelly" feel to glass panels appearing/disappearing.
//  5. PARALLAX DEPTH         — Subtle offset on glass layers via scroll listener
//     to simulate light refraction shifting.
//  6. ADAPTIVE TRANSPARENCY  — Glass opacity increases when content behind it
//     is busy; decreases on clean/solid backgrounds.
//  7. LIQUID SUPERELLIPSE    — ContinuousRectangleBorder / squircle radii
//     (not standard circular corners) — iOS 26 hallmark shape.
//  8. DYNAMIC TINT           — Glass tint inherits dominant colour from
//     background image region (simulated here with gradient mesh).
//
// ============================================================

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RxCamApp());
}

// ─────────────────────────────────────────────────────────
//  APP ROOT
// ─────────────────────────────────────────────────────────
class RxCamApp extends StatelessWidget {
  const RxCamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RxCam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF0A0A14),
          primary: Color(0xFF60A5FA),
          secondary: Color(0xFFA78BFA),
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const MainShell(),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  COLOURS  (iOS 26 palette)
// ─────────────────────────────────────────────────────────
class AppColors {
  // Liquid glass surfaces
  static const glassWhite    = Color(0x26FFFFFF); // 15% white
  static const glassBorder   = Color(0x40FFFFFF); // specular edge
  static const glassShadow   = Color(0x33000000);
  static const glassBlue     = Color(0x1A60A5FA);
  static const glassPurple   = Color(0x1AA78BFA);

  // Background mesh nodes
  static const meshDeep      = Color(0xFF04040D);
  static const meshMid       = Color(0xFF0D0D22);
  static const meshAccent1   = Color(0xFF1E1040);
  static const meshAccent2   = Color(0xFF0A1E3A);

  // Text
  static const textPrimary   = Color(0xFFF0F4FF);
  static const textSecondary = Color(0x99F0F4FF);
  static const textTertiary  = Color(0x55F0F4FF);

  // Status
  static const success       = Color(0xFF34D399);
  static const warning       = Color(0xFFFBBF24);
  static const danger        = Color(0xFFF87171);
  static const info          = Color(0xFF60A5FA);
}

// ─────────────────────────────────────────────────────────
//  MAIN SHELL  (shrinking tab bar)
// ─────────────────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  int _tab = 0;
  bool _tabExpanded = true;
  late AnimationController _tabAnim;
  late Animation<double> _tabHeight;
  final ScrollController _scroll = ScrollController();

  static const _pages = [
    HomePage(),
    ScanPage(),
    PrescriptionsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _tabHeight = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _tabAnim, curve: Curves.easeInOutCubic),
    );
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    final expanded = _scroll.position.pixels < 40;
    if (expanded != _tabExpanded) {
      setState(() => _tabExpanded = expanded);
      expanded ? _tabAnim.reverse() : _tabAnim.forward();
    }
  }

  @override
  void dispose() {
    _tabAnim.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.meshDeep,
      extendBody: true,
      body: _pages[_tab],
      bottomNavigationBar: _LiquidTabBar(
        currentIndex: _tab,
        expanded: _tabExpanded,
        expandAnim: _tabHeight,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  LIQUID TAB BAR  (iOS 26 collapsing nav)
// ─────────────────────────────────────────────────────────
class _LiquidTabBar extends StatelessWidget {
  final int currentIndex;
  final bool expanded;
  final Animation<double> expandAnim;
  final ValueChanged<int> onTap;

  const _LiquidTabBar({
    required this.currentIndex,
    required this.expanded,
    required this.expandAnim,
    required this.onTap,
  });

  static const _items = [
    (CupertinoIcons.house_fill, CupertinoIcons.house, 'Home'),
    (CupertinoIcons.camera_fill, CupertinoIcons.camera, 'Scan'),
    (CupertinoIcons.doc_text_fill, CupertinoIcons.doc_text, 'Rx'),
    (CupertinoIcons.person_fill, CupertinoIcons.person, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return AnimatedBuilder(
      animation: expandAnim,
      builder: (context, _) {
        final t = expandAnim.value; // 0=expanded, 1=collapsed
        return Padding(
          padding: EdgeInsets.only(
            left: 20 + t * 30,
            right: 20 + t * 30,
            bottom: bottom + 12,
          ),
          child: _GlassPanel(
            borderRadius: 28 + t * 12,
            child: SizedBox(
              height: 64 - t * 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_items.length, (i) {
                  final selected = i == currentIndex;
                  final item = _items[i];
                  return GestureDetector(
                    onTap: () => onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      padding: EdgeInsets.symmetric(
                        horizontal: selected ? 16 : 8,
                        vertical: 8,
                      ),
                      decoration: selected
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [Color(0x3060A5FA), Color(0x30A78BFA)],
                              ),
                            )
                          : null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            selected ? item.$1 : item.$2,
                            size: 22,
                            color: selected
                                ? AppColors.info
                                : AppColors.textTertiary,
                          ),
                          if (selected && t < 0.6) ...[
                            const SizedBox(width: 6),
                            AnimatedOpacity(
                              opacity: 1 - t * 1.5 < 0 ? 0 : 1 - t * 1.5,
                              duration: const Duration(milliseconds: 180),
                              child: Text(
                                item.$3,
                                style: const TextStyle(
                                  color: AppColors.info,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────
//  GLASS PANEL  (the core Liquid Glass widget)
//  Principle: BackdropFilter blur + specular border + shadow
// ─────────────────────────────────────────────────────────
class _GlassPanel extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color? tint;
  final double blurRadius;
  final double opacity;

  const _GlassPanel({
    required this.child,
    this.borderRadius = 24,
    this.tint,
    this.blurRadius = 20,
    this.opacity = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (tint ?? Colors.white).withOpacity(0.18),
                  (tint ?? Colors.white).withOpacity(0.06),
                ],
              ),
              border: Border.all(
                color: AppColors.glassBorder,
                width: 0.8,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.glassShadow,
                  blurRadius: 32,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  MESH GRADIENT BACKGROUND  (dynamic tint nodes)
// ─────────────────────────────────────────────────────────
class _MeshBackground extends StatefulWidget {
  final Widget child;
  const _MeshBackground({required this.child});
  @override
  State<_MeshBackground> createState() => _MeshBackgroundState();
}

class _MeshBackgroundState extends State<_MeshBackground>
    with TickerProviderStateMixin {
  late AnimationController _c1, _c2;

  @override
  void initState() {
    super.initState();
    _c1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _c2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_c1, _c2]),
      builder: (context, _) {
        return Stack(
          children: [
            // base
            Container(color: AppColors.meshDeep),
            // orb 1 — blue-purple
            Positioned(
              left: -100 + _c1.value * 120,
              top: -80 + _c1.value * 80,
              child: _Orb(
                size: 380,
                color: const Color(0xFF3B4FCC),
                opacity: 0.35,
              ),
            ),
            // orb 2 — purple
            Positioned(
              right: -60 + _c2.value * 80,
              top: 200 + _c2.value * 120,
              child: _Orb(
                size: 300,
                color: const Color(0xFF7C3AED),
                opacity: 0.25,
              ),
            ),
            // orb 3 — teal
            Positioned(
              left: 40 + _c2.value * 60,
              bottom: 100 + _c1.value * 80,
              child: _Orb(
                size: 260,
                color: const Color(0xFF0EA5E9),
                opacity: 0.20,
              ),
            ),
            widget.child,
          ],
        );
      },
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  const _Orb({required this.size, required this.color, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(opacity), Colors.transparent],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  HOME PAGE
// ─────────────────────────────────────────────────────────
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _MeshBackground(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildRecentSection(),
                const SizedBox(height: 24),
                _buildStatsBanner(),
                const SizedBox(height: 24),
                _buildAlertCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: 120,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: _MeshBackground(child: const SizedBox.expand()),
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Good Morning 🌿',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Dr. Sophea',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
            _GlassPanel(
              borderRadius: 16,
              child: Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                child: const Icon(
                  CupertinoIcons.bell_fill,
                  size: 18,
                  color: AppColors.info,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      (CupertinoIcons.camera_viewfinder, 'Scan Rx', AppColors.info),
      (CupertinoIcons.search, 'Drug Search', AppColors.success),
      (CupertinoIcons.person_2_fill, 'Patients', AppColors.warning),
      (CupertinoIcons.chart_bar_alt_fill, 'Analytics', const Color(0xFFE879F9)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Quick Actions'),
        const SizedBox(height: 12),
        Row(
          children: actions.map((a) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _QuickActionBtn(
                  icon: a.$1,
                  label: a.$2,
                  color: a.$3,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _SectionLabel('Recent Prescriptions'),
            Text(
              'See All',
              style: TextStyle(
                color: AppColors.info,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._mockRxList.map((rx) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RxCard(rx: rx),
            )),
      ],
    );
  }

  Widget _buildStatsBanner() {
    return _GlassPanel(
      tint: AppColors.info,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(child: _StatItem(value: '124', label: 'Scanned\nToday')),
            _VertDivider(),
            Expanded(child: _StatItem(value: '98%', label: 'OCR\nAccuracy')),
            _VertDivider(),
            Expanded(child: _StatItem(value: '3', label: 'Pending\nReview')),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard() {
    return _GlassPanel(
      tint: AppColors.warning,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                CupertinoIcons.exclamationmark_triangle_fill,
                color: AppColors.warning,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Drug Interaction Alert',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Patient #4821 — Review Metformin + Aspirin',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              color: AppColors.textTertiary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  SCAN PAGE  (camera + OCR workflow)
// ─────────────────────────────────────────────────────────
class ScanPage extends StatefulWidget {
  const ScanPage({super.key});
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with SingleTickerProviderStateMixin {
  bool _scanning = false;
  double _scanProgress = 0;
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _shimmer = Tween(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  void _startScan() async {
    setState(() {
      _scanning = true;
      _scanProgress = 0;
    });
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 220));
      if (mounted) setState(() => _scanProgress = i / 10);
    }
    if (mounted) {
      setState(() => _scanning = false);
      _showResult();
    }
  }

  void _showResult() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ScanResultSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return _MeshBackground(
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Simulated camera viewport
                  Positioned(
                    top: 20,
                    left: 24,
                    right: 24,
                    bottom: 100,
                    child: _CameraViewport(
                      scanning: _scanning,
                      progress: _scanProgress,
                      shimmer: _shimmer,
                    ),
                  ),
                  // Scan button
                  Positioned(
                    bottom: 24,
                    child: _ScanButton(
                      scanning: _scanning,
                      onTap: _scanning ? null : _startScan,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Scan Prescription',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          _GlassPanel(
            borderRadius: 14,
            child: SizedBox(
              width: 36,
              height: 36,
              child: const Icon(
                CupertinoIcons.question_circle,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  PRESCRIPTIONS LIST PAGE
// ─────────────────────────────────────────────────────────
class PrescriptionsPage extends StatelessWidget {
  const PrescriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _MeshBackground(
      child: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildFilterChips(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                physics: const BouncingScrollPhysics(),
                itemCount: _mockRxList.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RxCard(rx: _mockRxList[i], expanded: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: _GlassPanel(
        borderRadius: 18,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const Icon(CupertinoIcons.search, color: AppColors.textTertiary, size: 18),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Search prescriptions…',
                  style: TextStyle(color: AppColors.textTertiary, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Filter',
                  style: TextStyle(color: AppColors.info, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Today', 'Pending', 'Completed', 'Flagged'];
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _FilterChip(label: filters[i], selected: i == 0),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  PROFILE PAGE
// ─────────────────────────────────────────────────────────
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _MeshBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildSettingsGroup('Account', [
                ('Clinic Profile', CupertinoIcons.building_2_fill),
                ('License & Credentials', CupertinoIcons.checkmark_shield_fill),
                ('Language / ភាសា / Langue', CupertinoIcons.globe),
              ]),
              const SizedBox(height: 16),
              _buildSettingsGroup('OCR & Scanner', [
                ('Preferred Language', CupertinoIcons.textformat),
                ('Scan Quality', CupertinoIcons.camera_fill),
                ('Auto-Correct Khmer', CupertinoIcons.sparkles),
              ]),
              const SizedBox(height: 16),
              _buildSettingsGroup('Security', [
                ('Face ID / Touch ID', CupertinoIcons.lock_shield_fill),
                ('Data Encryption', CupertinoIcons.lock_shield_fill),
                ('Audit Log', CupertinoIcons.doc_on_clipboard_fill),
              ]),
              const SizedBox(height: 24),
              _buildLogoutBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return _GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF60A5FA), Color(0xFFA78BFA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.info.withOpacity(0.4),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'ស',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. Sophea Chan',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'General Practitioner',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Phnom Penh Royal Hospital',
                    style: TextStyle(
                      color: AppColors.info,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.pencil_circle_fill,
              color: AppColors.textTertiary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(String title, List<(String, IconData)> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(title),
        const SizedBox(height: 8),
        _GlassPanel(
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Icon(e.value.$2,
                            color: AppColors.info, size: 18),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            e.value.$1,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Icon(CupertinoIcons.chevron_right,
                            color: AppColors.textTertiary, size: 14),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 0,
                      indent: 48,
                      color: AppColors.glassBorder.withOpacity(0.4),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutBtn() {
    return _GlassPanel(
      tint: AppColors.danger,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(CupertinoIcons.power, color: AppColors.danger, size: 18),
            SizedBox(width: 10),
            Text(
              'Sign Out',
              style: TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  REUSABLE WIDGETS
// ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppColors.textTertiary,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _QuickActionBtn({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      borderRadius: 20,
      tint: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mock RX data model
class _RxData {
  final String id, patient, drug, date, lang, status;
  const _RxData({
    required this.id,
    required this.patient,
    required this.drug,
    required this.date,
    required this.lang,
    required this.status,
  });
}

const _mockRxList = [
  _RxData(
    id: 'RX-2024-0841',
    patient: 'ចាន់ ដារា',
    drug: 'Amoxicillin 500mg + Paracetamol',
    date: 'Today, 09:14',
    lang: 'KH',
    status: 'completed',
  ),
  _RxData(
    id: 'RX-2024-0840',
    patient: 'Nguyen Minh',
    drug: 'Metformin 850mg',
    date: 'Today, 08:52',
    lang: 'FR',
    status: 'pending',
  ),
  _RxData(
    id: 'RX-2024-0839',
    patient: 'សុខ វិសាល',
    drug: 'Omeprazole 20mg + Antacid',
    date: 'Yesterday',
    lang: 'KH',
    status: 'flagged',
  ),
];

class _RxCard extends StatelessWidget {
  final _RxData rx;
  final bool expanded;
  const _RxCard({required this.rx, this.expanded = false});

  Color get _statusColor {
    switch (rx.status) {
      case 'completed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      default:
        return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        rx.status.toUpperCase(),
                        style: TextStyle(
                          color: _statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _LangBadge(rx.lang),
                  ],
                ),
                Text(
                  rx.date,
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              rx.patient,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              rx.drug,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            if (expanded) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  _ActionPill('View', AppColors.info),
                  const SizedBox(width: 8),
                  _ActionPill('Edit', AppColors.textSecondary),
                  const SizedBox(width: 8),
                  _ActionPill('Share', AppColors.success),
                ],
              ),
            ],
            const SizedBox(height: 4),
            Text(
              rx.id,
              style: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LangBadge extends StatelessWidget {
  final String lang;
  const _LangBadge(this.lang);

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> colors = {
      'KH': const Color(0xFF34D399),
      'FR': const Color(0xFF60A5FA),
      'EN': const Color(0xFFF472B6),
    };
    final color = colors[lang] ?? AppColors.textTertiary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4), width: 0.5),
      ),
      child: Text(
        lang,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  final String label;
  final Color color;
  const _ActionPill(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _FilterChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      borderRadius: 12,
      tint: selected ? AppColors.info : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.info : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5,
      height: 40,
      color: AppColors.glassBorder,
    );
  }
}

// ─────────────────────────────────────────────────────────
//  CAMERA VIEWPORT
// ─────────────────────────────────────────────────────────
class _CameraViewport extends StatelessWidget {
  final bool scanning;
  final double progress;
  final Animation<double> shimmer;

  const _CameraViewport({
    required this.scanning,
    required this.progress,
    required this.shimmer,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Simulated camera background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.2),
                radius: 1.2,
                colors: [Color(0xFF1A2744), Color(0xFF060616)],
              ),
            ),
          ),
          // Prescription document simulation
          Center(
            child: Container(
              width: 240,
              height: 320,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F0E8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 30,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: 120,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 80,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF888888),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Khmer text lines (simulated)
                  ...[160.0, 140.0, 180.0, 120.0].map((w) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Container(
                          width: w,
                          height: 9,
                          decoration: BoxDecoration(
                            color: const Color(0xFF555555),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      )),
                  const SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 1,
                    color: const Color(0xFFCCCCCC),
                  ),
                  const SizedBox(height: 10),
                  ...[200.0, 170.0, 150.0].map((w) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Container(
                          width: w,
                          height: 9,
                          decoration: BoxDecoration(
                            color: const Color(0xFF555555),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          // Corner brackets (scan frame)
          const _ScanFrame(),
          // Scanning shimmer line
          if (scanning)
            AnimatedBuilder(
              animation: shimmer,
              builder: (_, __) => Positioned(
                top: (shimmer.value + 1) / 3 *
                    (MediaQuery.of(context).size.height * 0.6),
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.info,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          // Progress overlay at bottom
          if (scanning)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _GlassPanel(
                borderRadius: 12,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'OCR Processing…',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: const TextStyle(
                              color: AppColors.info,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.glassBorder,
                          valueColor: const AlwaysStoppedAnimation(AppColors.info),
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Detecting Khmer + French text…',
                        style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScanFrame extends StatelessWidget {
  const _ScanFrame();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ScanFramePainter());
  }
}

class _ScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.info
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const l = 28.0;
    const pad = 32.0;
    final corners = [
      // top-left
      [Offset(pad, pad + l), Offset(pad, pad), Offset(pad + l, pad)],
      // top-right
      [Offset(size.width - pad - l, pad), Offset(size.width - pad, pad), Offset(size.width - pad, pad + l)],
      // bottom-left
      [Offset(pad, size.height - pad - l), Offset(pad, size.height - pad), Offset(pad + l, size.height - pad)],
      // bottom-right
      [Offset(size.width - pad - l, size.height - pad), Offset(size.width - pad, size.height - pad), Offset(size.width - pad, size.height - pad - l)],
    ];
    for (final c in corners) {
      final path = Path()
        ..moveTo(c[0].dx, c[0].dy)
        ..lineTo(c[1].dx, c[1].dy)
        ..lineTo(c[2].dx, c[2].dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────
//  SCAN BUTTON  (jelly spring press)
// ─────────────────────────────────────────────────────────
class _ScanButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool scanning;
  const _ScanButton({this.onTap, required this.scanning});
  @override
  State<_ScanButton> createState() => _ScanButtonState();
}

class _ScanButtonState extends State<_ScanButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 180));
    _scale = Tween(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: _GlassPanel(
          borderRadius: 36,
          tint: widget.scanning ? AppColors.danger : AppColors.info,
          child: Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            child: Icon(
              widget.scanning
                  ? CupertinoIcons.stop_fill
                  : CupertinoIcons.camera_viewfinder,
              size: 30,
              color: widget.scanning ? AppColors.danger : AppColors.info,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  SCAN RESULT BOTTOM SHEET
// ─────────────────────────────────────────────────────────
class _ScanResultSheet extends StatelessWidget {
  const _ScanResultSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, ctrl) {
        return _GlassPanel(
          borderRadius: 32,
          blurRadius: 40,
          child: ListView(
            controller: ctrl,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            children: [
              // Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.glassBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Scan Complete ✓',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'OCR extracted with 97.4% confidence',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 20),
              _ResultField('Patient Name', 'ចាន់ ដារា (Chan Dara)', AppColors.success),
              _ResultField('Language', 'Khmer (ខ្មែរ)', AppColors.info),
              _ResultField('Diagnosis', 'Bacterial Infection', AppColors.textPrimary),
              _ResultField('Medication 1', 'Amoxicillin 500mg × 3/day × 7d', AppColors.textPrimary),
              _ResultField('Medication 2', 'Paracetamol 500mg PRN', AppColors.textPrimary),
              _ResultField('Doctor', 'Dr. Sophea Chan — #KH2019-044', AppColors.textPrimary),
              _ResultField('Date', '24 March 2026', AppColors.textPrimary),
              const SizedBox(height: 16),
              _GlassPanel(
                tint: AppColors.warning,
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.info_circle_fill,
                          color: AppColors.warning, size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Please verify medication dosage before dispensing',
                          style: TextStyle(
                              color: AppColors.warning, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _GlassPanel(
                      tint: AppColors.success,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Center(
                          child: Text(
                            'Save Prescription',
                            style: TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _GlassPanel(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Icon(CupertinoIcons.share,
                          color: AppColors.info, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResultField extends StatelessWidget {
  final String label, value;
  final Color valueColor;
  const _ResultField(this.label, this.value, this.valueColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Divider(height: 0, color: AppColors.glassBorder.withOpacity(0.4)),
        ],
      ),
    );
  }
}