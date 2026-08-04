# homebrew-tinycast

Homebrew tap for [Tinycast](https://github.com/abue-ammar/tinycast) — a tiny, fully native
macOS launcher with hotkeys and clipboard history.

```sh
brew trust --tap abue-ammar/tinycast   # required for third-party taps
brew tap abue-ammar/tinycast
brew install --cask tinycast          # stable channel  (macOS 26 Tahoe and newer)
brew install --cask tinycast@beta     # beta channel    (macOS 26+, side-by-side)
brew install --cask tinycast-sequoia  # stable channel  (macOS 15 Sequoia)
```

`tinycast` and `tinycast@beta` are distinct apps (`Tinycast.app`, `Tinycast Beta.app`) with
their own bundle ids, so you can run stable + the beta at the same time.

## macOS 15 (Sequoia)

Tinycast's main build uses Liquid Glass, which needs macOS 26. `tinycast-sequoia` is the same
app built for macOS 15, with the glass surfaces falling back to native vibrancy. Everything
else is identical, and it tracks the same version as the stable channel.

Pick by your OS — Homebrew enforces it either way:

| macOS | Cask |
|---|---|
| 26 (Tahoe) or newer | `tinycast` · `tinycast@beta` |
| 15 (Sequoia) | `tinycast-sequoia` |

`tinycast` declares `depends_on macos: :tahoe`, so a Sequoia machine can never be handed the
macOS 26 build by mistake. `tinycast-sequoia` ships `Tinycast.app` under the same
`com.tinycast.app` bundle id as the stable cask — that is what carries your preferences,
clipboard history, login item and Accessibility grant across a later upgrade — so the two
`conflicts_with` each other and cannot be installed at the same time.

**Upgrading Sequoia → macOS 26** — swap casks once; your settings and permissions survive:

```sh
brew uninstall --cask tinycast-sequoia   # plain uninstall, NOT `--zap`
brew install --cask tinycast
```

`--zap` would delete the Application Support / Preferences data you are trying to keep.

macOS 15 is the hard floor; macOS 14 and earlier are not supported.

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

The `version` and `sha256` fields are bumped automatically by the release workflows in the
[main repo](https://github.com/abue-ammar/tinycast) whenever a build is published —
`release.yml` for `tinycast` / `tinycast@beta`, `release-sequoia.yml` for `tinycast-sequoia`.
Do not edit them by hand.
