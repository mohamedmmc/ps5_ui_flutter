import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_routes.dart';
import '../../../data/games_data.dart';
import '../../../models/game.dart';
import '../../../utils/hero_tags.dart';
import '../../../utils/responsive.dart';

class GameDetailsScreen extends StatefulWidget {
  static const String routeName = AppRoutes.gameDetailsName;
  static const String routePath = AppRoutes.gameDetails;

  final String gameId;

  const GameDetailsScreen({
    super.key,
    required this.gameId,
  });

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _dockController;
  Timer? _launchTimer;
  Timer? _pulseStartTimer;

  _GameDetailsPhase _phase = _GameDetailsPhase.launching;
  final GlobalKey _detailsImageSlotKey = GlobalKey();
  Animation<Rect?>? _dockRectAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _pulseStartTimer = Timer(const Duration(milliseconds: 520), () {
      if (!mounted) return;
      _pulseController.repeat(reverse: true);
    });

    _dockController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() => _phase = _GameDetailsPhase.details);
        }
      });

    _launchTimer = Timer(const Duration(seconds: 3), _beginDockingToDetails);
  }

  @override
  void dispose() {
    _pulseStartTimer?.cancel();
    _launchTimer?.cancel();
    _pulseController.dispose();
    _dockController.dispose();
    super.dispose();
  }

  Game get _game {
    return games.firstWhere(
      (game) => game.id == widget.gameId,
      orElse: () => games.first,
    );
  }

  void _beginDockingToDetails() {
    if (!mounted) return;

    _pulseController.stop();
    setState(() => _phase = _GameDetailsPhase.docking);
    _resolveDockTargetAndStart();
  }

  void _resolveDockTargetAndStart([int attempt = 0]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final slotContext = _detailsImageSlotKey.currentContext;
      final overlayBox = context.findRenderObject() as RenderBox?;
      final slotBox = slotContext?.findRenderObject() as RenderBox?;
      final invalidTarget =
          overlayBox == null || slotBox == null || slotBox.size.isEmpty;

      if (invalidTarget) {
        if (attempt < 8) {
          _resolveDockTargetAndStart(attempt + 1);
          return;
        }
        setState(() => _phase = _GameDetailsPhase.details);
        return;
      }

      final slotTopLeftGlobal = slotBox.localToGlobal(Offset.zero);
      final slotTopLeftLocal = overlayBox.globalToLocal(slotTopLeftGlobal);
      final targetRect = slotTopLeftLocal & slotBox.size;

      final isMobile = Responsive.isMobile(context);
      final startSize = isMobile ? 240.0 : 360.0;
      final startRect = Rect.fromCenter(
        center: overlayBox.size.center(Offset.zero),
        width: startSize,
        height: startSize,
      );

      setState(() {
        _dockRectAnimation = RectTween(
          begin: startRect,
          end: targetRect,
        ).animate(
          CurvedAnimation(
            parent: _dockController,
            curve: Curves.easeInOutCubicEmphasized,
          ),
        );
      });
      _dockController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = _game;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_phase == _GameDetailsPhase.launching)
            _LaunchSequenceView(
              key: const ValueKey('launch'),
              game: game,
              pulseController: _pulseController,
            ),
          if (_phase != _GameDetailsPhase.launching)
            AnimatedOpacity(
              opacity: _phase == _GameDetailsPhase.docking ? 0.92 : 1,
              duration: const Duration(milliseconds: 280),
              child: _ProjectDetailsView(
                key: const ValueKey('details'),
                game: game,
                imageSlotKey: _detailsImageSlotKey,
                showHeaderImage: _phase == _GameDetailsPhase.details,
              ),
            ),
          if (_phase == _GameDetailsPhase.docking && _dockRectAnimation != null)
            AnimatedBuilder(
              animation: _dockController,
              builder: (context, child) {
                final currentRect = _dockRectAnimation!.value;
                if (currentRect == null) return const SizedBox.shrink();

                return Positioned.fromRect(
                  rect: currentRect,
                  child: child!,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: _GameArtwork(path: game.background, fit: BoxFit.contain),
              ),
            ),
        ],
      ),
    );
  }
}

enum _GameDetailsPhase {
  launching,
  docking,
  details,
}

class _LaunchSequenceView extends StatelessWidget {
  final Game game;
  final AnimationController pulseController;

  const _LaunchSequenceView({
    super.key,
    required this.game,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.2, -0.1),
              radius: 1.2,
              colors: [
                Colors.blueGrey.withValues(alpha: 0.12),
                Colors.black,
              ],
            ),
          ),
        ),
        Center(
          child: AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              final t = Curves.easeInOut.transform(pulseController.value);
              final scale = 1 + (t * 0.03);
              final opacity = 0.9 + (t * 0.1);

              return Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: child,
                ),
              );
            },
            child: SizedBox(
              width: isMobile ? 240 : 360,
              height: isMobile ? 240 : 360,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.12),
                      blurRadius: 28,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Hero(
                    tag: gameBackgroundLaunchHeroTag(game.id),
                    createRectTween: (begin, end) =>
                        MaterialRectCenterArcTween(begin: begin, end: end),
                    flightShuttleBuilder: (
                      flightContext,
                      animation,
                      flightDirection,
                      fromHeroContext,
                      toHeroContext,
                    ) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: _GameArtwork(
                          path: game.background,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                    child: _GameArtwork(
                        path: game.background, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectDetailsView extends StatelessWidget {
  final Game game;
  final GlobalKey imageSlotKey;
  final bool showHeaderImage;

  const _ProjectDetailsView({
    super.key,
    required this.game,
    required this.imageSlotKey,
    required this.showHeaderImage,
  });

  @override
  Widget build(BuildContext context) {
    final details = game.projectDetails;
    final isMobile = Responsive.isMobile(context);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 14 : 26, vertical: 14),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.white,
                  tooltip: 'Back to dashboard',
                ),
                const SizedBox(width: 4),
                Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: isMobile ? 15 : 17,
                  ),
                ),
                const Spacer(),
                if (game.status != null)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Text(
                        game.status!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  isMobile ? 16 : 30, 0, isMobile ? 16 : 30, 28),
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.1),
                              Colors.white.withValues(alpha: 0.03),
                            ],
                          ),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isMobile ? 16 : 22),
                          child: isMobile
                              ? _MobileHeader(
                                  game: game,
                                  imageSlotKey: imageSlotKey,
                                  showHeaderImage: showHeaderImage,
                                )
                              : _DesktopHeader(
                                  game: game,
                                  imageSlotKey: imageSlotKey,
                                  showHeaderImage: showHeaderImage,
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _MetaChip(label: details?.role ?? 'Project'),
                          _MetaChip(
                              label: details?.organization ?? 'Portfolio Work'),
                          _MetaChip(
                              label:
                                  details?.period ?? 'Timeline not provided'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (details != null) ...[
                        _SectionTitle(title: 'Technology Stack'),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: details.technologies
                              .map(
                                (tech) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.16),
                                    ),
                                  ),
                                  child: Text(
                                    tech,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        if (details.facts.isNotEmpty) ...[
                          _SectionTitle(title: 'Project Snapshot'),
                          const SizedBox(height: 10),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isSmall = constraints.maxWidth < 760;
                              return GridView.builder(
                                itemCount: details.facts.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isSmall ? 1 : 3,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: isSmall ? 4 : 2.7,
                                ),
                                itemBuilder: (context, index) {
                                  final fact = details.facts[index];
                                  return DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color:
                                          Colors.white.withValues(alpha: 0.05),
                                      border: Border.all(
                                        color: Colors.white
                                            .withValues(alpha: 0.12),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            fact.label,
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withValues(alpha: 0.65),
                                              fontSize: 11,
                                              letterSpacing: 0.4,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            fact.value,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                        _SectionTitle(title: 'What Was Delivered'),
                        const SizedBox(height: 10),
                        ...details.highlights.map(
                          (highlight) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    highlight,
                                    style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.9),
                                      fontSize: 15,
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else
                        Text(
                          game.description,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  final Game game;
  final GlobalKey imageSlotKey;
  final bool showHeaderImage;

  const _DesktopHeader({
    required this.game,
    required this.imageSlotKey,
    required this.showHeaderImage,
  });

  @override
  Widget build(BuildContext context) {
    final details = game.projectDetails;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          key: imageSlotKey,
          width: 260,
          height: 260,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: showHeaderImage
                ? _GameArtwork(path: game.background, fit: BoxFit.cover)
                : const SizedBox.shrink(),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                game.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                details?.summary ?? game.description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 17,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileHeader extends StatelessWidget {
  final Game game;
  final GlobalKey imageSlotKey;
  final bool showHeaderImage;

  const _MobileHeader({
    required this.game,
    required this.imageSlotKey,
    required this.showHeaderImage,
  });

  @override
  Widget build(BuildContext context) {
    final details = game.projectDetails;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          key: imageSlotKey,
          width: 140,
          height: 140,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: showHeaderImage
                ? _GameArtwork(path: game.background, fit: BoxFit.cover)
                : const SizedBox.shrink(),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          game.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          details?.summary ?? game.description,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.88),
            fontSize: 14,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.8),
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;

  const _MetaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _GameArtwork extends StatelessWidget {
  final String path;
  final BoxFit fit;

  const _GameArtwork({
    required this.path,
    required this.fit,
  });

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: fit,
        placeholder: (context, _) => const ColoredBox(color: AppColors.black),
        errorWidget: (context, _, __) =>
            const ColoredBox(color: AppColors.darkGray),
      );
    }

    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (context, _, __) =>
          const ColoredBox(color: AppColors.darkGray),
    );
  }
}
