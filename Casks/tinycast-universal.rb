cask "tinycast-universal" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (stable channel, `universal` job). Placeholder until the first universal release is cut.
  version "0.10.15"
  sha256 "b58256ad88b38d5936a5b1755d40c5191e7faf8414091245069ecc344343d902"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-Universal-#{version}.dmg"
  name "Tinycast"
  desc "Tiny, fully native launcher, hotkeys, and clipboard history (universal build)"
  homepage "https://github.com/abue-ammar/tinycast"

  # Same app name and bundle id as the mainline and Sequoia casks, so no two can coexist.
  conflicts_with cask: [
    "abue-ammar/tinycast/tinycast",
    "abue-ammar/tinycast/tinycast-sequoia",
  ]
  # macOS 26 is the last release that boots on Intel, and this is the build those Macs need.
  # Deliberately no `arch` guard: it runs everywhere, and `tinycast` is the leaner arm64 choice.
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
