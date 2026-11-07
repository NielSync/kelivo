@AGENTS.md

---
---

## Machine toolchains (mandatory)

Dev toolchains are pre-installed in ONE central root: `C:\Users\User\dev-setup\tools\`
(Flutter 3.47.9, JDK 17 — JAVA_HOME, Gradle 8.14.3, Android SDK).
Machine-managed apps resolve via PATH and stay where their installers put them:
Python 3.12 (`python` / `py`), MiKTeX 26.5 (`lualatex` / `xelatex`), Git 2.56.

Before downloading or installing ANY tool, SDK, or toolchain, run:

```
powershell -ExecutionPolicy Bypass -File C:\Users\User\dev-setup\tools\check-resource.ps1 <name> [version]
```

- Exit 0 = already installed → use the printed absolute path. Never download, duplicate, or vendor it.
- Exit 1 = genuinely missing → download the zip into `C:\Users\User\dev-setup\` and install with
  `install-tool.ps1`. Never unzip tools into the profile or this project.

Full rules: `C:\Users\User\dev-setup\tools\AGENTS.md` · Catalog: `RESOURCES.json` in that folder.
This project's SDK paths are pinned in `android\local.properties` (`flutter.sdk`, `sdk.dir`) and
already point into the central root — do not repoint them.
