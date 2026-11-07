# Tinycast for Intel Macs

> [!IMPORTANT]
> **This tap is only for Intel Macs.**

## Install on an Intel Mac

```sh
brew trust --tap abue-ammar/tinycast     # required for third-party taps
brew tap abue-ammar/tinycast
brew install --cask tinycast-universal
```

It needs macOS 26 Tahoe, the last release that runs on Intel.

## About this build

`tinycast-universal` is the stable release of [Tinycast](https://github.com/abue-ammar/tinycast),
built to run on Intel Macs.

## Signing

Releases are signed with Tinycast's Apple Developer ID and notarized by Apple, so they open without
a warning, through Homebrew or from the DMG.

## Automation

The `version` and `sha256` fields of `tinycast-universal` are bumped automatically by the
`universal` job of `release.yml` in the [main repo](https://github.com/abue-ammar/tinycast)
whenever a stable build is published. Do not edit them by hand.
