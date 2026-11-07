# homebrew-tinycast

Homebrew tap for [Tinycast](https://github.com/abue-ammar/tinycast) — a tiny, fully native
macOS launcher with hotkeys and clipboard history.

Tinycast and its beta for Apple silicon are in Homebrew's official casks and need no tap:

```sh
brew install --cask tinycast        # stable   (macOS 26+)
brew install --cask tinycast@beta   # beta     (macOS 26+, side-by-side)
```

This tap carries the universal build:

```sh
brew trust --tap abue-ammar/tinycast     # required for third-party taps
brew tap abue-ammar/tinycast
brew install --cask tinycast-universal  # stable   (macOS 26 Tahoe, Intel)
```

If you installed `tinycast` or `tinycast@beta` from this tap, do nothing: `tap_migrations.json`
moves it to `homebrew/cask` on your next `brew update`, without a reinstall.

`tinycast` and `tinycast@beta` are distinct apps (`Tinycast.app`, `Tinycast Beta.app`) with
their own bundle ids, so you can run stable + the beta at the same time.

## Intel Macs (macOS 26)

macOS 26 Tahoe is the last release that boots on Intel, so stable ships twice from the same
build: `tinycast` is a lean arm64-only DMG, and `tinycast-universal` carries both slices.

`tinycast` declares `depends_on arch: :arm64`, so an Intel Mac is refused it rather than handed
an app that cannot launch. `tinycast-universal` has no arch guard — it runs on Apple silicon
too, it is simply the larger download, so there is no reason to prefer it there.

## Note on signing

Releases are signed with Tinycast's Apple Developer ID and notarized by Apple, so they open without
a warning, through Homebrew or from the DMG.

## Automation

The `version` and `sha256` fields of `tinycast-universal` are bumped automatically by
`release.yml` in the [main repo](https://github.com/abue-ammar/tinycast) whenever a stable build is
published. Do not edit them by hand.
