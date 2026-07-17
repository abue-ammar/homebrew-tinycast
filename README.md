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

Tinycast has no Apple Developer ID and is not notarized, but it *is* signed with a stable
self-signed identity — so macOS keeps your Accessibility permission across updates instead of
re-prompting each time. The cask also clears the macOS quarantine flag automatically on every
install and update (`postflight`), so **you never need to run `xattr` by hand** when installing
through Homebrew.

(If you download the DMG directly from Releases instead of using Homebrew, macOS will quarantine
it and you'll need to clear the flag once yourself:
`xattr -dr com.apple.quarantine "/Applications/Tinycast.app"`.)

## Automation

The `version` and `sha256` fields are bumped automatically by the Release workflow in the
[main repo](https://github.com/abue-ammar/tinycast) whenever a build is published — do not
edit them by hand.
