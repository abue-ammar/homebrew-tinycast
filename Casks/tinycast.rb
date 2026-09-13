cask "tinycast" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (stable channel). Placeholder until the first stable release is cut.
  version "0.10.20"
  sha256 "a0003d9b1566568a76b1fcb553914ff1ae328af6398cc177e26a6177199cf3fc"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-#{version}.dmg"
  name "Tinycast"
  desc "Tiny, fully native launcher, hotkeys, and clipboard history"
  homepage "https://github.com/abue-ammar/tinycast"

  # Same app name and bundle id as the Sequoia and universal casks, so no two can coexist.
  conflicts_with cask: [
    "abue-ammar/tinycast/tinycast-sequoia",
    "abue-ammar/tinycast/tinycast-universal",
  ]
  # This DMG is arm64-only. Intel Macs run macOS 26 too, and take `tinycast-universal` instead.
  depends_on arch: :arm64
  # `:tahoe` already means ">= macOS 26"; macOS 15 takes the `tinycast-sequoia` cask instead.
  depends_on macos: :tahoe

  app "Tinycast.app"

  # Tinycast is signed with a stable self-signed identity (not an Apple Developer ID / not
  # notarized), so macOS quarantines it. Strip the flag on every install AND upgrade so
  # Gatekeeper won't block launch — the user never has to run xattr by hand.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Tinycast.app"]
  end

  # Quit the running app before Homebrew replaces the bundle on upgrade/uninstall — otherwise
  # the update clobbers a live process.
  uninstall quit: "com.tinycast.app"

  zap login_item: "Tinycast",
      trash:      [
        "~/Library/Application Support/com.tinycast.app",
        "~/Library/Caches/com.tinycast.app",
        "~/Library/Preferences/com.tinycast.app.plist",
        "~/Library/Saved Application State/com.tinycast.app.savedState",
      ]
end
