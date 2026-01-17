<p align="center">
  <img src="preview.png" width="320" alt="Clockwork">
</p>

# Clockwork

A minimal, elegant menubar time tracker for macOS. Track billable hours and earnings without leaving your workflow.

![macOS](https://img.shields.io/badge/macOS-14.0+-black?style=flat-square&logo=apple)
![Swift](https://img.shields.io/badge/Swift-5.0-orange?style=flat-square&logo=swift)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

## Features

- **Menubar Native** — Lives in your menubar, always one click away
- **Start/Pause/Resume** — Flexible session control with accurate pause tracking
- **Earnings Calculator** — Set your hourly rate and watch earnings update in real-time
- **Session History** — View past sessions with duration and earnings
- **Persistent Storage** — Sessions and settings saved locally
- **Dark UI** — Refined dark interface with gold accents

## Requirements

- macOS 14.0 or later
- Xcode 15.0+ (for building from source)

## Installation

### Download

Download the latest release from the [Releases](../../releases) page.

#### Opening the App

This app is not signed with an Apple Developer certificate. When you first open it, macOS will show a warning. To open it:

1. **Right-click** (or Control-click) on `clockwork.app`
2. Select **Open** from the menu
3. Click **Open** in the dialog that appears

Alternatively, you can allow it in System Settings:

1. Go to **System Settings → Privacy & Security**
2. Scroll down to find the blocked app message
3. Click **Open Anyway**

### Build from Source

```bash
git clone https://github.com/yourusername/clockwork.git
cd clockwork
open clockwork.xcodeproj
```

Then build and run with `⌘R` in Xcode.

## Usage

1. Click the clock icon in your menubar
2. Set your hourly rate in Settings (gear icon)
3. Click **Start Session** to begin tracking
4. Use **Pause** to take breaks — paused time is not counted
5. Click **End** to finish and save the session
6. View past sessions in the list below

## Architecture

```
clockwork/
├── clockworkApp.swift    # App entry point, MenuBarExtra setup
├── MenuBarView.swift     # Main UI with timer, controls, sessions
├── TimerManager.swift    # Timer logic, pause handling, persistence
├── Session.swift         # Session data model
└── ContentView.swift     # Unused (menubar-only app)
```

## Privacy

Clockwork stores all data locally using UserDefaults. No data is sent to external servers. No analytics. No tracking.

## License

MIT License — see [LICENSE](LICENSE) for details.

## Author

Created by [Steve Derico](https://github.com/stevederico)

---

<p align="center">
  <sub>Built with SwiftUI for macOS</sub>
</p>
