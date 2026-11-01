# Kelivo Android — local build notes

This tree is the Android-focused subset of Kelivo (android/, lib/, assets/,
shaders/, tool/, dependencies/ + root config), with local modifications for a
themed (monochrome) app icon and arm64-only release builds.

## What was changed vs upstream

- `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` — added a
  `<monochrome>` layer pointing at the new line-art drawable (Android 13+
  themed icons).
- `android/app/src/main/res/drawable-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/
  ic_launcher_monochrome.png` — new files. The upstream launcher foreground
  PNGs have opaque white backgrounds, which makes launchers render the themed
  icon as a solid shape; these are white-on-transparent line art derived from
  the foreground. Regenerate with `dart run tool/gen_monochrome.dart` after
  changing the app icon (preview written to `tool/monochrome_preview.png`).
- `flutter_launcher_icons.yaml` — added `adaptive_icon_monochrome` so future
  icon regenerations keep a monochrome layer.
- `android/app/build.gradle.kts` — release builds restricted to arm64-v8a
  (cmake abiFilters + packaging.jniLibs.excludes). Restore the 3-ABI list and
  build without `--target-platform` for a universal APK.
- `android/gradle.properties` — Gradle heap lowered to -Xmx4G for an 8 GB
  machine.
- `tool/fetch_proot.sh`, `tool/proot_checksums.txt`, other tool/*.sh —
  normalized to LF line endings (a CRLF checkout breaks the Gradle fetchProot
  task).
- `tool/gen_monochrome.dart`, `tool/inspect_alpha.dart` — new helper scripts.

## Building

Requirements: Flutter >= 3.44.9, Android SDK (with NDK 28.2.13676358, licenses
accepted), JDK 17+.

```bash
flutter pub get
flutter build apk --release --target-platform android-arm64
```

Output: `build/app/outputs/flutter-apk/app-release.apk`.

## Not included (intentionally)

- `android/local.properties` — regenerate: it is written automatically by the
  Flutter tool on first build (sdk.dir / flutter.sdk paths).
- `android/key.properties` and the release keystore — secrets, never commit
  these. The current build signs release with the config in key.properties;
  to produce a signed APK here, create a keystore:
  `keytool -genkeypair -keystore android/app/kelivo-release.jks -alias kelivo`
  and a matching `android/key.properties`
  (storeFile/storePassword/keyAlias/keyPassword). Without it, the release APK
  is unsigned.
- `.git`, `build/`, `.dart_tool/`, `.gradle/` — history and build artifacts.

To start a fresh repository from this snapshot:
`git init && git add -A && git commit -m "Kelivo Android with themed icon support"`
