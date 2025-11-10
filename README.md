# todo_app_bloc_pattern

A Flutter todo application implemented using the BLoC pattern and a clean architecture approach.

## Overview

This repository contains a Flutter app that demonstrates:
- Bloc architecture for state management
- Clean architecture separation (presentation / domain / data)
- Local storage using Isar for persisting todos
- Multi-platform support (Android, iOS, web, desktop targets)

## Table of contents
- [Getting started](#getting-started)
- [Isar (local database)](#isar-local-database)
- [Full project directory (top-level)](#full-project-directory-top-level)
- [Architecture notes](#architecture-notes)
- [Contributing](#contributing)
- [License & contact](#license--contact)

## Getting started

Prerequisites:
- Flutter SDK (>= stable release)
- A device or emulator / simulator, or configure desktop/web targets

Quick start:
1. Clone the repo:
   ```
   git clone https://github.com/Rashadul-hub/todo_app_bloc.git
   ```
2. Get packages:
   ```
   cd todo_app_bloc
   flutter pub get
   ```
3. Run:
   ```
   flutter run
   ```

If you need a specific platform:
- Android: open with Android Studio or use `flutter run -d <device>`
- iOS: open `ios/Runner.xcworkspace` in Xcode (macOS required)
- Web: `flutter run -d chrome`
- Desktop: enable desktop support in Flutter and run as usual

---

## Isar (local database)

This project uses Isar for local storage. The project includes these Isar-related dependencies in `pubspec.yaml`:

```yaml
dependencies:
  isar: ^3.0.0
  isar_flutter_libs: ^3.0.0
  path_provider: ^2.1.5
  flutter_bloc: ^8.1.6

dev_dependencies:
  isar_generator: ^3.0.0
  build_runner: ^2.4.13
```

Important notes and steps for working with Isar in this repo:

1. Models / annotations
   - Define your Isar collections (models) using the `@Collection()` annotation from `package:isar/isar.dart`.
   - Include `part 'your_model.g.dart';` in the file so the generator can write the generated code.

   Example model:
   ```dart
   import 'package:isar/isar.dart';

   part 'todo.g.dart';

   @Collection()
   class Todo {
     Id id = Isar.autoIncrement;

     late String title;
     bool done = false;
     DateTime? dueDate;
   }
   ```

2. Run code generation
   - After creating or changing annotated models run the code generator:
     ```
     flutter pub run build_runner build --delete-conflicting-outputs
     ```
   - For continuous generation during development:
     ```
     flutter pub run build_runner watch --delete-conflicting-outputs
     ```

   The generator will create the `*.g.dart` files (schemas) required by Isar. These files must be committed to the repository if you want others to build without running the generator.

3. Opening the Isar instance
   - For mobile/desktop (with a directory):
     ```dart
     import 'package:isar/isar.dart';
     import 'package:path_provider/path_provider.dart';
     import 'models/todo.dart'; // your model file

     Future<Isar> openIsar() async {
       final dir = await getApplicationDocumentsDirectory();
       return await Isar.open(
         [TodoSchema],
         directory: dir.path,
       );
     }
     ```
   - For web (no directory required; uses IndexedDB):
     ```dart
     final isar = await Isar.open([TodoSchema]);
     ```

   - Note: `isar_flutter_libs` is included to provide native binaries for mobile and desktop. No extra manual install is required for standard Flutter targets.

4. Typical usage patterns
   - Use repository classes (data layer) to expose CRUD operations to BLoCs/cubits in the presentation layer.
   - Run write transactions for mutations:
     ```dart
     await isar.writeTxn(() async {
       await isar.todos.put(todo);
     });
     ```
   - Query:
     ```dart
     final all = await isar.todos.where().findAll();
     ```

5. Troubleshooting
   - If code generation fails, try:
     ```
     flutter clean
     rm -rf .dart_tool
     flutter pub get
     flutter pub run build_runner build --delete-conflicting-outputs
     ```
   - If you get missing schema types, ensure the `part` directive and `@Collection()` annotation exist and that the generated `*.g.dart` is present or regenerated.

6. Where to look in this repository
   - Models are typically placed in `lib/data/models` or `lib/models`. If you cannot find them, search the codebase for `@Collection()` or `.g.dart` filenames to locate model definitions and generated schemas.
   - Initialization of Isar is commonly done early in the app (e.g., `main.dart` or a repository/provider initializer). Search for `Isar.open` in `lib/` to find the exact initialization point in this project.

Optional
- Isar Inspector: for debugging you can use the Isar inspector/DevTools (see Isar docs). This repo does not add that tooling by default.

---

## Full project directory (top-level)

Below is the full top-level project layout included in this repository and a short description for each item so contributors can quickly understand purpose and where to find code.

- .gitignore
  - Standard generated file listing files and directories to ignore in Git.
- .metadata
  - Flutter project metadata (generated).
- README.md
  - This file.
- analysis_options.yaml
  - Linting and analyzer rules for the project.
- pubspec.yaml
  - Project manifest: dependencies, assets, metadata.
- pubspec.lock
  - Locked dependency versions.
- android/
  - Android platform folder (Gradle project, platform integration).
- ios/
  - iOS platform folder (Xcode workspace, Runner targets).
  - ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md — notes for customizing launch images.
- lib/
  - Main application source code (presentation, domain, data, BLoC implementations).
  - Look in lib/ for Isar models (annotated with @Collection) and for the Isar initialization code (Isar.open).
- test/
  - Automated tests (unit/widget) for app logic and UI.
- web/
  - Web-specific build files (if applicable).
- linux/
  - Linux desktop platform folder (if applicable).
- macos/
  - macOS desktop platform folder (if applicable).
- windows/
  - Windows desktop platform folder (if applicable).

---

## Architecture notes

- State management: BLoC (Business Logic Component) pattern — look for blocs/cubits under lib/ (common patterns: /presentation/bloc or /lib/blocs).
- Clean architecture: code is typically split into layers (presentation, domain, data).
- Local persistence: Isar is used to persist todo items; see `lib/` for model definitions and repository implementations.

## Running & debugging tips

- Use `flutter analyze` to run static analysis per the project's analysis_options.yaml.
- Use `flutter test` to run tests in the test/ directory.
- To regenerate Isar code after model changes:
  ```
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

## Contributing

- Fork the repository and open a pull request with clear change descriptions.
- Follow the linting rules in `analysis_options.yaml`.
- Add/update tests for new features and bug fixes.
- Keep commits small and focused; use descriptive commit messages.

## License & contact

- Check the repository root for a LICENSE file (if present). Otherwise, contact the repository owner for license details.
- For questions, open an issue on GitHub in this repository.
