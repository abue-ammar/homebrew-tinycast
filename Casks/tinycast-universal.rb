cask "tinycast-universal" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (stable channel, `universal` job). Placeholder until the first universal release is cut.
  version "0.12.8"
  sha256 "75b0ced32643ec477dd2f4bcf4d959c9bc699904f92a5c559dd0657fc85f2aee"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-Universal-#{version}.dmg"
  name "Tinycast"
  desc "Tiny, fully native launcher, hotkeys, and clipboard history (universal build)"
  homepage "https://github.com/abue-ammar/tinycast"

  # Same app name and bundle id as `tinycast`, so the two can't coexist.
  conflicts_with cask: "abue-ammar/tinycast/tinycast"
  # macOS 26 is the last release that boots on Intel, and this is the build those Macs need.
  # Deliberately no `arch` guard: it runs everywhere, and `tinycast` is the leaner arm64 choice.
  depends_on macos: :tahoe

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
