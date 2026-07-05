# homebrew-tinycast

Homebrew tap for [Tinycast](https://github.com/abue-ammar/tinycast) — a tiny, fully native
macOS launcher with hotkeys and clipboard history.

```sh
brew tap abue-ammar/tinycast
brew install --cask tinycast          # stable channel
brew install --cask tinycast@alpha    # alpha channel (side-by-side)
brew install --cask tinycast@beta     # beta channel  (side-by-side)
```

Each channel is a distinct app (`Tinycast.app`, `Tinycast Alpha.app`, `Tinycast Beta.app`)
with its own bundle id, so you can run stable + a pre-release at the same time.

## Note on signing

Tinycast has no Apple Developer ID and is not notarized. macOS quarantines the app on
install; the cask prints the one-time command to clear it:

```sh
xattr -dr com.apple.quarantine "/Applications/Tinycast.app"
```

## Automation

The `version` and `sha256` fields are bumped automatically by the Release workflow in the
[main repo](https://github.com/abue-ammar/tinycast) whenever a build is published — do not
edit them by hand.
