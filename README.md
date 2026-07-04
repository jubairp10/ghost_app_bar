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
- Sliver-based content, or a plain `children` list via the convenience
  constructor

## Usage

```dart
import 'package:ghost_app_bar/ghost_app_bar.dart';

Scaffold(
  backgroundColor: const Color(0xFF06140A),
  body: GhostAppBarScaffold.children(
    title: 'Chats',
    leading: const CircleAvatar(radius: 18),
    actions: [
      IconButton(icon: const Icon(Icons.search), onPressed: () {}),
    ],
    children: [
      for (var i = 0; i < 40; i++)
        ListTile(title: Text('Item $i', style: const TextStyle(color: Colors.white))),
    ],
  ),
)
```

For full control use the default constructor with `slivers`.

### Tuning

| Parameter | Default | Description |
|---|---|---|
| `controller` | internal | Optional external `ScrollController` |
| `collapseOffset` | `30` | Scroll offset (px) after which the compact title shows |
| `scrimColor` | `0xFF06140A` | Color the content dissolves into — match your background |
| `scrimExtent` | `34` | Extra fade distance below the bar |
| `barHeight` | `64` | Bar row height, excluding status bar |
| `horizontalPadding` | `20` | Padding for bar and large title |
| `bottomPadding` | `120` | Space at the bottom of the scroll view |

## License

MIT
