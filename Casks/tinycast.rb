cask "tinycast" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (stable channel). Placeholder until the first stable release is cut.
  version "0.0.0"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-#{version}.dmg",
      verified: "github.com/abue-ammar/tinycast/"
  name "Tinycast"
  desc "Tiny, fully native launcher, hotkeys, and clipboard history"
  homepage "https://github.com/abue-ammar/tinycast"

  depends_on macos: :tahoe

  app "Tinycast.app"

  # Tinycast is signed with a stable self-signed identity (not an Apple Developer ID / not
  # notarized), so macOS quarantines it. Strip the flag on every install AND upgrade so
  # Gatekeeper won't block launch — the user never has to run xattr by hand. Then relaunch
  # (background, `-g`, so it doesn't steal focus) so an upgrade drops the user back into a
  # running Tinycast; `uninstall quit:` closed the old copy first.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Tinycast.app"]
    system_command "/usr/bin/open",
                   args: ["-g", "#{appdir}/Tinycast.app"]
  end

  # Quit the running app before Homebrew replaces the bundle on upgrade/uninstall — otherwise
  # the update clobbers a live process. postflight relaunches it after an upgrade (not uninstall).
  uninstall quit: "com.tinycast.app"

  zap login_item: "Tinycast",
      trash:      [
        "~/Library/Caches/com.tinycast.app",
        "~/Library/Preferences/com.tinycast.app.plist",
      ]

  caveats <<~EOS
    Tinycast is not signed with an Apple Developer ID and is not notarized
    (this project has no paid Apple account). Homebrew clears the macOS quarantine
    flag for you automatically on install and every update, so there's nothing to run.
    Upgrading via `brew` quits and relaunches Tinycast for you.
  EOS
end
