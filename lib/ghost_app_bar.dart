/// A transparent, "invisible" app bar with an iOS-style large-title
/// collapse and a gradient scrim that hides the seam at the status bar.
///
/// The entry point is [GhostAppBarScaffold].
library;

import 'package:flutter/material.dart';

/// A scaffold body with an "invisible" app bar:
///
/// * The bar has no background — users can't tell it's an app bar.
/// * Content scrolls behind it and dissolves into a soft gradient scrim
///   that also covers the status bar (no visible seam).
/// * A large title fades out as you scroll; a compact title fades into
///   the bar (WhatsApp / iOS large-title style).
///
/// Colors follow the ambient [Theme] unless you override them, so it works
/// in light and dark mode out of the box.
///
/// Renders with plain gradient paint on all renderers — no `BackdropFilter`
/// and no `ShaderMask`.
///
/// ```dart
/// GhostAppBarScaffold.children(
///   title: 'Chats',
///   children: [for (final c in contacts) ContactTile(c)],
/// )
/// ```
class GhostAppBarScaffold extends StatefulWidget {
  /// Large title shown below the bar; scrolls away and fades out.
  final String title;

  /// Style for the large title.
  ///
  /// Defaults to the theme's `headlineMedium`, bolded.
  final TextStyle? largeTitleStyle;

  /// Style for the compact title that fades into the bar.
  ///
  /// Defaults to the theme's `titleMedium`.
  final TextStyle? compactTitleStyle;

  /// Widget at the start of the bar (e.g. avatar or back button).
  final Widget? leading;

  /// Widgets at the end of the bar (e.g. action buttons).
  final List<Widget> actions;

  /// Scroll offset (px) after which the compact title is shown.
  final double collapseOffset;

  /// Scrim color the content dissolves into. Alpha is applied by the
  /// gradient.
  ///
  /// Defaults to the theme's [ThemeData.scaffoldBackgroundColor], which is
  /// what you want whenever the scroll view sits directly on the scaffold.
  final Color? scrimColor;

  /// Extra fade distance (px) below the bar for the scrim.
  final double scrimExtent;

  /// Height of the bar row (excluding status bar).
  final double barHeight;

  /// Horizontal padding for bar and large title.
  final double horizontalPadding;

  /// Bottom padding inside the scroll view (e.g. above a nav bar).
  final double bottomPadding;

  /// Slivers shown after the large title. Use [GhostAppBarScaffold.children]
  /// for boxes.
  final List<Widget> slivers;

  /// Optional external scroll controller. If null, one is created
  /// internally.
  final ScrollController? controller;

  /// Creates a ghost app bar around a list of [slivers].
  const GhostAppBarScaffold({
    super.key,
    required this.title,
    this.controller,
    this.largeTitleStyle,
    this.compactTitleStyle,
    this.leading,
    this.actions = const [],
    this.collapseOffset = 30,
    this.scrimColor,
    this.scrimExtent = 34,
    this.barHeight = 64,
    this.horizontalPadding = 20,
    this.bottomPadding = 120,
    required this.slivers,
  });

  /// Convenience constructor for a plain list of box widgets.
  GhostAppBarScaffold.children({
    Key? key,
    required String title,
    ScrollController? controller,
    TextStyle? largeTitleStyle,
    TextStyle? compactTitleStyle,
    Widget? leading,
    List<Widget> actions = const [],
    double collapseOffset = 30,
    Color? scrimColor,
    double scrimExtent = 34,
    double barHeight = 64,
    double horizontalPadding = 20,
    double bottomPadding = 120,
    required List<Widget> children,
  }) : this(
          key: key,
          title: title,
          controller: controller,
          largeTitleStyle: largeTitleStyle,
          compactTitleStyle: compactTitleStyle,
          leading: leading,
          actions: actions,
          collapseOffset: collapseOffset,
          scrimColor: scrimColor,
          scrimExtent: scrimExtent,
          barHeight: barHeight,
          horizontalPadding: horizontalPadding,
          bottomPadding: bottomPadding,
          slivers: [SliverList(delegate: SliverChildListDelegate(children))],
        );

  @override
  State<GhostAppBarScaffold> createState() => _GhostAppBarScaffoldState();
}

class _GhostAppBarScaffoldState extends State<GhostAppBarScaffold> {
  late ScrollController _scroll;
  ScrollController? _internal;
  bool _collapsed = false;

  @override
  void initState() {
    super.initState();
    _scroll = widget.controller ?? (_internal = ScrollController());
    _scroll.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(GhostAppBarScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _scroll.removeListener(_onScroll);
      _internal?.dispose();
      _internal = null;
      _scroll = widget.controller ?? (_internal = ScrollController());
      _scroll.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _internal?.dispose();
    super.dispose();
  }

  void _onScroll() {
    final collapsed =
        _scroll.hasClients && _scroll.offset > widget.collapseOffset;
    if (collapsed != _collapsed) setState(() => _collapsed = collapsed);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double statusBar = MediaQuery.of(context).padding.top;
    final Color scrim = widget.scrimColor ?? theme.scaffoldBackgroundColor;
    final Color onScrim = theme.colorScheme.onSurface;
    final double scrimHeight = statusBar + widget.barHeight + widget.scrimExtent;

    final TextStyle largeStyle = widget.largeTitleStyle ??
        (theme.textTheme.headlineMedium ?? const TextStyle(fontSize: 30))
            .copyWith(fontWeight: FontWeight.w700, color: onScrim);
    final TextStyle compactStyle = widget.compactTitleStyle ??
        (theme.textTheme.titleMedium ?? const TextStyle(fontSize: 18))
            .copyWith(fontWeight: FontWeight.w600, color: onScrim);

    return Stack(
      children: [
        // ── Content — scrolls behind the invisible bar ──────────────────
        Positioned.fill(
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(top: widget.barHeight + 6),
                  sliver: SliverToBoxAdapter(
                    // Large title — fades out with scroll offset.
                    child: AnimatedBuilder(
                      animation: _scroll,
                      builder: (_, child) {
                        final double offset =
                            _scroll.hasClients ? _scroll.offset : 0;
                        final double opacity = (1 -
                                offset / (widget.collapseOffset + 14))
                            .clamp(0.0, 1.0);
                        return Opacity(opacity: opacity, child: child);
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            widget.horizontalPadding,
                            2,
                            widget.horizontalPadding,
                            16),
                        child: Text(widget.title, style: largeStyle),
                      ),
                    ),
                  ),
                ),
                ...widget.slivers,
                SliverToBoxAdapter(
                  child: SizedBox(height: widget.bottomPadding),
                ),
              ],
            ),
          ),
        ),

        // ── Scrim — content dissolves into the top, status bar included ──
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: scrimHeight,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scrim.withValues(alpha: 0.95),
                    scrim.withValues(alpha: 0.77),
                    scrim.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
        ),

        // ── Floating transparent bar ─────────────────────────────────────
        Positioned(
          top: statusBar,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                widget.horizontalPadding, 12, widget.horizontalPadding, 8),
            child: Row(
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: AnimatedOpacity(
                    opacity: _collapsed ? 1 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Text(widget.title, style: compactStyle),
                  ),
                ),
                for (final action in widget.actions) ...[
                  const SizedBox(width: 8),
                  action,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
