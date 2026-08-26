# Changelog

## 0.2.2

- Trim the package description to 168 characters. pub.dev caps it at 180 and
  was withholding all 10 `pubspec.yaml` points for the overrun.

## 0.2.1

- Shrink the published archive from 27 MB to a few KB. 0.2.0 accidentally
  shipped the example's generated Android/iOS/web scaffolding; it is now
  excluded. No code changes — upgrade from 0.2.0 purely for the size.

## 0.2.0

- **Any widget can go in the bar.** Added `largeTitle` and `compactTitle`,
  which take arbitrary widgets — a heading with a subtitle, an avatar row, a
  search field, tabs — instead of only a string.
- `title` is now optional. Pass it for the plain-text case, or supply both
  custom widgets and omit it. Supplying `title` alongside one custom widget
  fills in the other, so you can override just one side.
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
