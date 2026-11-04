cask "tinycast" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (stable channel). Placeholder until the first stable release is cut.
  version "0.12.1"
  sha256 "e9d3da2c0a1bb3b813ce41cce52934fbd07c04941689cf4e8e58ba3284f796c5"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-#{version}.dmg"
  name "Tinycast"
  desc "Tiny, fully native launcher, hotkeys, and clipboard history"
  homepage "https://github.com/abue-ammar/tinycast"

  # Same app name and bundle id as the universal cask, so the two can't coexist.
  conflicts_with cask: "abue-ammar/tinycast/tinycast-universal"
  depends_on macos: :tahoe
  # This DMG is arm64-only. Intel Macs run macOS 26 too, and take `tinycast-universal` instead.
  depends_on arch: :arm64

  app "Tinycast.app"

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
