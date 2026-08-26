# ghost_app_bar

An **invisible app bar** scaffold for Flutter. The bar has no background —
content scrolls behind it and dissolves into a soft gradient scrim that also
covers the status bar, with no visible seam. A large title fades out as you
scroll while a compact title fades into the bar (WhatsApp / iOS
large-title style).

Works on all renderers: plain gradient paint, no `ShaderMask`.

| Expanded | Collapsed | Dark |
|---|---|---|
| ![Expanded](https://raw.githubusercontent.com/jubairp10/ghost_app_bar/main/screenshot_light.png) | ![Collapsed](https://raw.githubusercontent.com/jubairp10/ghost_app_bar/main/screenshot_collapsed.png) | ![Dark theme](https://raw.githubusercontent.com/jubairp10/ghost_app_bar/main/screenshot_top.png) |

## Features

- Transparent floating bar with `leading` and `actions` slots
- Gradient scrim covering the status bar — no seam between bar and content
- Large title that scrolls away and fades out
- Compact title that fades into the bar past a configurable offset
- Theme-aware: readable in light and dark mode with no colors passed
- Put **any widget** in the bar — subtitles, avatars, search fields, tabs
- Sliver-based content, or a plain `children` list via the convenience
  constructor
- Zero dependencies beyond Flutter itself

## Usage

```dart
import 'package:ghost_app_bar/ghost_app_bar.dart';

Scaffold(
  body: GhostAppBarScaffold.children(
    title: 'Chats',
    leading: const CircleAvatar(radius: 18),
    actions: [
      IconButton(icon: const Icon(Icons.search), onPressed: () {}),
    ],
    children: [
      for (var i = 0; i < 40; i++) ListTile(title: Text('Item $i')),
    ],
  ),
)
```

Colors come from the ambient `Theme`, so this is readable in light and dark
mode without passing any. Override `scrimColor`, `largeTitleStyle`, or
`compactTitleStyle` when you want something specific.

### Custom bar content

`title` is a shortcut. For anything else, pass widgets — they get the same
fade and collapse behaviour for free:

```dart
GhostAppBarScaffold.children(
  // Expanded header: heading plus a subtitle.
  largeTitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Library', style: Theme.of(context).textTheme.headlineMedium),
      Text('40 documents · 2 shared'),
    ],
  ),
  // What fades into the bar once collapsed.
  compactTitle: Row(
    children: [
      const Icon(Icons.folder_rounded, size: 20),
      const SizedBox(width: 8),
      const Text('Library'),
    ],
  ),
  leading: const BackButton(),
  actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
  children: [...],
)
```

Pass `title` alongside just one of them to override a single side — the other
falls back to the text. For full control of the scroll content, use the
default constructor with `slivers`.

### Tuning

| Parameter | Default | Description |
|---|---|---|
| `title` | — | Text for both titles; optional if you pass both widgets below |
| `largeTitle` | from `title` | Any widget for the expanded header |
| `compactTitle` | from `title` | Any widget for the collapsed bar |
| `controller` | internal | Optional external `ScrollController` |
| `collapseOffset` | `30` | Scroll offset (px) after which the compact title shows |
| `scrimColor` | theme | Color the content dissolves into — defaults to the scaffold background |
| `scrimExtent` | `34` | Extra fade distance below the bar |
| `barHeight` | `64` | Bar row height, excluding status bar |
| `horizontalPadding` | `20` | Padding for bar and large title |
| `bottomPadding` | `120` | Space at the bottom of the scroll view |

## License

MIT
