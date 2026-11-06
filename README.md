<div align="center">

# 🧭 Safari Fixer

**Compatibility helpers for Safari on legacy iOS**

[![Build](https://github.com/felovdev/SafariFixer-iOS12/actions/workflows/build.yml/badge.svg)](https://github.com/felovdev/SafariFixer-iOS12/actions/workflows/build.yml)
[![iOS](https://img.shields.io/badge/iOS-12.0%2B-0A84FF?logo=apple&logoColor=white)](https://www.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

*An experimental jailbreak tweak to make legacy Safari a little more reliable on today's web.*

</div>

---

## ✨ Goals

Safari Fixer targets **MobileSafari on iOS 12**. The initial version adds a small page-level helper focused on:

- 🎬 Retrying an HTML5 video element **once** after a network error when a page is restored or becomes visible again.
- 📱 Adding inline-playback attributes to video elements that omit them.
- 🔄 Handling video elements inserted dynamically after the initial page load.
- 🧩 Providing a conservative foundation for site-specific compatibility fixes based on reproducible bugs.

The tweak does not spoof the browser identity, aggressively rewrite websites, or automatically reload every embedded player. It deliberately does not retry decode/unsupported-format errors because repeated `load()` calls cannot add missing codec support.

## 🎯 Target configuration

| Component | Target |
|---|---|
| Device | iPhone 5s (A7, arm64) |
| iOS | 12.5.8 |
| Jailbreak | Chimera, rootful |
| Browser | Apple Safari / MobileSafari |
| Package | Debian `.deb`, `iphoneos-arm` |

Packages are built remotely with **Theos + GitHub Actions**. A local Xcode installation is not required. Successful builds also publish a basic APT repository for Sileo and other compatible package managers via GitHub Pages.

## 📦 Build

A push to `main`, a pull request, or a manual workflow dispatch starts the build.

1. Open the [Actions tab](https://github.com/felovdev/SafariFixer-iOS12/actions).
2. Select the latest **Build Safari Fixer** run.
3. When it finishes, open **Artifacts** and download `SafariFixer-iOS12-deb`.
4. Extract the ZIP to get the `.deb` package.

The workflow uses GNU Make, Theos, iOS SDK headers, and validates the resulting Debian package. A successful CI run confirms compilation and packaging only. It is not proof of runtime compatibility on a physical device.

## ➕ Add the repository to Sileo

After the first successful publish, enable GitHub Pages once:

1. Open **Settings → Pages** in this repository.
2. Under **Build and deployment → Source**, select **GitHub Actions**.
3. Wait for the **Build and publish Safari Fixer APT repository** workflow to finish successfully.

Then add this source in Sileo:

```
https://felovdev.github.io/SafariFixer-iOS12/
```

In Sileo, open **Sources → +**, paste the URL, and add it. Search for **Safari Fixer** to install it. The source URL becomes usable only after GitHub Pages has been enabled and the workflow has successfully deployed; it is not the normal GitHub repository URL.

## 📲 Install and remove

Do not install an untested development build on your daily-use device.

1. Transfer the `.deb` to the iPhone.
2. Open it in Filza and install it.
3. Respring or reboot if requested by the package manager.
4. Test Safari using a reproducible page that previously failed.

**Removal:** use Sileo (or another package manager), find **Safari Fixer**, then choose **Modify → Remove**. If using a terminal with package-management access, the package identifier is:

```sh
dpkg -r com.felovdev.safarifixer
```

Keep Sileo or another recovery route available before installing development builds. If Safari becomes unstable, remove the tweak rather than repeatedly reinstalling it.

## ⚠️ Compatibility limits

This project cannot turn iOS 12's old WebKit into a modern browser engine.

- Changing the User-Agent cannot add missing JavaScript APIs, CSS features, or browser capabilities.
- iOS Safari does not provide the Media Source Extensions (MSE) support needed by some JavaScript video players, including MSE-based playback paths used by libraries such as hls.js.
- Native HLS playback may work, but codecs, containers, DRM, server behavior, and player implementation still matter.
- Safari may discard a page's JavaScript/player state when a tab is closed or unloaded. Retrying a network-failed HTML5 video element can help in limited cases, but cannot guarantee recovery of a third-party iframe or server-side playback session.
- GitHub, Pinterest, Kodik, and other complex sites may remain partially or completely incompatible.

**No universal website or video support is promised.** The Kodik restore issue still needs on-device reproduction and diagnosis.

## 🛠 Project layout

```
.
├── .github/workflows/build.yml
├── SafariFixer.plist
├── Makefile
├── control
├── Tweak.xm
├── LICENSE
└── README.md
```

## 🐛 Bug reports

Please include:
- device model, iOS version, and jailbreak;
- the affected page URL (remove private tokens and account-specific query strings);
- expected behavior and actual behavior;
- whether it also happens after a fresh Safari launch;
- for video issues, the player name and exact error message.

Never include passwords, cookies, session tokens, or private account data.

## 🗺 Roadmap

- [x] Theos project scaffold
- [x] GitHub Actions packaging workflow
- [x] Initial HTML5 video restore helper
- [ ] Confirm CI build on GitHub Actions
- [ ] Reproduce the Kodik restore error on iOS 12.5.8
- [ ] Add narrowly-scoped fixes for confirmed player/site bugs
- [ ] Test installation, stability, and removal on iPhone 5s + Chimera

## 🤝 Contributing

Focused bug reports and pull requests are welcome. Prefer small, testable workarounds over broad User-Agent spoofing or aggressive page rewriting.

## 📄 License

MIT — see [LICENSE](LICENSE).
