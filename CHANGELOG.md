# Changelog

## 0.2.0

- **Theme-aware by default.** `scrimColor` and both title styles now fall back
  to the ambient `Theme` instead of hardcoded white-on-dark-green, so the bar
  is readable in a stock light or dark app without passing any colors.
- Documented every public API element.

### Breaking

- `scrimColor` is now `Color?` and defaults to `ThemeData.scaffoldBackgroundColor`.
  If you relied on the old `0xFF06140A` default, pass it explicitly:
  `scrimColor: const Color(0xFF06140A)`.
- Default title colors follow `ColorScheme.onSurface` rather than always being
  white. Pass `largeTitleStyle` / `compactTitleStyle` to restore the old look.

## 0.1.2

- Add changelog entries for released versions (pub.dev convention fix).

## 0.1.1

- Add screenshots to the README.
- Add optional external `ScrollController` via the `controller` parameter.

## 0.1.0

- Initial release.
- `GhostAppBarScaffold`: invisible app bar with gradient scrim, large title
  that fades out on scroll, and compact title that fades into the bar.
- `GhostAppBarScaffold.children` convenience constructor for box widgets.
