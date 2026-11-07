# homebrew-tinycast

Homebrew tap for the universal build of [Tinycast](https://github.com/abue-ammar/tinycast), for Intel
Macs.

```sh
brew trust --tap abue-ammar/tinycast     # required for third-party taps
brew tap abue-ammar/tinycast
brew install --cask tinycast-universal  # stable (macOS 26 Tahoe, Intel)
```

macOS 26 Tahoe is the last release that boots on Intel. `tinycast-universal` is the stable release
built with both slices, so it runs on those Macs. It installs the same `Tinycast.app` as the
official `tinycast` cask, so only one of the two can be installed at a time.

On Apple silicon, install `tinycast` or `tinycast@beta` from Homebrew's official casks instead.

If you installed `tinycast` or `tinycast@beta` from this tap, do nothing: `tap_migrations.json`
moves it to `homebrew/cask` on your next `brew update`, without a reinstall.

## Note on signing

Releases are signed with Tinycast's Apple Developer ID and notarized by Apple, so they open without
a warning, through Homebrew or from the DMG.

## Automation

The `version` and `sha256` fields of `tinycast-universal` are bumped automatically by the
`universal` job of `release.yml` in the [main repo](https://github.com/abue-ammar/tinycast)
whenever a stable build is published. Do not edit them by hand.
