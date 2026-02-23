# Hito+

Hito+ is a Windows Flutter desktop app with monochrome planner/journal modules:

- Calendar (life grid)
- Notebook
- Vision Board
- Planner
- Scrapper (ephemeral venting pad)
- AI Chat
- Settings

## Open Source

This repository is open source under the MIT License.

- License file: `LICENSE`

## Executable Files In Repo

Prebuilt Windows binaries are included in `release/`:

- `release/hito_plus.exe`
- `release/hito_plus_setup_1.0.0.exe`
- `release/hito_plus_portable_1.0.0.zip`
- `release/checksums.sha256`

## Practical Use (Vibe Coding)

This project is built as practical personal tools using vibe coding:

- `Calendar`: visual life-progress grid (editable lifespan + year row layout).
- `Notebook`: plain-text diary with page reorder/shuffle + calligraphy presets.
- `Vision Board`: draggable text/image cards with local persistence.
- `Planner`: goals + tasks with status and dates.
- `Scrapper`: venting pad that is intentionally non-persistent.
- `AI Chat`: assistant with local chat history and explicit confirmation before write actions.

## Testing

- Local test command: `flutter test`
- Local analysis command: `flutter analyze`
- CI: GitHub Actions workflow at `.github/workflows/windows-ci.yml`
  - runs `flutter analyze`
  - runs `flutter test`
  - runs `flutter build windows --release`

## Development

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d windows
```

## Windows Release Build

```powershell
flutter build windows --release
```

Output executable:

- `build/windows/x64/runner/Release/hito_plus.exe`

## Packaging Script

Use the packaging script to build release, copy distributable files to `dist/`,
create a `.zip`, and optionally build an Inno Setup installer if `ISCC.exe` is available.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/package_windows.ps1
```

Optional flags:

- `-SkipBuild` : package existing release files without rebuilding
- `-NoInstaller` : skip Inno Setup installer step
- `-FlutterExecutable <path>` : use custom flutter executable

Generated package metadata:

- `release_manifest.json` : app version + file inventory + SHA-256 per file
- `checksums.sha256` : checksum list for packaged files
- `<package>.zip.sha256` : checksum for the zip artifact

Installer config:

- `installer/hito_plus.iss`
