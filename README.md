<div align="center">

# 🧭 Safari Fixer

**Compatibility helpers for Safari on legacy iOS**

[![Build](https://github.com/felovdev/SafariFixer-iOS12/actions/workflows/build.yml/badge.svg)](https://github.com/felovdev/SafariFixer-iOS12/actions/workflows/build.yml)
[![iOS](https://img.shields.io/badge/iOS-12.0%2B-0A84FF?logo=apple&logoColor=white)](https://www.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

*A small jailbreak tweak project focused on making older Safari behave a little more reliably on today's web.*

</div>

---

## ✨ What it aims to improve

Safari Fixer is an experimental tweak for **MobileSafari on iOS 12**. It injects a lightweight compatibility script into WebKit pages and currently focuses on:

- 🎬 **Video recovery:** retry a failed HTML5 video element when Safari restores a page from its back/forward cache.
- 📱 **Inline playback hints:** add `playsinline` to dynamically-created video elements where the site has not specified it.
- 🔄 **Dynamic pages:** observe newly inserted video elements, not just the initial document.
- 🧩 **Legacy Safari support:** provide a safe place to add narrowly-scoped compatibility workarounds as real site issues are reproduced.

These helpers are deliberately conservative. They do not rewrite every site's JavaScript, spoof the browser identity, or force-refresh every iframe.

## 🎯 Target device

| Component | Target |
|---|---|
| Device | iPhone 5s (A7, arm64) |
| iOS | 12.5.8 |
| Jailbreak | Chimera, rootful |
| Browser | Apple Safari / MobileSafari |
| Package | Debian `.deb`, rootful `iphoneos-arm` |

The GitHub Actions workflow builds the package remotely with Theos. **You do not need Xcode or a local build environment.**

## 📦 Build

Every push to `main` and every pull request runs the build workflow.

1. Open the [Actions tab](https://github.com/felovdev/SafariFixer-iOS12/actions).
2. Select the latest **Build Safari Fixer** run.
3. When it completes, open **Artifacts** and download `SafariFixer-iOS12-deb`.
4. Extract the ZIP. It contains the `.deb` package.

A successful CI build only confirms that the package compiled. It does not prove that every website or video player works on-device.

## 📲 Install

1. Transfer the built `.deb` to the iPhone.
2. Open it in Filza and install it.
3. Respring or reboot if the package manager requests it.
4. Open Safari and test the same page again.

To uninstall, use the package manager that installed the tweak.

> **Important:** This is an early development build. Keep a way to remove the package (for example, Filza or your package manager) in case Safari crashes or behaves unexpectedly. Do not install it on a device you cannot recover.

## ⚠️ Realistic compatibility limits

This tweak cannot turn iOS 12's old WebKit into a modern browser engine.

- A User-Agent change cannot add missing JavaScript APIs, CSS features, or browser capabilities.
- iOS Safari does not provide the Media Source Extensions (MSE) support required by some JavaScript video players (for example, an hls.js MSE playback path).
- Native HLS playback may work, but codec, container, server, DRM, and player requirements still apply.
- A page or iframe may lose its in-memory player state when Safari closes or unloads a tab. A retry can help some HTML5 video errors, but cannot guarantee restoration without reloading the player or page.
- GitHub, Pinterest, and other complex sites may remain partially incompatible.

No universal site support is promised.

## 🛠 Development

The project uses [Theos](https://theos.dev/) and a GitHub Actions build workflow.

```
.
├── .github/workflows/build.yml
├── SafariFixer.plist
├── Makefile
├── control
├── Tweak.xm
└── README.md
```

For a reproducible bug report, include:
- iOS version and device model;
- the affected page URL (remove private tokens or account-specific query strings);
- what you expected and what happened;
- whether the issue also occurs after a fresh Safari launch;
- for video, the player name and the exact error text.

Please do not include passwords, cookies, session tokens, or private account data.

## 🗺 Roadmap

- [x] Theos project scaffold
- [x] GitHub Actions package build
- [x] Initial HTML5 video restore helper
- [ ] Reproduce and diagnose the reported Kodik restore error
- [ ] Add narrowly-scoped site fixes only after testing
- [ ] On-device testing on iOS 12.5.8 / Chimera

## 🤝 Contributing

Bug reports and focused pull requests are welcome. Prefer a small, testable workaround over broad user-agent spoofing or aggressive page rewriting.

## 📄 License

MIT — see [LICENSE](LICENSE).
